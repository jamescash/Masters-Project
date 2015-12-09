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
#import "JCToastAndAlertView.h"


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
@property (nonatomic,strong) eventObject *gigToTakeFollowArtistInformationFrom;
@property (nonatomic,strong) JCToastAndAlertView *toast;
@end

@implementation JCSearchPageDetailView{
    BOOL performSegueFromUpcomingGig;

    //In the middle of figuring out if user id following artist
    BOOL userIsFollowingCurentArtist;
    UITapGestureRecognizer *followArtistTapped;
    eventObject *eventWithArtist;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.toast = [[JCToastAndAlertView alloc]init];
    self.JCSearchAPI = [[JCHomeScreenDataController alloc]init];
    self.tableViewDataSource = [[NSMutableDictionary alloc]init];
    self.upcomingGigsUserIsInterestedIn = [[NSMutableArray alloc]init];
    self.upcomingGigsUserIsInterestedInUserEventObjects = [[NSMutableArray alloc]init];
    self.JCParseQuerys = [JCParseQuerys sharedInstance];
    [self addCustomButtonOnNavBar];
    [self layoutHeaderViewWithArtistImage:self.artistImage];
    [self GetArtistUpComingGigsFromBandsInTown:self.artistName];
    [self isUserFollowingAritst];
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.tableFooterView = [UIView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"relod");
    dispatch_async(dispatch_get_main_queue(), ^{
                
        [self.tableView reloadData];
            });
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
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"This gig is in your upcoming events" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Add Friends",@"More info",nil];
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
            NSString *key = self.tableViewDataSourceKeys [self.upcomingGigOfIntrestIndexPath.section];
            NSArray *upcomingGigsSection = [self.tableViewDataSource objectForKey:key];
            NSMutableArray *replacmentArray = [[NSMutableArray alloc]init];
            
            [replacmentArray addObjectsFromArray:upcomingGigsSection];
            
            [replacmentArray replaceObjectAtIndex:self.upcomingGigOfIntrestIndexPath.row withObject:self.upcomingGigOfIntrest];
            
            [self.tableViewDataSource setValue:replacmentArray forKey:key];
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
                    [self.toast showUserUpDateToastWithMessage:[NSString stringWithFormat:@"%@ added to your upcoming gigs, now ask some friends to go with you",self.artistName]];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
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
    //init the header view and add all the properties
    self.headerView = [JCSearchResultsHeaderView instantiateFromNib];
    self.headerView.UIActivityIndicator.hidden = YES;
    if (artistImage) {
        self.headerView.HeaderImageView.image = artistImage;
    }else{
        //if the user clicked the artist befoure there image loaded on the search results page we have to download it in here 
        [self setNameAndImageOnHeaderView:self.artistName];
    }
    
    followArtistTapped = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(followArtistTapped)];
    [self.headerView.UIViewHitTargetFollowArtist addGestureRecognizer:followArtistTapped];
    
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

