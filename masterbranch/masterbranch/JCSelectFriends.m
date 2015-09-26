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
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {
        
        //Seems like we have an event object lets upload it then dismiss the VC
        [self uploadMessage];
        [self dismissViewControllerAnimated:YES completion:nil];
      }
    
}


-(void)uploadMessage{
    
    NSData *fileData;
    NSString *fileName;
    NSString *fileType;
    
    
    fileData = UIImagePNGRepresentation(self.currentEvent.photoDownload.image);
    fileName = @"image.png";
    fileType = @"EventImage";
                                         
    PFFile *file = [PFFile fileWithName:fileName data:fileData];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        
        //chaning the two asynrons upplaods to parse so users dont have to wait and only the second one happens if the first one
        //is sucesful
        
        
        if (error) {
            //show alert view
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"An error oh shit!" message:@"Please try sending that message again" delegate:self cancelButtonTitle:@"okay" otherButtonTitles:nil];
            [self.recipents removeAllObjects];

            [alert show];
        }else{
            //file saved sucessfully now lets link it with a PFobject so we can send it
            PFObject *message = [PFObject objectWithClassName:@"Messages"];
            [message setObject:file forKey:@"file"];
            [message setObject:fileType forKey:@"fileType"];
            [message setObject:self.recipents forKey:@"recipientIds"];
            [message setObject:[[PFUser currentUser]objectId] forKey:@"senderId"];
            [message setObject:[[PFUser currentUser]username] forKey:@"senderName"];
            [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
               
                if (error) {
                    //show alert view
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oh shit!" message:@"Please try sending that message again there was an error" delegate:self cancelButtonTitle:@"okay" otherButtonTitles:nil];
                    [alert show];
                }else{
                    
                    //sent to reipents so now remove them all to start with a blank slate the next time
                    [self.recipents removeAllObjects];

                    NSLog(@"Message sent to parse sucessfully");
                }
           
            }];
            
        }
    
    
    }];
    
    
    
}
@end
