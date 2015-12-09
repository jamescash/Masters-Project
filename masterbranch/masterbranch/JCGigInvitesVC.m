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
#import "UIColor+JCColor.h"


#import "UIERealTimeBlurView.h"


#import "ILTranslucentView.h"

#import "MGSwipeButton.h"
#import <objc/runtime.h>

#import "DGActivityIndicatorView.h"
#import "JCMusicDiaryPreLoader.h"
#import "UIColor+JCColor.h"

@interface JCGigInvitesVC ()
//UI elements
@property (weak, nonatomic) IBOutlet UITableView *MyGigInvitesTable;
@property (weak, nonatomic) IBOutlet UILabel *tableViewHeader;

//Properties
@property (nonatomic,strong) PFObject *selectedInvite;
@property (nonatomic,strong) UIImage *selectedInviteImage;
@property (nonatomic,strong) NSMutableArray *tableViewDataSource;
@property (nonatomic,strong) NSMutableArray *imageFiles;
@property (weak, nonatomic) IBOutlet UIView *navBarDropDown;

//classes
@property (nonatomic,strong) JCParseQuerys *JCParseQuery;
@property (nonatomic,strong) ILTranslucentView *blerView;

@property (nonatomic,strong) JCDropDownMenu *contextMenu;
@property (nonatomic,strong) NSString *userEventsType;
@property (nonatomic,strong) UIActivityIndicatorView *UIActivitySpinner;



@end

@implementation JCGigInvitesVC{
    BOOL blerViewOn;
    BOOL isLoading;
    UITapGestureRecognizer *didTapAnywhereWhenDropDownMenuActive;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isLoading = YES;
    [self addCustomButtonOnNavBar];
    self.tableViewDataSource = [[NSMutableArray alloc]init];
    self.tableViewHeader.textColor = [UIColor JCPink];
    self.userEventsType = JCUserEventUsersTypeUpcoming;
    self.JCParseQuery = [JCParseQuerys sharedInstance];
    self.imageFiles = [[NSMutableArray alloc]init];
    self.screenName = @"Upcoming Gigs Screen";
    
    [self.JCParseQuery getMyInvitesforType:JCUserEventUsersTypeUpcoming completionblock:^(NSError *error, NSArray *response) {
        
        if (error) {
            NSLog(@"getMyInvitesforType %@",error);
        }else{

            //self.tableViewDataSource = response;
            //returns an array of user events based on the the type Key;
            //[self.tableViewDataSource removeAllObjects];
            [self.tableViewDataSource addObjectsFromArray:response];
            isLoading = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.MyGigInvitesTable reloadData];
            });
        }
     }];
    
    self.MyGigInvitesTable.emptyDataSetSource = self;
    self.MyGigInvitesTable.emptyDataSetDelegate = self;
    
    // A little trick for removing the cell separators
    self.MyGigInvitesTable.tableFooterView = [UIView new];
    
    self.UIActivitySpinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    //self.UIActivitySpinner.frame = CGRectMake(self.view.frame.size.width-10, self.view.frame.size.height-10, 60, 60);
    self.UIActivitySpinner.color = [UIColor grayColor];
    self.UIActivitySpinner.center = self.view.center;
    
}

#pragma - empty Datasource delagte
- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView
{
    if (isLoading) {
        
        JCMusicDiaryPreLoader *musicDiaryPreLoder = [JCMusicDiaryPreLoader instantiateFromNib];
        
        musicDiaryPreLoder.frame = self.MyGigInvitesTable.frame;
        
        
        DGActivityIndicatorView *prelaoder = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallScaleMultiple tintColor:[UIColor JCPink] size:100.0f];
        prelaoder.center = musicDiaryPreLoder.center;
        [musicDiaryPreLoder addSubview:prelaoder];
        musicDiaryPreLoder.UILableTextString.text = @"Loading your gigs..";
        [prelaoder startAnimating];
        
        musicDiaryPreLoder.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
        UIViewAutoresizingFlexibleLeftMargin |
        UIViewAutoresizingFlexibleBottomMargin;
        
        return musicDiaryPreLoder;
        
    }
    
    return nil;
}


