//
//  JCGigsComingUpInThisMonthVC.m
//  PreAmp
//
//  Created by james cash on 23/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCGigsComingUpInThisMonthVC.h"
#import "JCParseQuerys.h"
#import "JCSelectFriends.h"
#import "HeaderViewWithImage.h"
#import "HeaderView.h"
#import "MGSwipeButton.h"
#import "JCConstants.h"
#import "JCGigMoreInfoDetailedView.h"
#import "JCMusicDiaryDetailViewHeader.h"


@interface JCGigsComingUpInThisMonthVC ()
@property (weak, nonatomic ) IBOutlet UITableView *tableview;
@property (nonatomic,strong) JCParseQuerys *JCParseQuerys;
@property (nonatomic,strong) NSArray *tableviewDataSource;
@property (strong,nonatomic) CAGradientLayer *vignetteLayer;
@property (strong,nonatomic) PFObject *upcomingGigCurrentlyClickedOn;
@property (strong,nonatomic) NSMutableArray *upcomingGigsUserIsInterestedIn;
@property (strong,nonatomic) NSMutableArray *upcomingGigsUserIsInterestedInUserEventObjects;

@end

@implementation JCGigsComingUpInThisMonthVC{
    BOOL performSegueFromUpcomingGig;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.JCParseQuerys = [JCParseQuerys sharedInstance];
    self.tableview.allowsSelection = NO;
    [self addCustomButtonOnNavBar];
    [self layoutHeaderView];
    self.upcomingGigsUserIsInterestedIn = [[NSMutableArray alloc]init];
    self.upcomingGigsUserIsInterestedInUserEventObjects = [[NSMutableArray alloc]init];
    
    
    [self.JCParseQuerys getUpcomingGigsforAartis:self.diaryObject.artist onMonthIndex:self.diaryObject.dateComponents.month isIrishQuery:self.IsIrishQuery complectionblock:^(NSError *error, NSArray *response) {
        
    
        if (error) {
            
            NSLog(@"error %@",error);
        }else{
            //self.tableViewDataSource = response;
            self.tableviewDataSource = response;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableview reloadData];
                
            });

            //response = Parse Event Upcoming Event Objects
            
            PFObject *lastObject = [response lastObject];
            
            for (PFObject *upcomingGig in response) {
                
                
                [self.JCParseQuerys isUserInterestedInParseEvent:upcomingGig completionBlock:^(NSError *error, BOOL userIsInterestedInGoingToEvent, PFObject *JCParseuserEvent) {
                    if (error) {
                        NSLog(@"%@ error",error);
                    }else{
                        if (userIsInterestedInGoingToEvent) {
                            [self.upcomingGigsUserIsInterestedIn addObject:upcomingGig];
                            [self.upcomingGigsUserIsInterestedInUserEventObjects addObject:JCParseuserEvent];
                        }
                    }
                    
                    
                    if (upcomingGig == lastObject) {
                        if ([response count] > 6) {
                            [self performSelector:@selector(realoadData) withObject:self afterDelay:.6];

                        }else{
                            [self performSelector:@selector(realoadData) withObject:self afterDelay:.2];

                        }
                     }
                    }];
               }
          }
        
      }];
   
}

-(void)realoadData{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableview reloadData];
    });
    
}

