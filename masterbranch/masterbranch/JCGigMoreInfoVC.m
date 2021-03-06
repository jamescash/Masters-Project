//
//  JCGigMoreInfoVC.m
//  PreAmp
//
//  Created by james cash on 16/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCGigMoreInfoVC.h"
#import "HeaderViewWithImage.h"
#import "HeaderView.h"
//calss named badly, this class does all the BIT API calls.
#import "JCHomeScreenDataController.h"
#import "JCParseQuerys.h"
#import "JCSelectFriends.h"
#import "MGSwipeButton.h"

#import <TLYShyNavBar/TLYShyNavBarManager.h>
#import "JCConstants.h"
#import "JCToastAndAlertView.h"
#import <Google/Analytics.h>
#import "GAI.h"

#import "JCGigMoreInfoDetailedView.h"
#import "JCMoreUpComingGigsHeader.h"




@interface JCGigMoreInfoVC ()
//UIElements
@property (weak, nonatomic) IBOutlet UITableView *TableViewVC;
@property (nonatomic,strong) NSMutableDictionary *tableViewDataSource;
@property (nonatomic,strong) NSArray *tableViewDataSourcekeys;
@property (nonatomic,strong) JCHomeScreenDataController *bandsInTownAPI;
@property (nonatomic,strong) PFUser *currentUser;
@property (nonatomic,strong) JCParseQuerys *JCParseQuerys;
@property (strong,nonatomic) CAGradientLayer *vignetteLayer;
@property (strong,nonatomic) PFObject *JCParseUserEvent;
@property (strong,nonatomic) eventObject *upcomingGigOfIntrest;
@property (strong,nonatomic) NSMutableArray *upcomingGigsUserIsInterestedIn;
@property (nonatomic,strong) NSIndexPath *upcomingGigOfIntrestIndexPath;
@property (strong,nonatomic) NSMutableArray *upcomingGigsUserIsInterestedInUserEventObjects;
@property (strong,nonatomic) NSString *timeDateLocaionCellId;
@property (strong,nonatomic) NSString *header1Buttons;
@property (strong,nonatomic) NSString *header2UpcomingGigs;
@property (strong,nonatomic) JCToastAndAlertView *toast;





@end

@implementation JCGigMoreInfoVC{
    BOOL userIsFollowingArtistMainVC;
    BOOL userIsInterestedInEvent;
    BOOL performSegueFromUpcomingGig;
    BOOL isLoadingButtonsHeader;
}


- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self initalize];
    
    [self addCustomButtonOnNavBar];
    [self layouStickyHeaderView];
    
    NSArray *timeDateLocaionCellIdArray = @[self.timeDateLocaionCellId];
    [self.tableViewDataSource setObject:timeDateLocaionCellIdArray forKey:self.header1Buttons];
    self.tableViewDataSourcekeys = @[self.header1Buttons,self.header2UpcomingGigs];
    
    
    
    //[self performSelector:@selector(getUpcomingGigsForArtist:) withObject:self.currentEvent.eventTitle afterDelay:3];
    
    [self getUpcomingGigsForArtist:self.currentEvent.eventTitle];
    
    

    
}

-(void)initalize{
    self.toast = [[JCToastAndAlertView alloc]init];
    self.JCParseQuerys = [JCParseQuerys sharedInstance];
    self.bandsInTownAPI = [[JCHomeScreenDataController alloc]init];
    self.tableViewDataSource = [[NSMutableDictionary alloc]init];
    isLoadingButtonsHeader = YES;
    self.screenName = @"Gig more Info screen";
    self.header1Buttons = @"buttonsHeader";
    self.header2UpcomingGigs = @"MoreUpcomingGigs";
    self.timeDateLocaionCellId = @"timeDateLocationCell";
    self.TableViewVC.allowsSelection = NO;
    self.upcomingGigsUserIsInterestedIn = [[NSMutableArray alloc]init];
    self.upcomingGigsUserIsInterestedInUserEventObjects = [[NSMutableArray alloc]init];

}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    performSegueFromUpcomingGig = NO;
    
    [self isUserIntrestedInThisGigIsUserFollowingArtist:self.currentEvent completionBlock:^(NSError *error, bool userIsInterested, bool userIsFollowingArtist) {
        
        
        if (error) {
            NSLog(@"%@",[error localizedDescription]);
        }else{
            
            NSIndexSet *section = [NSIndexSet indexSetWithIndex:0];
            isLoadingButtonsHeader = NO;
            NSLog(@"isloading no");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.TableViewVC reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
            });
            
            [self getUpcomingGigsForArtist:self.currentEvent.eventTitle];
        }
        
        
        
    }];
    
    
}


