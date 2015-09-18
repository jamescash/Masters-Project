//
//  JCAddFriendsVC.m
//  PreAmp
//
//  Created by james cash on 18/09/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCAddFriendsVC.h"
#import <Parse/Parse.h>

@interface JCAddFriendsVC ()
@property (nonatomic,strong)PFUser *CurrentUser;

@end

@implementation JCAddFriendsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //query for all the users
    PFQuery *query = [PFUser query];
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"Error getting PFusers %@ %@",error,error.userInfo);
        }
        else {
            
            self.AllUsers = objects;
            //NSLog(@"%@",self.AllUsers);
            [self.tableView reloadData];
        }
        
        
    }];
    
    self.CurrentUser = [PFUser currentUser];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.AllUsers.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *reuseID = @"Users";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID forIndexPath:indexPath];
    
    PFUser *user = [self.AllUsers objectAtIndex:indexPath.row];
   
    cell.textLabel.text = user.username;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    PFRelation *FriendsRelation = [self.CurrentUser relationForKey:@"FriendsRelation"];
    PFUser *user = [self.AllUsers objectAtIndex:indexPath.row];
    [FriendsRelation addObject:user];
    [self.CurrentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error){
            
            NSLog(@"error saving friend relation %@",error);
        }
      
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