-(void)layoutHeaderView{
    HeaderViewWithImage *headerView = [HeaderViewWithImage instantiateFromNib];

    headerView.HeaderImageView.image = self.diaryObject.artistImage;
    PFObject *artist = self.diaryObject.artist;

    headerView.ArtistName.text = [artist objectForKey:@"artistName"];
    
    self.vignetteLayer = [CAGradientLayer layer];
    [self.vignetteLayer setBounds:[headerView.HeaderImageView bounds]];
    [self.vignetteLayer setPosition:CGPointMake([headerView.HeaderImageView  bounds].size.width/2.0f, [headerView.HeaderImageView  bounds].size.height/2.0f)];
    UIColor *lighterBlack = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.9];
    [self.vignetteLayer setColors:@[(id)[[UIColor clearColor] CGColor], (id)[lighterBlack CGColor]]];
    [self.vignetteLayer setLocations:@[@(.10), @(1.0)]];
    [[headerView.HeaderImageView  layer] addSublayer:self.vignetteLayer];
    [self.tableview setParallaxHeaderView:headerView
                                     mode:VGParallaxHeaderModeFill
                                   height:200];

    
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.tableview shouldPositionParallaxHeader];
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableviewDataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    JCUpcomingGigTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"upComingGig"];
    
    BOOL userIsInteresedInEvent;
    
    PFObject *upcoming = [self.tableviewDataSource objectAtIndex:indexPath.row];
    
    
    if ([self.upcomingGigsUserIsInterestedIn containsObject:upcoming]) {
        userIsInteresedInEvent = YES;
    }else{
        userIsInteresedInEvent = NO;
    }
    [cell formatCellwith:upcoming userIsInterested:userIsInteresedInEvent];
     cell.cellIndex = indexPath.row;
     cell.JCUpcomingGigTableViewCellDelegate = self;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   return 110;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    static NSString *headerViews = @"HeardView";
    
    JCMusicDiaryDetailViewHeader *headerView = [tableView dequeueReusableCellWithIdentifier:headerViews];
     NSString *headerViewTitle;
    if (self.IsIrishQuery) {
        headerViewTitle = [NSString stringWithFormat:@"%@ Tour Dates - Ireland",[self monthforindex:self.diaryObject.dateComponents.month]];
    }else{
        headerViewTitle = [NSString stringWithFormat:@"%@ Tour Dates - UK",[self monthforindex:self.diaryObject.dateComponents.month]];
    }
    
    headerView.title.text = headerViewTitle;
    return headerView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 70;
    
}

