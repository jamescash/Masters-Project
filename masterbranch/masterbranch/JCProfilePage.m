//
//  JCProfilePage.m
//  PreAmp
//
//  Created by james cash on 15/09/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "JCProfilePage.h"
#import "JCAddFriendsVC.h"


@interface JCProfilePage ()
@property (weak, nonatomic) IBOutlet UITableView *FriendsList;
@property (nonatomic,strong) NSArray *MyFriends;
@property (nonatomic,strong) PFRelation *FriendRelations;

@end

@implementation JCProfilePage

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self getMyFriends];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"AddFriends"]){
        //Pass list of friends to add freinds VC so it knows who's alrealdy your friends3
        JCAddFriendsVC *addfirendsPage = (JCAddFriendsVC*)segue.destinationViewController;
        addfirendsPage.Friends = [NSMutableArray arrayWithArray:self.MyFriends];
        
    }
};


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.MyFriends.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
  
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    
    PFUser *user = [self.MyFriends objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - Helper Methods

-(void)getMyFriends{
    
    
    self.FriendRelations = [[PFUser currentUser] objectForKey:@"FriendsRelation"];
    PFQuery *query  = [self.FriendRelations query];
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"Error coming form insode get my firends relations %@",error);
        }
        
        self.MyFriends = objects;
        [self.FriendsList reloadData];
        
    }];
}




@end
