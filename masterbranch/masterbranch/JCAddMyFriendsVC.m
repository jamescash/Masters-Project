//
//  JCAddMyFriendsVC.m
//  PreAmp
//
//  Created by james cash on 21/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCAddMyFriendsVC.h"
#import <Parse/Parse.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import "JCParseQuerys.h"

#import "JCMyFriendsCell.h"



//
//PFQuery *query = [PFQuery queryWithClassName:@"GameScore"];
//[query whereKey:@"playername" equalTo:@"Sean Plott"];
//[query countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
//    if (!error) {
//        // The count request succeeded. Log the count
//        NSLog(@"Sean has played %d games", count);
//    } else {
//        // The request failed
//    }
//}];


@interface JCAddMyFriendsVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableviewcontoller;
@property (nonatomic,strong) NSString *userFbId;
@property (nonatomic,strong) NSArray *tableViewDataSource;
@property (weak, nonatomic) IBOutlet UISearchBar *searchbarVC;
@property (nonatomic,strong) JCParseQuerys *JCParseQuerys;

- (IBAction)buttonPreAmp:(id)sender;
- (IBAction)buttonFacebook:(id)sender;
@end

@implementation JCAddMyFriendsVC{
    bool isFacebookSearch;
}

- (void)viewDidLoad {
    self.JCParseQuerys = [JCParseQuerys sharedInstance];
    [super viewDidLoad];
    isFacebookSearch = YES;
    self.userFbId = [[PFUser currentUser] objectForKey:@"facebookId"];
    [self getusersFacebookfriebnds];
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
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    

    
  
    
        return cell;

    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

    [self.tableviewcontoller deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    //if user tapped is a friend add them, else remove them
    PFUser *user = [self.tableViewDataSource objectAtIndex:indexPath.row];
    
    //if relation for the current key doesnt exist on parse it will be created otherwise the existing one is is returned
    PFRelation *FriendsRelation = [[PFUser currentUser] relationForKey:@"FriendsRelation"];
    
    
    if ([self IsFriend:user]) {
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        for (PFUser *firend in self.myFriends){
            
            if ( [firend.objectId isEqualToString:user.objectId] ) {
                [self.myFriends removeObject:firend];
                break;
            }
            [user unpinInBackground];
            [FriendsRelation removeObject:user];
        }
    }else{
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.myFriends addObject:user];
        [user pinInBackgroundWithName:@"MyFriends"];
        [FriendsRelation addObject:user];
        
    }
    
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error){
            
            NSLog(@"error saving friend relation delete friend %@",error);
        }
    }];
}

#pragma - facebook

-(void)getusersFacebookfriebnds{
    
    
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"/me/friends"
                                  parameters:nil
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        
        NSArray *facebookUsers = result[@"data"];
        NSMutableArray *facebookUserIds = [[NSMutableArray alloc]init];
        for (NSDictionary *facebookUser in facebookUsers) {
            NSString *FBUserId = facebookUser[@"id"];
            [facebookUserIds addObject:FBUserId];
        }
        
        [self.JCParseQuerys getPreAmpUsersThatMatchTheseFBids:facebookUserIds completionblock:^(NSError *error, NSArray *response) {
           
            if (error) {
                NSLog(@"error getting Users for FBIds %@",error);
            }else{
                self.tableViewDataSource = response;

              
                
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableviewcontoller reloadData];
                });
            }
            
        }];
    }];
}

#pragma - helper methods

- (IBAction)buttonPreAmp:(id)sender {
    self.searchbarVC.placeholder = @"search by username";
    self.tableViewDataSource = nil;
    [self.tableviewcontoller reloadData];
    isFacebookSearch = NO;
}

- (IBAction)buttonFacebook:(id)sender {
    
    isFacebookSearch = YES;
    self.tableViewDataSource = nil;
    [self.tableviewcontoller reloadData];
    self.searchbarVC.placeholder = @"search by name";
    [self getusersFacebookfriebnds];
}




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
    
    if (!isFacebookSearch) {
        NSString *searchQuery = [searchBar.text lowercaseString];
        [self searchForUserByUserNamr:searchQuery];
    }
    
    

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
    
    if ([searchBar.text length] > 0 ) {
        
        NSString *searchQuery = [searchBar.text lowercaseString];
        [self searchForUserByUserNamr:searchQuery];
    }

}



-(void)searchForUserByUserNamr: (NSString*) searchQuery{
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"searchUsername" hasPrefix:searchQuery];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        self.tableViewDataSource = objects;
        NSLog(@"%@",objects);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableviewcontoller reloadData];
        });
        
    }];
}







@end
