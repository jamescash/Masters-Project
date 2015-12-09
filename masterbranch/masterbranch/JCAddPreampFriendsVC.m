//
//  JCAddPreampFriendsVC.m
//  PreAmp
//
//  Created by james cash on 15/11/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCAddPreampFriendsVC.h"
#import "JCParseQuerys.h"
#import "JCMyFriendsCell.h"
#import <Parse/Parse.h>


@interface JCAddPreampFriendsVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableviewcontoller;
@property (nonatomic,strong) NSString *userFbId;
@property (nonatomic,strong) NSArray *tableViewDataSource;
@property (weak, nonatomic) IBOutlet UISearchBar *searchbarVC;
@property (nonatomic,strong) JCParseQuerys *JCParseQuerys;

@end

@implementation JCAddPreampFriendsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenName = @"Add PreampFriends Screen";
    self.searchbarVC.placeholder = @"search by username";
    self.JCParseQuerys = [JCParseQuerys sharedInstance];
    //self.userFbId = [[PFUser currentUser] objectForKey:@"facebookId"];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - TableView Delaget

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.tableViewDataSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    JCMyFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendsCell" forIndexPath:indexPath];
    PFUser *user = [self.tableViewDataSource objectAtIndex:indexPath.row];
    [cell formateCell:user];
    
    PFFile *profilePic = [user objectForKey:@"thumbnailProfilePicture"];
    cell.userImage.file = profilePic;
    [cell.userImage loadInBackground];
    
    
    
    if ([self IsFriend:user]) {
        
        UIImage *removeFriends = [UIImage imageNamed:@"iconRemoveFriend.png"];
        cell.cellButton.image = removeFriends;
        
    }else{
        UIImage *addFriends = [UIImage imageNamed:@"iconAddFriend.png"];
        cell.cellButton.image = addFriends;
        
    }
    





    return cell;

    //return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    [self.tableviewcontoller deselectRowAtIndexPath:indexPath animated:NO];
    JCMyFriendsCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    //if user tapped is a friend add them, else remove them
    PFUser *user = [self.tableViewDataSource objectAtIndex:indexPath.row];
    
    //if relation for the current key doesnt exist on parse it will be created otherwise the existing one is is returned
    PFRelation *FriendsRelation = [[PFUser currentUser] relationForKey:@"FriendsRelation"];
    
    
    if ([self IsFriend:user]) {
        UIImage *removeFriends = [UIImage imageNamed:@"iconRemoveFriend.png"];

       
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.cellButton.image = removeFriends;
         });
        
        
        for (PFUser *firend in self.myFriends){
            
            if ( [firend.objectId isEqualToString:user.objectId] ) {
                [self.myFriends removeObject:firend];
                break;
            }
            [PFObject unpinAllObjectsInBackgroundWithName:@"MyFriends"];
            [FriendsRelation removeObject:user];
        }
    }else{
        
        
        
        UIImage *addFriends = [UIImage imageNamed:@"iconAddFriend.png"];

        dispatch_async(dispatch_get_main_queue(), ^{
            cell.cellButton.image = addFriends;
        });
        
        
        
        [self.myFriends addObject:user];
        [PFObject unpinAllObjectsInBackgroundWithName:@"MyFriends"];
        [FriendsRelation addObject:user];
        [self.JCParseQuerys postActivtyForUserActionAddFriend:user completionBlock:^(NSError *error) {
            
            if (error) {
                NSLog(@"%@",error);
            }
            
        }];
        
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableviewcontoller reloadData];
    });
    
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error){
            
            NSLog(@"error saving friend relation delete friend %@",error);
        }
    }];
}


#pragma - helper methods






-(BOOL)IsFriend:(PFUser *)user{
    
    for (PFUser *firend in self.myFriends){
        
        if ( [firend.objectId isEqualToString:user.objectId] ) {
            return YES;
        }
    }
    
    return NO;
}


#pragma - search bar delagete

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
   
    NSString *searchQuery = [searchBar.text lowercaseString];
    [self searchForUserByUserNamr:searchQuery];
    self.searchbarVC.text = @"";
    [self.searchbarVC resignFirstResponder];
}


- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
    NSLog(@"searchBarTextDidEndEditing");
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    NSLog(@"searchBarCancelButtonClicked");
}


- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText{
    
    if ([searchBar.text length] > 3 ) {
        
        NSString *searchQuery = [searchBar.text lowercaseString];
        [self searchForUserByUserNamr:searchQuery];
    }
    
}



-(void)searchForUserByUserNamr: (NSString*) searchQuery{
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"searchUsername" hasPrefix:searchQuery];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        self.tableViewDataSource = objects;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableviewcontoller reloadData];
        });
        
    }];
}


@end