-(NSString*)monthforindex:(int)monthindex{
    
    switch (monthindex) {
        case 1:
            return  @"January";
            break;
        case 2:
            return  @"February";
            break;
        case 3:
            return  @"March";
            break;
        case 4:
            return  @"April";
            break;
        case 5:
            return  @"May";
            
            break;
        case 6:
            return  @"June";
            
            break;
        case 7:
            return  @"July";
            
            break;
        case 8:
            return @"August";
            
            break;
        case 9:
            return @"September";
            
            break;
        case 10:
            return  @"October";
            
            break;
        case 11:
            return @"November";
            
            break;
        case 12:
            return @"December";
            break;
        default:
            NSLog(@"default");
            break;
            
    }
    
    NSLog(@"month index fail");
    return nil;
    
}
- (void)addCustomButtonOnNavBar
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [backButton setImage:[UIImage imageNamed:@"iconDown.png"] forState:UIControlStateNormal];
    backButton.adjustsImageWhenDisabled = NO;
    backButton.frame = CGRectMake(0, 0, 40, 40);
    backButton.opaque = YES;
    [backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = customBarItem;
}
-(void)backButtonPressed{
    NSLog(@"back pressed");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didClickInviteFriendsOnUpcomingGigAt:(NSInteger)cellIndex{
    
    //this is the gig that is currently clicked on.
    //array of upcoming events that the user is intresed in
    //this gives that upcoming gig object from parse not the UserEvent Object
    self.upcomingGigCurrentlyClickedOn = [self.tableviewDataSource objectAtIndex:cellIndex];
    
    
    if ([self.upcomingGigsUserIsInterestedIn containsObject:self.upcomingGigCurrentlyClickedOn]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"This gig is in your upcoming events" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Add Friends",@"More info", nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
        [actionSheet showInView:self.view];

    }else{
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Interested in attending this upcoming gig?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Just me", @"Me and Friends",@"More info",nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
        [actionSheet showInView:self.view];
    }
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if ([self.upcomingGigsUserIsInterestedIn containsObject:self.upcomingGigCurrentlyClickedOn]) {

        if (buttonIndex == 0){
            //user event already exisits lets add friends to it
            [self performSegueWithIdentifier:@"SelectFriends" sender:self];
            
        }else if (buttonIndex == 1){
            //performSegueFromUpcomingGig = YES;
            [self performSegueWithIdentifier:@"showMoreInfo" sender:self];
        }

    
    
    
    
    }else{
        //else creat a new user event for it
        if (buttonIndex == 0)
        {
            ///just me
            NSArray *recipientId =  @[[[PFUser currentUser]objectId]];
            
            [self.JCParseQuerys creatUserEventForParseEventObjct:self.upcomingGigCurrentlyClickedOn witheventImage:self.diaryObject.artistImage invitedUsers:recipientId complectionBlock:^(NSError *error) {
                if (error) {
                    //show alert view
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"oops!" message:@"Please try sending creating that event again" delegate:self cancelButtonTitle:@"okay" otherButtonTitles:nil];
                    
                    [alert show];
                }else{
                    [self.upcomingGigsUserIsInterestedIn addObject:self.upcomingGigCurrentlyClickedOn];

                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableview reloadData];
                      });
                    
                }
                
            }];
            
        }
        else if (buttonIndex == 1)
        {
            //me and firneds
            //this will creat a user event with current user and friends
            [self performSegueWithIdentifier:@"SelectFriends" sender:self];
        }else if (buttonIndex == 2)
        {
            
            [self performSegueWithIdentifier:@"showMoreInfo" sender:self];
            
        }
        
        
    }
    
    
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"SelectFriends"]) {
        
        
        if ([self.upcomingGigsUserIsInterestedIn containsObject:self.upcomingGigCurrentlyClickedOn]) {
     //we need to get the Userevent object fot that upcoming gig
    //then we need to add pople to currently clicked on gig becuase it already exisits and user has exprssed intres init
            

        for (PFObject *userEvent in self.upcomingGigsUserIsInterestedInUserEventObjects) {
            
            
                NSDate *userEventDateTime = [userEvent objectForKey:JCUserEventUsersEventDate];
                NSString *upcomingGigDateTime = [self.upcomingGigCurrentlyClickedOn objectForKey:JCUpcomingEventDateTimeString];
            
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"yyy-MM-dd'T'HH:mm:ss"];
                NSDate *upcomingEventDateTimeFormatted = [dateFormat dateFromString:upcomingGigDateTime];
            
                NSString *userEventVenue = [userEvent objectForKey:JCUserEventUsersEventCity];
                NSString *upcomingGigCity = [self.upcomingGigCurrentlyClickedOn objectForKey:JCUpcomingEventVenueCity];
            
            if ([userEventDateTime isEqual:upcomingEventDateTimeFormatted]&&[userEventVenue isEqualToString:upcomingGigCity]) {
                    NSLog(@"%@",userEvent);
                    NSLog(@"%@",self.upcomingGigCurrentlyClickedOn);
                    
                    UINavigationController *SelectFriendsNav = (UINavigationController*)segue.destinationViewController;
                    JCSelectFriends *SelectFreindsVC = [SelectFriendsNav viewControllers][0];
                    SelectFreindsVC.tableViewType = JCSendEventIntivesPageAddUserToExistingEvent;
                    SelectFreindsVC.ParseEventObject = userEvent;

                }
                
                
            };
            
            
            
        }
  
    }else if ([segue.identifier isEqualToString:@"showMoreInfo"]){
        
        
        JCGigMoreInfoDetailedView *DVC = (JCGigMoreInfoDetailedView*)[segue destinationViewController];
        eventObject *eventObjectForMoreInfo = [[eventObject alloc]init];
        eventObjectForMoreInfo.eventTitle = [self.upcomingGigCurrentlyClickedOn objectForKey:@"title"];
        eventObjectForMoreInfo.photoDownload.image = self.diaryObject.artistImage;
        eventObjectForMoreInfo.eventDate = [self.upcomingGigCurrentlyClickedOn objectForKey:@"datetime"];
        eventObjectForMoreInfo.venueName = [self.upcomingGigCurrentlyClickedOn objectForKey:@"venueName"];
        eventObjectForMoreInfo.county = [self.upcomingGigCurrentlyClickedOn objectForKey:@"city"];
        
        
        eventObjectForMoreInfo.LatLong = @{ @"lat" : [self.upcomingGigCurrentlyClickedOn objectForKey:@"venueLatitude"],
                          @"long": [self.upcomingGigCurrentlyClickedOn objectForKey:@"venueLongitude"]};

        DVC.currentEventEventObject = eventObjectForMoreInfo;
        
        
        
    }
    
}

@end
