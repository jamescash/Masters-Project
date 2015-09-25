//
//  JCInbox.m
//  PreAmp
//
//  Created by james cash on 19/09/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCInbox.h"
#import "JCInboxDetail.h"


@interface JCInbox ()
@property (weak, nonatomic) IBOutlet UITableView *receivedMessages;
@property (nonatomic,strong) NSArray *messages;
@property (nonatomic,strong) PFObject *selectedMessage;


@end

@implementation JCInbox

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewDidAppear:animated];


    PFQuery *query = [PFQuery queryWithClassName:@"Messages"];
    
    //only look at the recipent list and where selfs id is equaled that means this message was meant for me
    [query whereKey:@"recipientIds" equalTo:[[PFUser currentUser] objectId]];
    //order messages via createed at
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@ error receving messages",error);
        }else{
            NSLog(@"we found messages");
            self.messages = objects;
            [self.receivedMessages reloadData];
            NSLog(@"recived %lu messages",(unsigned long)[self.messages count]);
        }
    }];
    
}

#pragma - TableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.messages.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"forIndexPath:indexPath];
    PFObject *message = [self.messages objectAtIndex:indexPath.row];
    cell.textLabel.text = [message objectForKey:@"senderName"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selectedMessage = [self.messages objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"showDetailedView" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"showDetailedView"]) {
            JCInboxDetail *destinationVC = (JCInboxDetail*) segue.destinationViewController;
            destinationVC.message = self.selectedMessage;
     }
}

@end