-(void)layouStickyHeaderView{
    
    HeaderViewWithImage *headerView = [HeaderViewWithImage instantiateFromNib];
    
    headerView.HeaderImageView.image = self.currentEvent.photoDownload.image;
    headerView.ArtistName.text = self.currentEvent.eventTitle;
    
    self.vignetteLayer = [CAGradientLayer layer];
    [self.vignetteLayer setBounds:[headerView.HeaderImageView bounds]];
    [self.vignetteLayer setPosition:CGPointMake([headerView.HeaderImageView  bounds].size.width/2.0f, [headerView.HeaderImageView  bounds].size.height/2.0f)];
    UIColor *lighterBlack = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.9];
    [self.vignetteLayer setColors:@[(id)[[UIColor clearColor] CGColor], (id)[lighterBlack CGColor]]];
    [self.vignetteLayer setLocations:@[@(.10), @(1.0)]];
    [[headerView.HeaderImageView  layer] addSublayer:self.vignetteLayer];
    
    [self.TableViewVC setParallaxHeaderView:headerView
                                       mode:VGParallaxHeaderModeFill
                                     height:200];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.TableViewVC shouldPositionParallaxHeader];
    
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *key = self.tableViewDataSourcekeys[section];
    NSArray *objectfromdataobject = [self.tableViewDataSource objectForKey:key];
    return [objectfromdataobject count];
}