-(NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    
    NSString *text;
    if ([self.userEventsType isEqualToString:JCUserEventUsersTypeUpcoming]) {
        text = @"No upcoming gigs";
    }else if ([self.userEventsType isEqualToString:JCUserEventUsersTypePast]){
        text = @"No past gigs";
    }else if ([self.userEventsType isEqualToString:JCUserEventUsersTypeSent]){
        text = @"No sent gigs";
    }
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

-(NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text;
    if ([self.userEventsType isEqualToString:JCUserEventUsersTypeUpcoming]) {
        text = @"Go to the homescreen and find some upcoming gigs that you would like to attend";
    }else if ([self.userEventsType isEqualToString:JCUserEventUsersTypePast]){
        text = @"After you attend gigs they will apper here, Go to the homescreen and find some upcoming gig that you would like to attend";
    }else if ([self.userEventsType isEqualToString:JCUserEventUsersTypeSent]){
        text = @"Go to the homescreen and find some upcoming gig that you would like to attend";
    }
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    if ([self.userEventsType isEqualToString:JCUserEventUsersTypeUpcoming]) {
        return [UIImage imageNamed:@"emptyUpcoming"];

    }else if ([self.userEventsType isEqualToString:JCUserEventUsersTypePast]){
        return [UIImage imageNamed:@"emptyPast"];

    }else if ([self.userEventsType isEqualToString:JCUserEventUsersTypeSent]){
        return [UIImage imageNamed:@"emptySent"];

    }
    
    return nil;
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    UIColor *pink = [UIColor colorWithRed:234.0f/255.0f green:65.0f/255.0f blue:150.0f/255.0f alpha:1.0f];

    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:17.0f],NSForegroundColorAttributeName:pink};
    
    return [[NSAttributedString alloc] initWithString:@"Home" attributes:attributes];
}

- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView
{
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"HomeScreenCollectionView"]]
                                                 animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}

//- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
//{
   //return 20.0f;
//}




- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -self.MyGigInvitesTable.tableHeaderView.frame.size.height/2.0f;
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
    cell.indexPath = indexPath;
    PFFile *imageFile = [eventInvite objectForKey:@"eventPhoto"];

    cell.BackRoundImage.file = imageFile;
    cell.BackRoundImage.contentMode = UIViewContentModeScaleAspectFill;

   // set up the swipe buttons
    
    
    cell.leftButtons = @[[MGSwipeButton buttonWithTitle:@"" icon:[UIImage imageNamed:@"iconMute"] backgroundColor:[UIColor whiteColor]],
                         [MGSwipeButton buttonWithTitle:@"" icon:[UIImage imageNamed:@"iconCancle"] backgroundColor:[UIColor JCPink]]];
    
          

    
    MGSwipeButton *muteButton = [cell.leftButtons firstObject];
    muteButton.tag = indexPath.row;
    MGSwipeButton *deleteButton = [cell.leftButtons lastObject];
    deleteButton.tag = indexPath.row;
    
    cell.delegate = self;
    cell.leftSwipeSettings.transition = MGSwipeTransitionBorder;
   
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
        NSArray *numberOfPepleIntived = [self.selectedInvite objectForKey:JCUserEventUsersInvited];
        
        //TODO some extra cheaks here to make sure its that one
        if ([numberOfPepleIntived count] == 1) {
            
            NSString *personIntiveObjectId = [numberOfPepleIntived firstObject];
            
            if ([personIntiveObjectId isEqualToString:[[PFUser currentUser]objectId]]) {
                //It is a single person event and the current user did creat that event 
                destinationVC.isSinglePersonEvent = YES;
             }
         }
        
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

-(BOOL)swipeTableCell:(JCEventInviteCell*)cell tappedButtonAtIndex:(NSInteger) index direction:(MGSwipeDirection)direction fromExpansion:(BOOL) fromExpansion{
    
    
    if (index == 0) {
        
        
        NSLog(@"mute button %@",cell);
    }else if (index == 1){
        [self deleteEventFromInboxatIndexPath:cell.indexPath];
    }
    return YES;
}



