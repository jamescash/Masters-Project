//
//  JCSearchPageDetailView.m
//  PreAmp
//
//  Created by james cash on 01/12/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCSearchPageDetailView.h"
#import "JCHomeScreenDataController.h"
#import "JCConstants.h"
#import "JCUpcomingGigTableViewCell.h"
#import "HeaderViewWithImage.h"
#import "HeaderView.h"
#import "UIScrollView+VGParallaxHeader.h"
#import "JCSearchHeaders.h"
#import "JCNoIrishGigsCell.h"
#import "JCSearchResultsHeaderView.h"
#import "JCParseQuerys.h"
#import "JCSelectFriends.h"
#import "JCGigMoreInfoDetailedView.h"


@interface JCSearchPageDetailView ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableDictionary *tableViewDataSource;
@property (nonatomic,strong) NSMutableArray *tableViewDataSourceKeys;
@property (nonatomic,strong) JCHomeScreenDataController *JCSearchAPI;
@property (strong,nonatomic ) CAGradientLayer *vignetteLayer;
@property (strong,nonatomic) JCSearchResultsHeaderView *headerView;
@property (strong,nonatomic)NSString *resultsType;
@property (nonatomic,strong) JCParseQuerys *JCParseQuerys;
@property (nonatomic,strong) NSMutableArray *upcomingGigsUserIsInterestedIn;
@property (strong,nonatomic) NSMutableArray *upcomingGigsUserIsInterestedInUserEventObjects;
@property (nonatomic,strong) eventObject *upcomingGigOfIntrest;
@property (nonatomic,strong) NSIndexPath *upcomingGigOfIntrestIndexPath;

@end

@implementation JCSearchPageDetailView{
    BOOL performSegueFromUpcomingGig;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.JCSearchAPI = [[JCHomeScreenDataController alloc]init];
    self.tableViewDataSource = [[NSMutableDictionary alloc]init];
    self.upcomingGigsUserIsInterestedIn = [[NSMutableArray alloc]init];
    self.upcomingGigsUserIsInterestedInUserEventObjects = [[NSMutableArray alloc]init];
    self.JCParseQuerys = [JCParseQuerys sharedInstance];
    [self addCustomButtonOnNavBar];
    [self layoutHeaderViewWithArtistImage:self.artistImage];
    [self GetArtistUpComingGigsFromBandsInTown:self.artistName];
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.tableFooterView = [UIView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.tableViewDataSource count];
}

//
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *key = self.tableViewDataSourceKeys [section];
    NSArray *currentSection = [self.tableViewDataSource objectForKey:key];
    return  [currentSection count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    JCUpcomingGigTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"upComingGig"];
    cell.cellIndexNSIndexPath = indexPath;
    cell.JCUpcomingGigTableViewCellDelegate = self;

    NSString *key = self.tableViewDataSourceKeys[indexPath.section];
    NSArray *currentSection = [self.tableViewDataSource objectForKey:key];
    eventObject *event = currentSection[indexPath.row];
    
    if (!event.isUserInterestedInUpcomingGigFinishedLoading) {
       [self isUserInterestedInUpcomingGig:event AtIndex:indexPath];
    }
  
    [cell formatCell:event userIsInterested:event.userIsInterestedInEvent];
    return cell;


}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    static NSString *headerViews = @"header";
    static NSString *noIrishGigsHeader = @"noIrishGigs";

    JCSearchHeaders *headerView = [tableView dequeueReusableCellWithIdentifier:headerViews];
    JCNoIrishGigsCell *noIrishGigsCell = [tableView dequeueReusableCellWithIdentifier:noIrishGigsHeader];
    NSString *key = self.tableViewDataSourceKeys[section];
    NSArray  *currentSection = [self.tableViewDataSource objectForKey:key];
    
    if ([key isEqualToString:JCSeachPageResultsDicResultsInIreland]) {
        if ([currentSection count]!=0) {
            [headerView formatHeaderWithTitle:@"Irish tour dates"];
            return headerView;
        }else{
            //[headerView formatHeaderWithTitle:@"No Irish tour dates"];
            NSString *cellText = [NSString stringWithFormat:@"Looks like %@ has no upcoming Irish tour dates",self.artistName];
            [noIrishGigsCell formateCellWithText:cellText];
            return noIrishGigsCell;
        }
        
    }else if ([key isEqualToString:JCSeachPageResultsDicResultsNearIreland]){
        [headerView formatHeaderWithTitle:@"Tour dates near Ireland"];
    }else if ([key isEqualToString:JCSeachPageResultsDicResultsOtherTourDates]){
        if ([currentSection count]!=0) {
            [headerView formatHeaderWithTitle:@"Other tour dates"];
        }else{
            [headerView formatHeaderWithTitle:@"No other tour dates found"];
        }
    }

 
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    NSString *key = self.tableViewDataSourceKeys[section];
    NSArray  *currentSection = [self.tableViewDataSource objectForKey:key];
    int sectionHieght;
    
    if ([key isEqualToString:JCSeachPageResultsDicResultsInIreland]) {
        if ([currentSection count]!=0) {
            sectionHieght = 50;
        }else{
            sectionHieght = 60;
        }
    }else if ([key isEqualToString:JCSeachPageResultsDicResultsNearIreland]){
        sectionHieght = 50;
        
    }else if ([key isEqualToString:JCSeachPageResultsDicResultsOtherTourDates]){
        if ([currentSection count]!=0) {
            sectionHieght = 50;

        }else{
            sectionHieght = 50;
        }
    }
    
    return sectionHieght;
    
    
}

