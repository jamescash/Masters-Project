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
#import "JCEventInviteCell.h"





@interface JCGigInvitesVC ()
//UI elements
@property (weak, nonatomic) IBOutlet UITableView *MyGigInvitesTable;

//Properties
@property (nonatomic,strong) PFObject *selectedInvite;
@property (nonatomic,strong) UIImage *selectedInviteImage;
@property (nonatomic,strong) NSArray *myInvites;
@property (nonatomic,strong) NSMutableArray *imageFiles;

//classes
@property (nonatomic,strong) JCParseQuerys *JCParseQuery;




@end

@implementation JCGigInvitesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.JCParseQuery = [JCParseQuerys sharedInstance];
    self.imageFiles = [[NSMutableArray alloc]init];
    
    [self.JCParseQuery getMyInvites:^(NSError *error, NSArray *response) {
        
        self.myInvites = response;
    
    //creat an arrray of images so we can download them asyn
    for (PFObject *event in response) {
           PFFile *imageFile = [event objectForKey:@"eventPhoto"];
          [self.imageFiles addObject:[@{@"pfFile":imageFile} mutableCopy]];
        }
    
        [self.MyGigInvitesTable reloadData];
    }];
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
    
    
    JCEventInviteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventInviteCell"forIndexPath:indexPath];
    //PFObject *eventInvite = [self.myInvites objectAtIndex:indexPath.row];
    //cell.textLabel.text = [eventInvite objectForKey:@"eventHostName"];
    
    UIImage *eventImage = self.imageFiles[indexPath.row][@"image"];

    if (eventImage) {
        cell.BackRoundImage.image = eventImage;
        cell.BackRoundImage.contentMode = UIViewContentModeScaleAspectFill;
    }else {
        cell.BackRoundImage.image = [UIImage imageNamed:@"Placeholder.png"];
        cell.BackRoundImage.contentMode = UIViewContentModeScaleAspectFill;

        [self DownloadImageForeventAtIndex:indexPath completion:^(UIImage* image, NSError* error) {
            if (!error) {
                [self.MyGigInvitesTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            
        }];
       }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selectedInvite = [self.myInvites objectAtIndex:indexPath.row];
    JCEventInviteCell *cellatindex = [[JCEventInviteCell alloc]init];
    cellatindex = [tableView cellForRowAtIndexPath:indexPath];
    self.selectedInviteImage = cellatindex.BackRoundImage.image;
    [self performSegueWithIdentifier:@"showEvent" sender:self];
 
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"showEvent"]) {
        JCInboxDetail *destinationVC = (JCInboxDetail*) segue.destinationViewController;
        destinationVC.userEvent = self.selectedInvite;
        destinationVC.selectedInviteImage = self.selectedInviteImage;
    }
}



- (void)DownloadImageForeventAtIndex:(NSIndexPath *)indexPath completion:(void (^)( UIImage *,NSError*)) completion {
    
    // if we fetched already, just return it via the completion block
    UIImage *existingImage = self.imageFiles[indexPath.row][@"image"];
    
    if (existingImage){
       completion(existingImage, nil);
    }
    
    PFFile *pfFile = self.imageFiles[indexPath.row][@"pfFile"];
    
    
    [pfFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *eventImage = [UIImage imageWithData:imageData];
            self.imageFiles[indexPath.row][@"image"] = eventImage;
            completion(eventImage, nil);
        } else {
            completion(nil, error);
        }
    }];
}















@end