-(void)deleteEventFromInboxatIndexPath :(NSIndexPath*)indexPath {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Are you sure?" message:@"You will be removed from this event and will no longer be able to view it!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
    alert.tag = indexPath.row;
    [alert show];
};


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex == 1) {
        
        PFObject *eventToDeleteUserFrom = [self.tableViewDataSource objectAtIndex:alertView.tag];
        [self.tableViewDataSource removeObjectAtIndex:alertView.tag];
        
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:alertView.tag inSection:0] ;
       // NSArray *indexs = @[indexpath];
        [self.MyGigInvitesTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexpath] withRowAnimation:UITableViewRowAnimationLeft];
        [self performSelector:@selector(reloadTableView) withObject:nil afterDelay:.3];
        
        NSMutableArray *InvitedUsers = [[NSMutableArray alloc]init];
        
        [InvitedUsers addObjectsFromArray:[eventToDeleteUserFrom objectForKey:JCUserEventUsersEventInvited]];
        //NSLog(@"%@",InvitedUsers);
        PFUser *currentuser = [PFUser currentUser];
        NSMutableArray *toDelete = [NSMutableArray array];

        for (NSString *userId in InvitedUsers) {
            if ([userId isEqualToString:currentuser.objectId] ) {
                [toDelete addObject:userId];
            }
        }
        [InvitedUsers removeObjectsInArray:toDelete];

        NSLog(@"%@",InvitedUsers);
        [eventToDeleteUserFrom setObject:InvitedUsers forKey:JCUserEventUsersEventInvited];
        [eventToDeleteUserFrom setObject:InvitedUsers forKey:JCUserEventUsersSubscribedForNotifications];
        [eventToDeleteUserFrom setObject:@YES forKeyedSubscript:JCUserEventUsersEventIsBeingUpDated];

        [eventToDeleteUserFrom saveInBackground];
            
    }

}

-(void)reloadTableView{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.MyGigInvitesTable reloadData];
    });
}

- (void)addCustomButtonOnNavBar
{
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [menuButton setImage:[UIImage imageNamed:@"iconMenu.png"] forState:UIControlStateNormal];
    //[menuButton setImage:[UIImage imageNamed:@"iconMenu.png"] forState:UIControlStateHighlighted];
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
    UIImageView * contextMenuButtonCoverimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconDropDown"]];
    contextMenuButtonCoverimageView.frame = CGRectMake(0, 0, 40, 40);
    [self.navBarDropDown addSubview:contextMenuButtonCoverimageView];
    
    self.navBarDropDown.backgroundColor = [UIColor clearColor];

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
        self.navBarDropDown.hidden = NO;
        blerViewOn=NO;
    }else{
        if (!self.blerView) {
            self.blerView = [[ILTranslucentView alloc] initWithFrame:self.view.frame];
            [self.view addSubview:self.blerView];
            self.blerView.translucentAlpha = .9;
            self.blerView.translucentStyle = UIBarStyleDefault;
            self.blerView.translucentTintColor = [UIColor clearColor];
            self.blerView.backgroundColor = [UIColor clearColor];
           

            

        }
        

        
       
        self.blerView.hidden=NO;
        self.navBarDropDown.hidden = YES;

        blerViewOn=YES;
       // [self.blerView addGestureRecognizer:didTapAnywhereWhenDropDownMenuActive];

    }
}
//
-(void)didTapAnywhere{
    [self.contextMenu animatContextMenu];
    [self manageBleredLayer];
}

#pragma - DropDownMenu Delage CallBacks 

-(void)contextMenuButtonCoverClicked{
    [self.contextMenu animatContextMenu];
    [self manageBleredLayer];
}