#pragma - Upcoming Cell Delage 

-(void)didClickInviteFriendsOnUpcomingGigAtNSIndexPath:(NSIndexPath *)cellIndex{
    
    NSString *key = self.tableViewDataSourceKeys [cellIndex.section];
    NSArray *gigArray = [self.tableViewDataSource objectForKey:key];
    eventObject *upcomingGigClickedOn = gigArray [cellIndex.row];
    self.upcomingGigOfIntrest = upcomingGigClickedOn;
    self.upcomingGigOfIntrestIndexPath = cellIndex;
    self.upcomingGigOfIntrest.photoDownload.image = self.artistImage;
    if ([self.upcomingGigsUserIsInterestedIn containsObject:upcomingGigClickedOn]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"This gig is in your upcoming events" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Add Friends",@"View on map",nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
        [actionSheet showInView:self.view];
    }else{
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Interested in attending this upcoming gig?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Just me", @"Me and Friends",@"View on map", nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
        [actionSheet showInView:self.view];
    }
}

#pragma - Action sheet delagte

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
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
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"oops!" message:@"Please try creating that event again" delegate:self cancelButtonTitle:@"okay" otherButtonTitles:nil];
                    
                    [alert show];
                }else{
                    
                    [self.upcomingGigsUserIsInterestedIn addObject:self.upcomingGigOfIntrest];
                    
                    self.upcomingGigOfIntrest.userIsInterestedInEvent = YES;
                    self.upcomingGigOfIntrest.isUserInterestedInUpcomingGigFinishedLoading = YES;
                    
                    NSString *key = self.tableViewDataSourceKeys [self.upcomingGigOfIntrestIndexPath.section];
                    NSArray *upcomingGigsSection = [self.tableViewDataSource objectForKey:key];
                    NSMutableArray *replacmentArray = [[NSMutableArray alloc]init];
                    
                    [replacmentArray addObjectsFromArray:upcomingGigsSection];
                    
                    [replacmentArray replaceObjectAtIndex:self.upcomingGigOfIntrestIndexPath.row withObject:self.upcomingGigOfIntrest];
                    
                    [self.tableViewDataSource setValue:replacmentArray forKey:key];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                       // [self.tableView reloadData];
                        
                        [self.tableView reloadRowsAtIndexPaths:@[self.upcomingGigOfIntrestIndexPath] withRowAnimation:UITableViewRowAnimationNone];
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

#pragma - Get Data
- (void)GetArtistUpComingGigsFromBandsInTown:(NSString*)artistName{
    
    
    NSString *artistNameEncodedRequest = [artistName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    
    self.headerView.ArtistName.text = @"loading..";
    
    [self.JCSearchAPI getmbidNumberfor:artistNameEncodedRequest competionBlock:^(NSError *error, NSString *mbid) {
        
        if (error) {
            NSLog(@"%@ getting MBID",error);
        }else{
            
            [self.JCSearchAPI getArtistUpComingEventsForArtistSearch:artistNameEncodedRequest andMbidNumber:mbid competionBlock:^(NSError *error, NSDictionary *results) {
                
                if (error) {
                    NSLog(@"getArtistUpComingEventsForArtistSearch %@",[error localizedDescription]);
                }else{
                
                if ([[results objectForKey:JCSeachPageResultsDicResults] isKindOfClass:[NSString class]] ) {
                    NSString *resultsType = [results objectForKeyedSubscript:JCSeachPageResultsDicResults];
                    if ([resultsType isEqualToString:JCSeachPageResultsDicNoUpcomingGigs]) {
                        self.resultsType = JCSeachPageResultsDicNoUpcomingGigs;
                        [self handelEmptyResults];
                    }else if([resultsType isEqualToString:JCSeachPageResultsDicResultsArtistUnknown]){
                        self.resultsType = JCSeachPageResultsDicResultsArtistUnknown;
                        [self handelEmptyResults];
                    }
                }else{
                    
                    NSMutableDictionary *resultsDictionary = [[NSMutableDictionary alloc]init];
                    resultsDictionary = [results objectForKey:JCSeachPageResultsDicResults];
                    self.tableViewDataSourceKeys = [[NSMutableArray alloc]init];
                    
                    //[self.tableViewDataSourceKeys addObjectsFromArray:[resultsDictionary allKeys]];
                    NSArray *keys = [resultsDictionary allKeys];
                   
                    if ([keys containsObject:JCSeachPageResultsDicResultsNearIreland]) {
                        [self.tableViewDataSourceKeys insertObject:JCSeachPageResultsDicResultsInIreland atIndex:0];
                         [self.tableViewDataSourceKeys insertObject:JCSeachPageResultsDicResultsNearIreland atIndex:1];
                        [self.tableViewDataSourceKeys insertObject:JCSeachPageResultsDicResultsOtherTourDates atIndex:2];
                    }else{
                       [self.tableViewDataSourceKeys insertObject:JCSeachPageResultsDicResultsInIreland atIndex:0];
                       [self.tableViewDataSourceKeys insertObject:JCSeachPageResultsDicResultsOtherTourDates atIndex:1];
                    }
                     self.tableViewDataSource = resultsDictionary;
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.headerView.ArtistName.text = self.artistName;
                        [self.tableView reloadData];
                    
                      });
                   }
                 }
            }];
         }
     }];
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
        
            
            NSString *key = self.tableViewDataSourceKeys [indexPath.section];
            NSArray *upcomingGigsSection = [self.tableViewDataSource objectForKey:key];
            NSMutableArray *replacmentArray = [[NSMutableArray alloc]init];
            
            [replacmentArray addObjectsFromArray:upcomingGigsSection];
            
            [replacmentArray replaceObjectAtIndex:indexPath.row withObject:upcomingGig];
            
            [self.tableViewDataSource setValue:replacmentArray forKey:key];
        
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            });
        
        
        
        }
        
    }];
    
    
}