#pragma mark - Table view delagate


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *section = [self.tableViewDataSourcekeys objectAtIndex:indexPath.section];
    
    if ([section isEqualToString:self.header1Buttons]) {
        JCTimeDateLocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.timeDateLocaionCellId];
        [cell formatCell:self.currentEvent];
        cell.JCTimeDateLocationTableViewCellDelagate = self;
        return cell;
    }
    
    if ([section isEqualToString:self.header2UpcomingGigs]) {
        
        JCUpcomingGigTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"upComingGig"];
        NSArray *upcomingGigs = self.tableViewDataSource[section];
        eventObject *upcomingGig = [upcomingGigs objectAtIndex:indexPath.row];

        cell.cellIndex = indexPath.row;
        cell.cellIndexNSIndexPath = indexPath;
        
        if (!upcomingGig.isUserInterestedInUpcomingGigFinishedLoading) {
            [self isUserInterestedInUpcomingGig:upcomingGig AtIndex:indexPath];
        }
        
        [cell formatCell:upcomingGig userIsInterested:upcomingGig.userIsInterestedInEvent];
         cell.JCUpcomingGigTableViewCellDelegate = self;

        
        return cell;
    }

    return nil;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *section = [self.tableViewDataSourcekeys objectAtIndex:indexPath.section];
    
    if ([section isEqualToString:self.header1Buttons]) {
        
        return 94;
        
    }
    
    if ([section isEqualToString:self.header2UpcomingGigs]) {
        return 110;

    }
    
    return 90;
    
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSString *sectionKey = [self.tableViewDataSourcekeys objectAtIndex:section];

    
    if ([sectionKey isEqualToString:self.header1Buttons]) {
        NSString *CellIdentifier = self.tableViewDataSourcekeys[section];
        JCInvteFollowHeaderVC *headerView = (JCInvteFollowHeaderVC*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (headerView == nil){
            headerView = [[JCInvteFollowHeaderVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        
        
        [headerView formatCellButtons:userIsFollowingArtistMainVC and:userIsInterestedInEvent isLoading:isLoadingButtonsHeader];
        //[headerView formatCellButtons:userIsFollowingArtistMainVC and:userIsInterestedInEvent];
         headerView.JCInvteFollowHeaderDelegate = self;
        
        UIView *view = [[UIView alloc] initWithFrame:[headerView frame]];
        headerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        [view addSubview:headerView];
        return view;
        
    }else if ([sectionKey isEqualToString:self.header2UpcomingGigs]){
        NSString *CellIdentifier = self.tableViewDataSourcekeys[section];
        JCMoreUpComingGigsHeader *headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (headerView == nil){
            headerView = [[JCMoreUpComingGigsHeader alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        NSString *sectionkeyy = [self.tableViewDataSourcekeys objectAtIndex:section];
        NSArray *upcomingGigs = self.tableViewDataSource[sectionkeyy];
        
        if ([upcomingGigs count]==0) {
            headerView.title.text = @"No Upcoming Gigs";
        }else{
            headerView.title.text = @"More Upcoming Gigs";
        }
        
        
        
        
        UIView *view = [[UIView alloc] initWithFrame:[headerView frame]];
        headerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        [view addSubview:headerView];
        return view;
       }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSString *sectionTitle = self.tableViewDataSourcekeys[section];
    
    if ([sectionTitle isEqualToString:self.header1Buttons]) {
        
        return 95;
    
    }
    
    if ([sectionTitle isEqualToString:self.header2UpcomingGigs]) {
        return 60;
    }

    
    return 100;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - Actions

- (void) didClickAddFriendsAction{
    [self performSegueWithIdentifier:@"SelectFriends" sender:self];
}

- (void) didClickInviteFriendsOnUpcomingGigAtNSIndexPath:(NSIndexPath *)cellIndex{
    
    
    NSArray *upcomingGigs = [self.tableViewDataSource objectForKey:self.header2UpcomingGigs];
    self.upcomingGigOfIntrest = [upcomingGigs objectAtIndex:cellIndex.row];
    self.upcomingGigOfIntrestIndexPath = cellIndex;
    //the user wants to intive friends to one of the artist upcoming gigs
    //I can reuse the curently downloaded photo here
    self.upcomingGigOfIntrest.photoDownload.image = self.currentEvent.photoDownload.image;
    
    
    //find out if user is already going to this upcoming gig and respond appropriatly.
    
    if ([self.upcomingGigsUserIsInterestedIn containsObject:self.upcomingGigOfIntrest]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"This gig is in your upcoming events" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Add Friends",@"More info",nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
        [actionSheet showInView:self.view];
    }else{
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Interested in attending this upcoming gig?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Just me", @"Me and Friends",@"More info", nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
        [actionSheet showInView:self.view];
    }
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if ([self.upcomingGigsUserIsInterestedIn containsObject:self.upcomingGigOfIntrest]) {
       
        if (buttonIndex == 0) {
            performSegueFromUpcomingGig = YES;
            [self performSegueWithIdentifier:@"SelectFriends" sender:self];
        }else if (buttonIndex == 1){
            performSegueFromUpcomingGig = YES;
            [self performSegueWithIdentifier:@"showMoreInfo" sender:self];
        }else if (buttonIndex == 1){
            NSLog(@"cancel");
        }
    
    
    
    }else{
    
    
    if (buttonIndex == 0)
    {
        performSegueFromUpcomingGig = YES;
        NSArray *recipientId =  @[[[PFUser currentUser]objectId]];
        
        
        [self.JCParseQuerys creatUserEvent:self.upcomingGigOfIntrest invitedUsers:recipientId complectionBlock:^(NSError *error) {
            
            if (error) {
                //show alert view
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"oops!" message:@"Please try sending creating that event again" delegate:self cancelButtonTitle:@"okay" otherButtonTitles:nil];
                
                [alert show];
            }else{
                [self.upcomingGigsUserIsInterestedIn addObject:self.upcomingGigOfIntrest];
                self.upcomingGigOfIntrest.userIsInterestedInEvent = YES;
                self.upcomingGigOfIntrest.isUserInterestedInUpcomingGigFinishedLoading = YES;
                
                NSString *key = self.tableViewDataSourcekeys [self.upcomingGigOfIntrestIndexPath.section];
                NSArray *upcomingGigsSection = [self.tableViewDataSource objectForKey:key];
                NSMutableArray *replacmentArray = [[NSMutableArray alloc]init];
                
                [replacmentArray addObjectsFromArray:upcomingGigsSection];
                
                [replacmentArray replaceObjectAtIndex:self.upcomingGigOfIntrestIndexPath.row withObject:self.upcomingGigOfIntrest];
                
                [self.tableViewDataSource setValue:replacmentArray forKey:key];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.TableViewVC reloadRowsAtIndexPaths:@[self.upcomingGigOfIntrestIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                });

               
            }
            
            
        }];
    }
    else if (buttonIndex == 1)
    {
        performSegueFromUpcomingGig = YES;
        [self performSegueWithIdentifier:@"SelectFriends" sender:self];
    }
    
    else if (buttonIndex == 2)
    {
        performSegueFromUpcomingGig = YES;

        [self performSegueWithIdentifier:@"showMoreInfo" sender:self];

    }
    }
}

- (void) didClickFollowArtistButton:(BOOL)userIsFollowingArtist{
    
    if (userIsFollowingArtist) {
        //Track Button clicks
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"       // Event category (required)
                                                              action:@"button_press"    // Event action (required)
                                                               label:@"followArtist_GigMoreInfo" // Event label
                                                               value:nil] build]];      // Event value
        [self.JCParseQuerys UserFollowedArtist:self.currentEvent complectionBlock:^(NSError *error) {
            
            if (error) {
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"There was a problem follwing that artist try again" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alert show];
                userIsFollowingArtistMainVC = NO;
                
                NSIndexSet *section = [NSIndexSet indexSetWithIndex:0];
                isLoadingButtonsHeader = NO;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.TableViewVC reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
                });
                
            }else{
                userIsFollowingArtistMainVC = YES;
                
                NSIndexSet *section = [NSIndexSet indexSetWithIndex:0];
                isLoadingButtonsHeader = NO;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.TableViewVC reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
                });
                
                [self.toast showUserUpDateToastWithMessage:[NSString stringWithFormat:@"Your following %@",self.currentEvent.eventTitle]];
                
            }
        
        
        }];
    }else{
        //Track Button clicks
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"       // Event category (required)
                                                              action:@"button_press"    // Event action (required)
                                                               label:@"UnfollowArtist_GigMoreInfo" // Event label
                                                               value:nil] build]];      // Event value
        [self.JCParseQuerys UserUnfollowedArtist:self.currentEvent complectionBlock:^(NSError *error) {
            
            if (error) {
                NSLog(@"Error unfollowing artist %@",error);
                userIsFollowingArtistMainVC = YES;
                
                NSIndexSet *section = [NSIndexSet indexSetWithIndex:0];
                isLoadingButtonsHeader = NO;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.TableViewVC reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
                });
                
            }else{
                
                userIsFollowingArtistMainVC = NO;
                
                NSIndexSet *section = [NSIndexSet indexSetWithIndex:0];
                isLoadingButtonsHeader = NO;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.TableViewVC reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
                });
                
                
            }
            
        }];
        
    }
    
}

