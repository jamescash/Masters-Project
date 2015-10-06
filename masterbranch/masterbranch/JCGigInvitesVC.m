//
//  JCGigInvitesVC.m
//  PreAmp
//
//  Created by james cash on 05/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCGigInvitesVC.h"
#import <Parse/Parse.h>
#import "JCParseQuerys.h"
#import "JCInboxDetail.h"



@interface JCGigInvitesVC ()
//UI elements
@property (weak, nonatomic) IBOutlet UITableView *MyGigInvitesTable;

//Properties
@property (nonatomic,strong) PFObject *selectedInvite;
@property (nonatomic,strong) UIImage *selectedInviteImage;
@property (nonatomic,strong) NSArray *myInvites;

//classes
@property (nonatomic,strong) JCParseQuerys *JCParseQuery;




@end

@implementation JCGigInvitesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.JCParseQuery = [JCParseQuerys sharedInstance];
    
    [self.JCParseQuery getMyInvites:^(NSError *error, NSArray *response) {
        
        self.myInvites = response;
        [self.MyGigInvitesTable reloadData];
    }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma - TableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.myInvites.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"forIndexPath:indexPath];
    PFObject *eventInvite = [self.myInvites objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [eventInvite objectForKey:@"eventHostName"];
    
    PFFile *imageFile = [eventInvite objectForKey:@"eventPhoto"];
    NSURL *imageFileURL = [[NSURL alloc]initWithString:imageFile.url];
    NSData *imageData = [NSData dataWithContentsOfURL:imageFileURL];
    //add it to a class property so we can pass it to the events page Class
    cell.imageView.image = [UIImage imageWithData:imageData];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selectedInvite = [self.myInvites objectAtIndex:indexPath.row];
    UITableViewCell *cellatindex = [[UITableViewCell alloc]init];
    cellatindex = [tableView cellForRowAtIndexPath:indexPath];
    self.selectedInviteImage = cellatindex.imageView.image;
    [self performSegueWithIdentifier:@"showEvent" sender:self];
 
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
        
    if ([segue.identifier isEqualToString:@"showEvent"]) {
        JCInboxDetail *destinationVC = (JCInboxDetail*) segue.destinationViewController;
        destinationVC.userEvent = self.selectedInvite;
        destinationVC.selectedInviteImage = self.selectedInviteImage;
    }
}

@end