- (void)layoutHeaderViewWithArtistImage:(UIImage*)artistImage{
    
    // Do any additional setup after loading the view, typically from a nib.
    self.headerView = [JCSearchResultsHeaderView instantiateFromNib];
    if (artistImage) {
        self.headerView.HeaderImageView.image = artistImage;
    }else{
        [self setNameAndImageOnHeaderView:self.artistName];
    }
    self.headerView.UIImageViewFollwIcon.image = [UIImage imageNamed:@"iconFollowArtist"];
    self.vignetteLayer = [CAGradientLayer layer];
    [self.vignetteLayer setBounds:[self.headerView.HeaderImageView bounds]];
    [self.vignetteLayer setPosition:CGPointMake([self.headerView.HeaderImageView  bounds].size.width/2.0f, [self.headerView.HeaderImageView  bounds].size.height/2.0f)];
    UIColor *lighterBlack = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.9];
    [self.vignetteLayer setColors:@[(id)[[UIColor clearColor] CGColor], (id)[lighterBlack CGColor]]];
    [self.vignetteLayer setLocations:@[@(.10), @(1.0)]];
    [[self.headerView.HeaderImageView  layer] addSublayer:self.vignetteLayer];
    
    [self.tableView setParallaxHeaderView:self.headerView
                                       mode:VGParallaxHeaderModeFill
                                     height:200];
    
}