- (void) didClickImIntrested:(BOOL)userIsInterested{
    
    
    if (!userIsInterested) {
        
        if (self.JCParseUserEvent) {
            
            NSMutableArray *InvitedUsers = [[NSMutableArray alloc]init];
            
            [InvitedUsers addObjectsFromArray:[self.JCParseUserEvent objectForKey:JCUserEventUsersEventInvited]];
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
            [self.JCParseUserEvent setObject:InvitedUsers forKey:JCUserEventUsersEventInvited];
            [self.JCParseUserEvent setObject:InvitedUsers forKey:JCUserEventUsersSubscribedForNotifications];
            [self.JCParseUserEvent setObject:@YES forKeyedSubscript:JCUserEventUsersEventIsBeingUpDated];
            [self.JCParseUserEvent saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                
                if (error) {
                    userIsInterestedInEvent = YES;
                    
                    NSIndexSet *section = [NSIndexSet indexSetWithIndex:0];
                    isLoadingButtonsHeader = NO;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.TableViewVC reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
                    });
                }else{
                    
                    userIsInterestedInEvent = NO;
                    [self.toast showUserUpDateToastWithMessage:@"Removed from your upcoming gigs"];
                    NSIndexSet *section = [NSIndexSet indexSetWithIndex:0];
                    isLoadingButtonsHeader = NO;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.TableViewVC reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
                    });
                    
                }
               
               
                
            }];
            
            NSLog(@"User Removed from event");
                
        
        }else{
            NSLog(@"No User Event");
        }
        
        
        
        
    }else{
        
        
        
        NSArray *recipientId =  @[[[PFUser currentUser]objectId]];
        
        
        [self.JCParseQuerys creatUserEvent:self.currentEvent invitedUsers:recipientId complectionBlock:^(NSError *error) {
            
            if (error) {
                //show alert view
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"oops!" message:@"Please try sending creating that event again" delegate:self cancelButtonTitle:@"okay" otherButtonTitles:nil];
                
                [alert show];
                
                NSIndexSet *section = [NSIndexSet indexSetWithIndex:0];
                isLoadingButtonsHeader = NO;
                userIsInterestedInEvent = NO;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.TableViewVC reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
                });
            }else{
                
                JCToastAndAlertView *toast = [[JCToastAndAlertView alloc]init];
                [toast showUserUpDateToastWithMessage:[NSString stringWithFormat:@"%@ added to your upcoming events, now ask some friends along!",self.currentEvent.eventTitle]];
                
                NSIndexSet *section = [NSIndexSet indexSetWithIndex:0];
                isLoadingButtonsHeader = NO;
                userIsInterestedInEvent = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.TableViewVC reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
                });                id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
                
                [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"       // Event category (required)
                                                                      action:@"button_press"    // Event action (required)
                                                                       label:@"JustMe_GigMoreInfo" // Event label
                                                                       value:nil] build]];      // Event value
                
            }
            
            
        }];
        
    }
}



- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"SelectFriends"]) {
        
        
        if (!performSegueFromUpcomingGig) {
            //so user wants to intive people to the current gig
            UINavigationController *SelectFriendsNav = (UINavigationController*)segue.destinationViewController;
            JCSelectFriends *SelectFreindsVC = [SelectFriendsNav viewControllers][0];
            //pass the senderVC a referance to the current event that need to be sent
            
            if (self.JCParseUserEvent) {
                //if there a user event it means the user already has created an event so lets just add people to it
                SelectFreindsVC.tableViewType = JCSendEventIntivesPageAddUserToExistingEvent;
                SelectFreindsVC.ParseEventObject = self.JCParseUserEvent;
                
            }else{
                //else the user is creating a new event
                SelectFreindsVC.currentEvent = self.currentEvent;
             }
        }else{
          
            UINavigationController *SelectFriendsNav = (UINavigationController*)segue.destinationViewController;
            JCSelectFriends *SelectFreindsVC = [SelectFriendsNav viewControllers][0];
            
            if ([self.upcomingGigsUserIsInterestedIn containsObject:self.upcomingGigOfIntrest]) {
                //NSLog(@"add artist to exisiting event");
                //SelectFreindsVC.tableViewType = JCSendEventIntivesPageAddUserToExistingEvent;
                
                
                for (PFObject *userEvent in self.upcomingGigsUserIsInterestedInUserEventObjects) {
                    
                    
                    NSDate *userEventDateTime = [userEvent objectForKey:JCUserEventUsersEventDate];
                    NSString *upcomingGigDateTime = self.upcomingGigOfIntrest.eventDate;
                    
                    //NSLog(@"userevent Date Time %@",userEventDateTime);
                    //NSLog(@"upcomingGigDateTime %@",upcomingGigDateTime);

                    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                    [dateFormat setDateFormat:@"yyy-MM-dd'T'HH:mm:ss"];
                    NSDate *upcomingEventDateTimeFormatted = [dateFormat dateFromString:upcomingGigDateTime];
                    
                    NSString *userEventVenue = [userEvent objectForKey:JCUserEventUsersEventCity];
                    NSString *upcomingGigCity = self.upcomingGigOfIntrest.county;
                    
                    if ([userEventDateTime isEqual:upcomingEventDateTimeFormatted]&&[userEventVenue isEqualToString:upcomingGigCity]) {
                        NSLog(@"IT WORKED");
                        
                        UINavigationController *SelectFriendsNav = (UINavigationController*)segue.destinationViewController;
                        JCSelectFriends *SelectFreindsVC = [SelectFriendsNav viewControllers][0];
                        SelectFreindsVC.tableViewType = JCSendEventIntivesPageAddUserToExistingEvent;
                        SelectFreindsVC.ParseEventObject = userEvent;
                        
                    }
                    
                    
                };
                //SelectFreindsVC.currentEvent = self.upcomingGigOfIntrest;

            
            }else{
             
                
                
                SelectFreindsVC.currentEvent = self.upcomingGigOfIntrest;

                
                //NSLog(@"make new gig");
                
            }
            
        
            
        }
    }else if ([segue.identifier isEqualToString:@"showMoreInfo"]){
        
        JCGigMoreInfoDetailedView *DVC = (JCGigMoreInfoDetailedView*)[segue destinationViewController];
        if (!performSegueFromUpcomingGig) {
            DVC.currentEventEventObject = self.currentEvent;

        }else{
            DVC.currentEventEventObject = self.upcomingGigOfIntrest;
        }
        
    }
    
}



