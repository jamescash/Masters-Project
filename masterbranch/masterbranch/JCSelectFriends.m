//
//  JCSelectFriends.m
//  PreAmp
//
//  Created by james cash on 19/09/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCSelectFriends.h"

@interface JCSelectFriends ()

@property (nonatomic,strong) NSArray *MyFriends;
@property (nonatomic,strong) PFRelation *FriendRelations;
@property (nonatomic,strong) NSMutableArray *recipents;

//actions
- (IBAction)CancleButton:(id)sender;
- (IBAction)Send:(id)sender;



@end

@implementation JCSelectFriends

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Select Friends";
    [self getMyFriends];
    self.recipents = [[NSMutableArray alloc]init];
    
    
    
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
    return self.MyFriends.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    
    PFUser *user = [self.MyFriends objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    
    if ([self.recipents containsObject:user.objectId]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else {
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PFUser *user = [self.MyFriends objectAtIndex:indexPath.row];
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
  
    //add and remove recipients as the user selects names
    if (cell.accessoryType == UITableViewCellAccessoryNone ) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.recipents addObject:user.objectId];
    }else{
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.recipents removeObject:user.objectId];
        
    }
    
}



-(void)getMyFriends{
    
     self.FriendRelations = [[PFUser currentUser] objectForKey:@"FriendsRelation"];
    PFQuery *query  = [self.FriendRelations query];
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"Error coming form insode get my firends relations %@",error);
        }
        
        self.MyFriends = objects;
        [self.tableView reloadData];
        
    }];
}



- (IBAction)CancleButton:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.recipents removeAllObjects];
}

- (IBAction)Send:(id)sender {
    
    
    //defensive code
    if (self.currentEvent == nil) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Try again!" message:@"Ooops something went wrong" delegate:self cancelButtonTitle:@"okay" otherButtonTitles:nil];
        [alert show];
        
        
        NSLog(@"%@ SENDER BUTTION",self.currentEvent.eventTitle);
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {
        
        //Seems like we have an event object lets upload it then dismiss the VC
        [self uploadMessage];
        [self.recipents removeAllObjects];
        [self dismissViewControllerAnimated:YES completion:nil];
      }
    
}


-(void)uploadMessage{
    
    //Upload the file
    //Upload message detatils
    
    
    
}
@end
