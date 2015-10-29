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
#import "JCConstants.h"

#import "RESideMenu.h"

#import <QuartzCore/QuartzCore.h>


#import "UIERealTimeBlurView.h"


#import "ILTranslucentView.h"



@interface JCGigInvitesVC ()
//UI elements
@property (weak, nonatomic) IBOutlet UITableView *MyGigInvitesTable;

//Properties
@property (nonatomic,strong) PFObject *selectedInvite;
@property (nonatomic,strong) UIImage *selectedInviteImage;
@property (nonatomic,strong) NSArray *tableViewDataSource;
@property (nonatomic,strong) NSMutableArray *imageFiles;
@property (weak, nonatomic) IBOutlet UIView *navBarDropDown;

//classes
@property (nonatomic,strong) JCParseQuerys *JCParseQuery;
@property (nonatomic,strong) ILTranslucentView *blerView;

@property (nonatomic,strong)JCDropDownMenu *contextMenu;

@end

@implementation JCGigInvitesVC{
    BOOL blerViewOn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCustomButtonOnNavBar];
    
   self.JCParseQuery = [JCParseQuerys sharedInstance];
    self.imageFiles = [[NSMutableArray alloc]init];
    
    [self.JCParseQuery getMyInvitesforType:JCUserEventUsersTypeUpcoming completionblock:^(NSError *error, NSArray *response) {
        
        if (error) {
            NSLog(@"getMyInvitesforType %@",error);
        }else{
            
            self.tableViewDataSource = response;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.MyGigInvitesTable reloadData];
            });
        }
     }];
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
    return self.tableViewDataSource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    JCEventInviteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventInviteCell"forIndexPath:indexPath];
    PFObject *eventInvite = [self.tableViewDataSource objectAtIndex:indexPath.row];
    [cell formatCell:eventInvite];
    
    PFFile *imageFile = [eventInvite objectForKey:@"eventPhoto"];

    cell.BackRoundImage.file = imageFile;
    cell.BackRoundImage.contentMode = UIViewContentModeScaleAspectFill;
    NSUInteger randomNumber = arc4random_uniform(5);
   
    switch (randomNumber) {
                case 0:
                    cell.BackRoundImage.image = [UIImage imageNamed:@"loadingYellow.png"];
                    cell.BackRoundImage.contentMode = UIViewContentModeScaleAspectFill;
    
                    break;
                case 1:
                    cell.BackRoundImage.image = [UIImage imageNamed:@"loadingPink.png"];
                    cell.BackRoundImage.contentMode = UIViewContentModeScaleAspectFill;
    
                    break;
                case 2:
                    cell.BackRoundImage.image = [UIImage imageNamed:@"loadingBlue.png"];
                    cell.BackRoundImage.contentMode = UIViewContentModeScaleAspectFill;
    
                    break;
                case 3:
                    cell.BackRoundImage.image = [UIImage imageNamed:@"loadingGreen.png"];
                    cell.BackRoundImage.contentMode = UIViewContentModeScaleAspectFill;
    
                    break;
                    
            }
    [cell.BackRoundImage loadInBackground];

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedInvite = [self.tableViewDataSource objectAtIndex:indexPath.row];
    JCEventInviteCell *cellatindex = [[JCEventInviteCell alloc]init];
    cellatindex = [tableView cellForRowAtIndexPath:indexPath];
    self.selectedInviteImage = cellatindex.BackRoundImage.image;
    [self performSegueWithIdentifier:@"showEvent" sender:self];
 
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"showEvent"]) {
        JCInboxDetail *destinationVC = (JCInboxDetail*) segue.destinationViewController;
        destinationVC.userEvent = self.selectedInvite;
        destinationVC.selectedInviteImage = self.selectedInviteImage;
    }
}
-(void)DownloadImageForeventAtIndex:(NSIndexPath *)indexPath completion:(void (^)( UIImage *,NSError*)) completion {
    
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

#pragma - Helper Method

- (void)addCustomButtonOnNavBar
{
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [menuButton setImage:[UIImage imageNamed:@"iconMenu.png"] forState:UIControlStateNormal];
    [menuButton setImage:[UIImage imageNamed:@"iconMenu.png"] forState:UIControlStateHighlighted];
    menuButton.adjustsImageWhenDisabled = NO;
    //set the frame of the button to the size of the image (see note below)
    menuButton.frame = CGRectMake(0, 0, 40, 40);
    menuButton.opaque = YES;
    
    [menuButton addTarget:self action:@selector(menuButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    //create a UIBarButtonItem with the button as a custom view
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    self.navigationItem.leftBarButtonItem = customBarItem;
    
    UITapGestureRecognizer *navbarRightButtonTapped =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(RightnavItemTapped)];
    
    [self.navBarDropDown addGestureRecognizer:navbarRightButtonTapped];
     self.navBarDropDown.backgroundColor = [UIColor grayColor];
    
}
-(void)menuButtonPressed{
    [self.sideMenuViewController presentLeftMenuViewController];
}

-(void)RightnavItemTapped{
    
    if (!self.contextMenu) {
        self.contextMenu = [[JCDropDownMenu alloc]initWithFrame:self.view.bounds];
        [self.navigationController.view addSubview:self.contextMenu];
        self.contextMenu.JCDropDownMenuDelagte = self;
        [self manageBleredLayer];

    }else{
        [self.contextMenu animatContextMenu];
        [self manageBleredLayer];

    }
}

-(void)manageBleredLayer{
    if (blerViewOn) {
        self.blerView.hidden=YES;
        blerViewOn=NO;
    }else{
        if (!self.blerView) {
            self.blerView = [[ILTranslucentView alloc] initWithFrame:self.view.frame];
            [self.view addSubview:self.blerView]; //that's it :)
            //optional:
            self.blerView.translucentAlpha = .9;
            self.blerView.translucentStyle = UIBarStyleDefault;
            self.blerView.translucentTintColor = [UIColor clearColor];
            self.blerView.backgroundColor = [UIColor clearColor];

        }
        self.blerView.hidden=NO;
        blerViewOn=YES;
    }
}



#pragma - DropDownMenu Delage CallBacks 

-(void)contextMenuButtonCoverClicked{
    [self.contextMenu animatContextMenu];
    [self manageBleredLayer];
}

-(void)contextMenuButtonFirstClicked{
    [self.JCParseQuery getMyInvitesforType:JCUserEventUsersTypeUpcoming completionblock:^(NSError *error, NSArray *response) {
        
        if (error) {
            NSLog(@"getMyInvitesforType %@",error);
        }else{
            
            self.tableViewDataSource = response;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.MyGigInvitesTable reloadData];
                [self.contextMenu animatContextMenu];
                [self manageBleredLayer];
            });
        }
    }];}
-(void)contextMenuButtonSecondClicked{
    [self.JCParseQuery getMyInvitesforType:JCUserEventUsersTypeSent completionblock:^(NSError *error, NSArray *response) {
        
        if (error) {
            NSLog(@"getMyInvitesforType %@",error);
        }else{
            
            self.tableViewDataSource = response;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.MyGigInvitesTable reloadData];
                [self.contextMenu animatContextMenu];
                [self manageBleredLayer];
            });
        }
    }];
}
-(void)contextMenuButtonThirdClicked{
    [self.JCParseQuery getMyInvitesforType:JCUserEventUsersTypePast completionblock:^(NSError *error, NSArray *response) {
        
        if (error) {
            NSLog(@"getMyInvitesforType %@",error);
        }else{
            
            self.tableViewDataSource = response;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.MyGigInvitesTable reloadData];
                [self.contextMenu animatContextMenu];
                [self manageBleredLayer];
            });
        }
    }];
}





@end