-(void)didTapShowGigMoreInfo{
    [self performSegueWithIdentifier:@"showMoreInfo" sender:self];
}

#pragma - Helper Methods

- (void)addCustomButtonOnNavBar
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage im];
    //imageView.alpha = 0.5; //Alpha runs from 0.0 to 1.0
    
    [backButton setImage:[UIImage imageNamed:@"iconDown.png"] forState:UIControlStateNormal];
    backButton.adjustsImageWhenDisabled = NO;
    //set the frame of the button to the size of the image (see note below)
    backButton.frame = CGRectMake(0, 0, 40, 40);
    backButton.opaque = YES;
    
    [backButton addTarget:self action:@selector(BackButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    //create a UIBarButtonItem with the button as a custom view
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.navigationItem.leftBarButtonItem = customBarItem;
    
    self.shyNavBarManager.scrollView = self.TableViewVC;
    
}

- (void)BackButtonPressed{
    [self.JCGigMoreInfoVCDelegate JCGigMoreInfoVCDidSelectDone:self];
}

- (void)isUserInterestedInUpcomingGig:(eventObject*)upcomingGig AtIndex:(NSIndexPath*)indexPath{
    
    [self.JCParseQuerys isUserInterestedInEvent:upcomingGig completionBlock:^(NSError *error, BOOL userIsInterestedInGoingToEvent, PFObject *JCParseuserEvent) {
        
        if (error) {
            NSLog(@"error user intersed %@",error);
        }else{
            
            if (userIsInterestedInGoingToEvent) {
                
                upcomingGig.isUserInterestedInUpcomingGigFinishedLoading = YES;
                upcomingGig.userIsInterestedInEvent = YES;
                [self.upcomingGigsUserIsInterestedIn addObject:upcomingGig];
                [self.upcomingGigsUserIsInterestedInUserEventObjects addObject:JCParseuserEvent];
                
            }else{
                upcomingGig.isUserInterestedInUpcomingGigFinishedLoading = YES;
                upcomingGig.userIsInterestedInEvent = NO;
            }
            
            
            NSString *key = self.tableViewDataSourcekeys [indexPath.section];
            NSArray *upcomingGigsSection = [self.tableViewDataSource objectForKey:key];
            NSMutableArray *replacmentArray = [[NSMutableArray alloc]init];
            
            [replacmentArray addObjectsFromArray:upcomingGigsSection];
            
            [replacmentArray replaceObjectAtIndex:indexPath.row withObject:upcomingGig];
            
            [self.tableViewDataSource setValue:replacmentArray forKey:key];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.TableViewVC reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            });
            
            
            
        }
        
    }];
    
    
}