- (void)setNameAndImageOnHeaderView:(NSString*)artistName {


        //making a seperate call to bandsintown to get the artist image, this means we will get the image even if that artist has no upcmoing gigs.

 NSString *artistNameEncodedRequest = [artistName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];

    [self.JCSearchAPI getArtistImage:artistNameEncodedRequest andMbidNumber:nil competionBlock:^(NSError *error, NSDictionary *artistInfo) {




            if (error) {
                dispatch_async(dispatch_get_main_queue(), ^{

                NSLog(@"%@",error);
                self.headerView.HeaderImageView.image = [UIImage imageNamed:@"loadingGray.png"];
                self.headerView.ArtistName.text = @"loading..";
                });

            }else{
                NSString  *artistName = [artistInfo objectForKey:@"artistName"];
                UIImage   *artistImage = [artistInfo objectForKey:@"artistImage"];


                 if (artistName == nil&&artistImage == nil){
                     dispatch_async(dispatch_get_main_queue(), ^{

                     self.headerView.ArtistName.text = @"Uknown Artist";
                    });

                 }else{

                     dispatch_async(dispatch_get_main_queue(), ^{

                     self.headerView.HeaderImageView.image = artistImage;
                         self.artistImage = artistImage;
                         self.headerView.ArtistName.text = artistName;

                     });

                 }



            }

        }];





}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.tableView shouldPositionParallaxHeader];
}

#pragma - HelperMethods
- (void)addCustomButtonOnNavBar
{
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [menuButton setImage:[UIImage imageNamed:@"iconBack.png"] forState:UIControlStateNormal];
    //[menuButton setImage:[UIImage imageNamed:@"iconMenu.png"] forState:UIControlStateHighlighted];
    menuButton.adjustsImageWhenDisabled = NO;
    //set the frame of the button to the size of the image (see note below)
    menuButton.frame = CGRectMake(0, 0, 40, 40);
    menuButton.opaque = YES;
    
    [menuButton addTarget:self action:@selector(menuButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    //create a UIBarButtonItem with the button as a custom view
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    self.navigationItem.leftBarButtonItem = customBarItem;
}
- (void)menuButtonPressed{
    //[self.SearchBar resignFirstResponder];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    //[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)handelEmptyResults{
    self.headerView.ArtistName.text = self.artistName;
    [self.tableViewDataSource removeAllObjects];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
    
}

#pragma - EmptyDataSet
-(NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    
    NSString *text = @"Loading...";
    
    if ([self.resultsType isEqualToString:JCSeachPageResultsDicNoUpcomingGigs]){
        text = @"No upcoming gigs found";
    }else if ([self.resultsType isEqualToString:JCSeachPageResultsDicResultsArtistUnknown]){
        text = @"Unkown Artist";
        
    }
    
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
-(NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = [NSString stringWithFormat:@"Gathering upcoming gig's for %@",self.artistName];
    
    
    if ([self.resultsType isEqualToString:JCSeachPageResultsDicNoUpcomingGigs]){
        text =[NSString stringWithFormat: @"Looks like we couldn't find any upcoming gigs for %@",self.artistName];
    }else if ([self.resultsType isEqualToString:JCSeachPageResultsDicResultsArtistUnknown]){
        text =[NSString stringWithFormat: @"We dont seem to have %@ on our database",self.artistName];
        
    }
    
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"SelectFriends"]) {
        
        
       
        
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
                
                
                
            }
            
            
            
        
    }else if ([segue.identifier isEqualToString:@"showMoreInfo"]){
        
        JCGigMoreInfoDetailedView *DVC = (JCGigMoreInfoDetailedView*)[segue destinationViewController];
        if (!performSegueFromUpcomingGig) {
            DVC.currentEventEventObject = self.upcomingGigOfIntrest;
            
        }else{
            DVC.currentEventEventObject = self.upcomingGigOfIntrest;
        }
        
    }
    
}

@end