-(void)followArtistTapped{
    
    [self setHeaderViewFollowArtistButtonToLoadingState];
    
    if (userIsFollowingCurentArtist) {
        //unfollow
        
        if (self.gigToTakeFollowArtistInformationFrom) {
            [self.JCParseQuerys UserUnfollowedArtist:self.gigToTakeFollowArtistInformationFrom complectionBlock:^(NSError *error) {
                
                if (error) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ooops"
                                                                    message:@"We couldnt unfollow that artist, please try again"
                                                                   delegate:self
                                                          cancelButtonTitle:@"Okay"
                                                          otherButtonTitles:nil];
                    [alert show];
                }else{
                    NSLog(@"User Unfollowed Artist");
                    [self.toast showUserUpDateToastWithMessage:[NSString stringWithFormat:@"You unfollowed %@",self.artistName]];
                    userIsFollowingCurentArtist = NO;
                    [self setHeaderViewFollowArtistToFollowState];
                    
                    
                }
                
                
                
            }];

        }else{
            
            [self getArtistImfomation:self.artistName completionBlock:^(NSError *error, eventObject *followAritst) {
                if (error) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ooops"
                                                                    message:@"We couldnt unfollow that artist, please try again"
                                                                   delegate:self
                                                          cancelButtonTitle:@"Okay"
                                                          otherButtonTitles:nil];
                    [alert show];                }else{
                [self unfollowArtist:followAritst completionBlock:^(NSError *error) {
                    if (error) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ooops"
                                                                        message:@"We couldnt unfollow that artist, please try again"
                                                                       delegate:self
                                                              cancelButtonTitle:@"Okay"
                                                              otherButtonTitles:nil];
                        [alert show];
                    }else{
                        NSLog(@"User Unfollowed Artist");
                        [self.toast showUserUpDateToastWithMessage:[NSString stringWithFormat:@"You unfollowed %@",self.artistName]];

                        userIsFollowingCurentArtist = NO;
                        [self setHeaderViewFollowArtistToFollowState];
                        
                        
                    }
                    
                }];
                    
                }
                
                
            }];
            
            
        }
        
        
        
        
        
    }else{
        //follow
        
        if (self.gigToTakeFollowArtistInformationFrom) {
            [self followArtist:self.gigToTakeFollowArtistInformationFrom completionBlock:^(NSError *error) {
                if (error) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ooops"
                                                                    message:@"We couldnt follow that artist, please try again"
                                                                   delegate:self
                                                          cancelButtonTitle:@"Okay"
                                                          otherButtonTitles:nil];
                    [alert show];
                    
                }else{
                    NSLog(@"User followed Artist");
                    userIsFollowingCurentArtist = YES;
                    [self.toast showUserUpDateToastWithMessage:[NSString stringWithFormat:@"You followed %@",self.artistName]];

                    [self setHeaderViewFollowArtistToUnFollowState];
                    
                    // NSLog(@"followed %@",self.artistName);
                }
                
            }];
        }else{
            [self getArtistImfomation:self.artistName completionBlock:^(NSError *error, eventObject *followAritst) {
                
                if (error) {
                    //alert view
                }else{
                    self.gigToTakeFollowArtistInformationFrom = followAritst;
                    [self followArtist:followAritst completionBlock:^(NSError *error) {
                        if (error) {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ooops"
                                                                            message:@"We couldnt follow that artist, please try again"
                                                                           delegate:self
                                                                  cancelButtonTitle:@"Okay"
                                                                  otherButtonTitles:nil];
                            [alert show];
                            
                            
                        }else{
                            NSLog(@"User followed Artist");
                            [self.toast showUserUpDateToastWithMessage:[NSString stringWithFormat:@"You followed %@",self.artistName]];

                            userIsFollowingCurentArtist = YES;

                            [self setHeaderViewFollowArtistToUnFollowState];
                            
                        }
                        
                    }];
                    
                }
                
            }];
        }
     }
}