-(void)contextMenuButtonFirstClicked{
    [self.contextMenu setUserInteractionEnabled:NO];
    self.userEventsType = JCUserEventUsersTypeUpcoming;
    [self.blerView addSubview:self.UIActivitySpinner];

    [self.UIActivitySpinner startAnimating];

    [self.JCParseQuery getMyInvitesforType:JCUserEventUsersTypeUpcoming completionblock:^(NSError *error, NSArray *response) {
       //
        
        UIImageView * contextMenuButtonCoverimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconUpcomingDD"]];
        contextMenuButtonCoverimageView.frame = CGRectMake(0, 0, 40, 40);
        
        NSArray *navBaSubViews = [self.navBarDropDown subviews];
        
        UIView *subView = [navBaSubViews firstObject];
        [subView removeFromSuperview];
        
        [self.navBarDropDown addSubview:contextMenuButtonCoverimageView];
        
        if (error) {
            NSLog(@"getMyInvitesforType %@",error);
        }else{
            [self.tableViewDataSource removeAllObjects];
            [self.tableViewDataSource addObjectsFromArray:response];
            self.tableViewHeader.text = @"Upcoming Gigs";
            [self.UIActivitySpinner stopAnimating];

            dispatch_async(dispatch_get_main_queue(), ^{
                [self.MyGigInvitesTable reloadData];
                [self.contextMenu animatContextMenu];
                [self manageBleredLayer];
                [self.contextMenu setUserInteractionEnabled:YES];

            });
        }
    }];}
-(void)contextMenuButtonSecondClicked{
    [self.contextMenu setUserInteractionEnabled:NO];
    self.userEventsType = JCUserEventUsersTypeSent;
    [self.UIActivitySpinner startAnimating];
    [self.blerView addSubview:self.UIActivitySpinner];

    UIImageView * contextMenuButtonCoverimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconSentDD"]];
    contextMenuButtonCoverimageView.frame = CGRectMake(0, 0, 40, 40);
    
    NSArray *navBaSubViews = [self.navBarDropDown subviews];
    
    UIView *subView = [navBaSubViews firstObject];
    [subView removeFromSuperview];
    
    [self.navBarDropDown addSubview:contextMenuButtonCoverimageView];
    

    [self.JCParseQuery getMyInvitesforType:JCUserEventUsersTypeSent completionblock:^(NSError *error, NSArray *response) {
        
        if (error) {
            NSLog(@"getMyInvitesforType %@",error);
        }else{
            
            [self.tableViewDataSource removeAllObjects];
            [self.tableViewDataSource addObjectsFromArray:response];
            self.tableViewHeader.text = @"Sent";
            [self.UIActivitySpinner stopAnimating];

            dispatch_async(dispatch_get_main_queue(), ^{
                [self.MyGigInvitesTable reloadData];
                [self.contextMenu animatContextMenu];
                [self manageBleredLayer];
                [self.contextMenu setUserInteractionEnabled:YES];

            });
        }
    }];
}
-(void)contextMenuButtonThirdClicked{
    [self.contextMenu setUserInteractionEnabled:NO];
    self.userEventsType = JCUserEventUsersTypePast;
    [self.blerView addSubview:self.UIActivitySpinner];

    //UIImageView * contextMenuButtonCoverimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconPastDD"]];
    //contextMenuButtonCoverimageView.frame = CGRectMake(0, 0, 40, 40);
    //[self.navBarDropDown ]
    //[self.navBarDropDown addSubview:contextMenuButtonCoverimageView];
    [self.UIActivitySpinner startAnimating];

    UIImageView * contextMenuButtonCoverimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconPastDD"]];
    contextMenuButtonCoverimageView.frame = CGRectMake(0, 0, 40, 40);
    
    NSArray *navBaSubViews = [self.navBarDropDown subviews];
    
    UIView *subView = [navBaSubViews firstObject];
    [subView removeFromSuperview];
    
    [self.navBarDropDown addSubview:contextMenuButtonCoverimageView];
   
    //self.navigationItem.leftBarButtonItem.image = [UIImage imageNamed:@"iconPastDD"];
    
    [self.JCParseQuery getMyInvitesforType:JCUserEventUsersTypePast completionblock:^(NSError *error, NSArray *response) {
        
        if (error) {
            NSLog(@"getMyInvitesforType %@",error);
        }else{
            
            [self.tableViewDataSource removeAllObjects];
            [self.tableViewDataSource addObjectsFromArray:response];
            self.tableViewHeader.text = @"Past Gigs";
            [self.UIActivitySpinner stopAnimating];

            dispatch_async(dispatch_get_main_queue(), ^{
                [self.MyGigInvitesTable reloadData];
                [self.contextMenu animatContextMenu];
                [self manageBleredLayer];
                [self.contextMenu setUserInteractionEnabled:YES];

            });
        }
    }];
}





@end