-(void)isUserIntrestedInThisGigIsUserFollowingArtist:(eventObject*) currentGig completionBlock:(void(^)(NSError* error,bool  userIsInterested,bool userIsFollowingArtist))finished{
    
    
    
    [self.JCParseQuerys isUserInterestedInEvent:currentGig completionBlock:^(NSError *error, BOOL userIsInterestedInGoingToEvent,PFObject* JCParseuserEvent) {
        
        
        if (error) {
            NSLog(@"%@",[error localizedDescription]);
            finished(error,nil,nil);
        }else{
            
            
            if (userIsInterestedInGoingToEvent) {
                self.JCParseUserEvent = JCParseuserEvent;
                userIsInterestedInEvent = YES;

                [self.JCParseQuerys isUserFollowingArtist:self.currentEvent completionBlock:^(NSError *error, BOOL IsFollowingArtist) {
                    
                    if (error) {
                        NSLog(@"%@",[error localizedDescription]);
                        finished(error,nil,nil);

                    }else{
                        
                        
                        if (IsFollowingArtist) {
                            userIsFollowingArtistMainVC = YES;
                            finished (nil,userIsInterestedInEvent,userIsFollowingArtistMainVC);
                            
                        }else{

                            userIsFollowingArtistMainVC = NO;
                            finished (nil,userIsInterestedInEvent,userIsFollowingArtistMainVC);

                            
                        }
                        
                        
                    }
                }];
            
            
            
            }else{

                userIsInterestedInEvent = NO;
               
                [self.JCParseQuerys isUserFollowingArtist:self.currentEvent completionBlock:^(NSError *error, BOOL IsFollowingArtist) {
                    
                    if (error) {
                        NSLog(@"%@",[error localizedDescription]);
                    }else{
                        
                        
                        if (IsFollowingArtist) {

                            userIsFollowingArtistMainVC = YES;
                            finished (nil,userIsInterestedInEvent,userIsFollowingArtistMainVC);

                            
                        }else{

                            userIsFollowingArtistMainVC = NO;
                            finished (nil,userIsInterestedInEvent,userIsFollowingArtistMainVC);
                        }
                     }
                }];
            }
        }
        
    }];
    
}

- (void)getUpcomingGigsForArtist:(NSString*)artistName{
    
    [self.bandsInTownAPI getUpcomingGigsForArtist:artistName competionBlock:^(NSError *error, NSArray *response){
        
        
        if (response !=nil) {
            //Remove the first gig from all response as thats that gig the user is already looking at
            NSMutableArray *upcomingGigs = [[NSMutableArray alloc]init];
            [upcomingGigs addObjectsFromArray:response];
            eventObject *firstGig = [upcomingGigs firstObject];
            [upcomingGigs removeObject:firstGig];
            
            NSIndexSet *section = [NSIndexSet indexSetWithIndex:1];
            
            
            [self.tableViewDataSource setObject:upcomingGigs forKey:self.header2UpcomingGigs];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                 [self.TableViewVC reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
            });
            
            
        }
    }];
    
}



@end