-(void)isUserFollowingAritst{
    
    [self setHeaderViewFollowArtistButtonToLoadingState];
    
    [self getArtistImfomation:self.artistName completionBlock:^(NSError *error, eventObject *followAritst) {
        
        if (error) {
            
        }else{
            self.gigToTakeFollowArtistInformationFrom = followAritst;
            
            [self.JCParseQuerys isUserFollowingArtist:followAritst completionBlock:^(NSError *error, BOOL userIsFollowingArtist) {
                
                if (userIsFollowingArtist) {
                
                    userIsFollowingCurentArtist = YES;
                    [self setHeaderViewFollowArtistToUnFollowState];

                }else{
                    userIsFollowingCurentArtist = NO;
                    [self setHeaderViewFollowArtistToFollowState];
                    
                }
                
                
               }];
            }
        
    }];
    
    
    
}
-(void)getArtistImfomation:(NSString*)artistName completionBlock:(void(^)(NSError* error, eventObject* followAritst ))finishedgettingArtistInfo{
    
    NSString *artistNameEncodedRequest = [self.artistName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    
    //1.//first get all the nessasery information about the artist
    //2. Add artist to backend
    [self.JCSearchAPI getArtistImage:artistNameEncodedRequest andMbidNumber:nil competionBlock:^(NSError *error, NSDictionary *artistInfo) {
        
        if (error) {
            NSLog(@"%@",error);
        }else{
            
            if (error) {
                
                finishedgettingArtistInfo(error,nil);
            }else{
                NSString  *artistName = [artistInfo objectForKey:@"artistName"];
                UIImage   *artistImage = [artistInfo objectForKey:@"artistImage"];
                NSString *mbid = [artistInfo objectForKey:@"mbid"];
                
                if (artistName == nil&&artistImage == nil){
                    
                    
                }else{
                    eventObject *followArtist = [[eventObject alloc]init];
                    followArtist.eventTitle = artistName;
                    followArtist.mbidNumber = mbid;
                    followArtist.photoDownload.image = artistImage;
                    finishedgettingArtistInfo(nil,followArtist);
                  }
                }
            }
        
    }];
}
-(void)unfollowArtist:(eventObject*)currentEvet completionBlock:(void(^)(NSError* error))finishedUnfollowingArtistInfo{
 
    [self.JCParseQuerys UserUnfollowedArtist:currentEvet complectionBlock:^(NSError *error) {
        if (error) {
            finishedUnfollowingArtistInfo (error);
        }else{
            finishedUnfollowingArtistInfo(nil);
        }
        
    }];


}
-(void)followArtist:(eventObject*)currentEvet completionBlock:(void(^)(NSError* error))finishedFollowingArtistInfo{
    
    [self.JCParseQuerys UserFollowedArtist:currentEvet complectionBlock:^(NSError *error) {
        
        if (error) {
            finishedFollowingArtistInfo (error);
        }else{
            finishedFollowingArtistInfo(nil);
        }
        
    }];
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
    [self.tableViewDataSource removeAllObjects];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.headerView.ArtistName.text = self.artistName;

        [self.tableView reloadData];
    });
    
    
}

-(void)setHeaderViewFollowArtistButtonToLoadingState{
    self.headerView.UIViewHitTargetFollowArtist.userInteractionEnabled = NO;
    self.headerView.UILableFollowLable.text = @"Loading";
    self.headerView.UIImageViewFollwIcon.hidden = YES;
    self.headerView.UIActivityIndicator.color = [UIColor whiteColor];
    self.headerView.UIActivityIndicator.hidden = NO;
    [self.headerView.UIActivityIndicator startAnimating];
    
}

-(void)setHeaderViewFollowArtistToUnFollowState{
    self.headerView.UIViewHitTargetFollowArtist.userInteractionEnabled = YES;

    self.headerView.UILableFollowLable.text = @"Unfollow";
    self.headerView.UIImageViewFollwIcon.image = [UIImage imageNamed:@"iconUnfollowWhite"];
    self.headerView.UIImageViewFollwIcon.hidden = NO;
    self.headerView.UIActivityIndicator.hidden = YES;
    [self.headerView.UIActivityIndicator stopAnimating];
    
}

-(void)setHeaderViewFollowArtistToFollowState{
    self.headerView.UIViewHitTargetFollowArtist.userInteractionEnabled = YES;

    self.headerView.UILableFollowLable.text = @"follow";
    self.headerView.UIImageViewFollwIcon.image = [UIImage imageNamed:@"iconFollowArtistWhite"];
    self.headerView.UIImageViewFollwIcon.hidden = NO;
    self.headerView.UIActivityIndicator.hidden = YES;
    [self.headerView.UIActivityIndicator stopAnimating];
    
    
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
                
//                NSString *key = self.tableViewDataSourceKeys [indexPath.section];
//                NSArray *upcomingGigsSection = [self.tableViewDataSource objectForKey:key];
//                NSMutableArray *replacmentArray = [[NSMutableArray alloc]init];
//                
//                [replacmentArray addObjectsFromArray:upcomingGigsSection];
//                
//                [replacmentArray replaceObjectAtIndex:indexPath.row withObject:upcomingGig];
//                
//                [self.tableViewDataSource setValue:replacmentArray forKey:key];
                
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
