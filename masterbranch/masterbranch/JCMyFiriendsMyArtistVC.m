//
//  JCMyFiriendsMyArtistVC.m
//  PreAmp
//
//  Created by james cash on 20/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCMyFiriendsMyArtistVC.h"
#import "JCParseQuerys.h"
#import <Parse/Parse.h>
#import "JCMyFriendsCell.h"
#import "JCAddMyFriendsVC.h"
#import "JCConstants.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <TLYShyNavBar/TLYShyNavBarManager.h>
#import "RESideMenu.h"

#import "RKSwipeBetweenViewControllers.h"

#import "JCMusicDiaryPreLoader.h"

#import "DGActivityIndicatorView.h"


@interface JCMyFiriendsMyArtistVC () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *tableViewDataSource;
@property (nonatomic,strong) JCParseQuerys *JCParseQuerys;
@property (nonatomic,strong) NSMutableArray *imageFiles;
//@property (nonatomic,strong) NSArray *MyFireds;
@property (nonatomic,strong) UIImageView *addFriends;
@property (nonatomic,strong) UIImageView *removeFriends;


@end

@implementation JCMyFiriendsMyArtistVC{
    NSString *firendskey;
    NSString *artistkey;
    BOOL isLoading;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    isLoading = YES;
    self.imageFiles = [[NSMutableArray alloc]init];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.tableFooterView = [UIView new];

    
    
    if ([self.tableViewType isEqualToString:JCAddMyFriendsMyArtistTypeFacebookFriends]||[self.tableViewType isEqualToString:JCAddMyFriendsMyArtistTypeFriends]||[self.tableViewType isEqualToString:JCAddMyFriendsMyArtistTypeJustRecentlyAdded]){
        self.tableView.allowsSelection = YES;
     }else{
        self.tableView.allowsSelection = NO;
    }
    
    self.JCParseQuerys = [JCParseQuerys sharedInstance];
    
   
}


- (void) viewWillAppear:(BOOL)animated{
    firendskey = @"friends";
    artistkey =@"artist";
    
    if (![self.tableViewType isEqualToString:JCAddMyFriendsMyArtistTypeFacebookFriends]&&![self.tableViewType isEqualToString:JCAddMyFriendsMyArtistTypeJustRecentlyAdded]) {
        
        self.myFriends = [[NSMutableArray alloc]init];

    }
    
    
   
    
    if ([self.tableViewType isEqualToString:JCAddMyFriendsMyArtistTypeFriends]) {
        [self addNavBarForMyFriendsMyAritst];
        [self setupNavBarForScreen:self.tableViewType];
        
        self.navigationItem.title = @"My Friends";
        self.screenName = @"myFriends Screen";
        
        [self.JCParseQuerys getMyFriends:^(NSError *error, NSArray *response) {
            
            self.tableViewDataSource = [[NSMutableArray alloc]init];
            [self.tableViewDataSource addObjectsFromArray:response];
            //self.tableViewDataSource = response;
            [self.myFriends addObjectsFromArray:response];


            isLoading = NO;

            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                 });
         }];
    }else if ([self.tableViewType isEqualToString:JCAddMyFriendsMyArtistTypeArtist]){
         self.navigationItem.title = @"My Artists";
        [self addNavBarForMyFriendsMyAritst];
        self.screenName = @"myArtist Screen";

        [self.JCParseQuerys getMyAtrits:^(NSError *error, NSArray *response) {
            
            self.tableViewDataSource = [[NSMutableArray alloc]init];
            [self.tableViewDataSource addObjectsFromArray:response];
            
            for (PFObject *artist in response) {
                 PFFile *imageFile = [artist objectForKey:@"thmbnailAtistImage"];
                [self.imageFiles addObject:[@{@"pfFile":imageFile} mutableCopy]];
            }
            isLoading = NO;

            dispatch_async(dispatch_get_main_queue(), ^{
                 [self.tableView reloadData];
            });
         }];
    }else if ([self.tableViewType isEqualToString:JCUserEventUserGoing]){
        
        [self addcontentOffsetForPageView];
        
        
        
        [self.JCParseQuerys getUserGoingToEvent:self.currentUserEvent forEventStatus:JCUserEventUserGoing completionBlock:^(NSError *error, NSArray *userGoing) {
            self.tableViewDataSource = [[NSMutableArray alloc]init];
            [self.tableViewDataSource addObjectsFromArray:userGoing];
            isLoading = NO;

            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
        }];
        
    }else if ([self.tableViewType isEqualToString:JCUserEventUserGotTickets]){
        
        [self addcontentOffsetForPageView];

        [self.JCParseQuerys getUserGoingToEvent:self.currentUserEvent forEventStatus:JCUserEventUserGotTickets completionBlock:^(NSError *error, NSArray *userGoing) {
            self.tableViewDataSource = [[NSMutableArray alloc]init];
            [self.tableViewDataSource addObjectsFromArray:userGoing];
            isLoading = NO;

            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
        }];
       
        
    }else if ([self.tableViewType isEqualToString:JCUserEventUserMaybeGoing]){
        
        [self addcontentOffsetForPageView];
        
        [self.JCParseQuerys getUserGoingToEvent:self.currentUserEvent forEventStatus:JCUserEventUserMaybeGoing completionBlock:^(NSError *error, NSArray *userGoing) {
            self.tableViewDataSource = [[NSMutableArray alloc]init];
            [self.tableViewDataSource addObjectsFromArray:userGoing];
            isLoading = NO;

            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
        }];
        
        
    }else if ([self.tableViewType isEqualToString:JCUserEventUsersEventInvited]){
        
        [self addcontentOffsetForPageView];
        
        [self.JCParseQuerys getUserGoingToEvent:self.currentUserEvent forEventStatus:JCUserEventUsersEventInvited completionBlock:^(NSError *error, NSArray *userGoing) {
            self.tableViewDataSource = [[NSMutableArray alloc]init];
            [self.tableViewDataSource addObjectsFromArray:userGoing];
            isLoading = NO;

            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
        }];
        
        
    }else if ([self.tableViewType isEqualToString:JCAddMyFriendsMyArtistTypeFacebookFriends]){
        self.screenName = @"Facebook Friends Screen";

        [self addcontentOffsetForPageView];
        [self getusersFacebookfriebndsAndRealodTableView];
        
    }else if ([self.tableViewType isEqualToString:JCAddMyFriendsMyArtistTypeJustRecentlyAdded]){
        [self addcontentOffsetForPageView];
        
        [self.JCParseQuerys getPeopleThatRecentlyAddedMe:^(NSError *error, NSArray *response) {
            self.tableViewDataSource = [[NSMutableArray alloc]init];
            [self.tableViewDataSource addObjectsFromArray:response];
            isLoading = NO;

            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
        }];
        
        
    }
    
    
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.tableViewType isEqualToString:JCAddMyFriendsMyArtistTypeFriends]||[self.tableViewType isEqualToString:JCUserEventUserGoing]||[self.tableViewType isEqualToString:JCUserEventUsersEventInvited]||[self.tableViewType isEqualToString:JCUserEventUserMaybeGoing]||[self.tableViewType isEqualToString:JCUserEventUserGotTickets]||[self.tableViewType isEqualToString:JCAddMyFriendsMyArtistTypeFacebookFriends]||[self.tableViewType isEqualToString:JCAddMyFriendsMyArtistTypeJustRecentlyAdded]){
    
        JCMyFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendsCell" forIndexPath:indexPath];
    
        
        PFUser *user =[self.tableViewDataSource objectAtIndex:indexPath.row];
        [cell formateCell:user];
        PFFile *profilePic = [user objectForKey:@"thumbnailProfilePicture"];
        cell.userImage.file = profilePic;
        cell.userImage.contentMode = UIViewContentModeScaleToFill;
        cell.userImage = [self addLayerMaskToImageView:cell.userImage];
       
        
        NSUInteger randomNumber = arc4random_uniform(5);
           switch (randomNumber) {
                case 0:
                    cell.userImage.image = [UIImage imageNamed:@"loadingYellow.png"];
                   cell.userImage.contentMode = UIViewContentModeScaleAspectFill;
                  break;
              case 1:
                  cell.userImage.image = [UIImage imageNamed:@"loadingPink.png"];
                 cell.userImage.contentMode = UIViewContentModeScaleAspectFill;
                  break;
             case 2:
                  cell.userImage.image = [UIImage imageNamed:@"loadingBlue.png"];
                  cell.userImage.contentMode = UIViewContentModeScaleAspectFill;
                  break;
              case 3:
            cell.userImage.image = [UIImage imageNamed:@"loadingGreen.png"];
                  cell.userImage.contentMode = UIViewContentModeScaleAspectFill;
                 break;
           }
        
        if ([self.tableViewType isEqualToString:JCAddMyFriendsMyArtistTypeFacebookFriends]||[self.tableViewType isEqualToString:JCAddMyFriendsMyArtistTypeFriends]||[self.tableViewType isEqualToString:JCAddMyFriendsMyArtistTypeJustRecentlyAdded]){
           
            if ([self IsFriend:user]) {
                
                    UIImage *removeFriends = [UIImage imageNamed:@"iconRemoveFriend.png"];
                    cell.cellButton.image = removeFriends;
               
            }else{
                     UIImage *addFriends = [UIImage imageNamed:@"iconAddFriend.png"];
                  cell.cellButton.image = addFriends;

              }
        
        }
        
        [cell.userImage loadInBackground];
       
        return cell;
      }else if ([self.tableViewType isEqualToString:JCAddMyFriendsMyArtistTypeArtist]){
    
    JCMyArtistCell *cell = [tableView dequeueReusableCellWithIdentifier:@"artistCell" forIndexPath:indexPath];
          PFObject *artist = [self.tableViewDataSource objectAtIndex:indexPath.row];
          [cell formatCell:artist];
          cell.JCMyArtistCellDelegate = self;
          cell.cellIndex = indexPath.row;
          cell.artistImage.file = [artist objectForKeyedSubscript:JCArtistArtistThumbNailImage];
          cell.artistImage = [self addLayerMaskToImageView:cell.artistImage];
      
            NSUInteger randomNumber = arc4random_uniform(5);
            switch (randomNumber) {
                case 0:
                    cell.artistImage.image = [UIImage imageNamed:@"loadingYellow.png"];
                    cell.artistImage.contentMode = UIViewContentModeScaleAspectFill;
                    break;
                case 1:
                    cell.artistImage.image = [UIImage imageNamed:@"loadingPink.png"];
                    cell.artistImage.contentMode = UIViewContentModeScaleAspectFill;
                    break;
                case 2:
                    cell.artistImage.image = [UIImage imageNamed:@"loadingBlue.png"];
                    cell.artistImage.contentMode = UIViewContentModeScaleAspectFill;
                    break;
                case 3:
                    cell.artistImage.image = [UIImage imageNamed:@"loadingGreen.png"];
                    cell.artistImage.contentMode = UIViewContentModeScaleAspectFill;
                    break;
                    
            }
          
          [cell.artistImage loadInBackground];

      return cell;
    }
    
    return nil;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableViewDataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 68;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    
   if ([self.tableViewType isEqualToString:JCAddMyFriendsMyArtistTypeFacebookFriends]||[self.tableViewType isEqualToString:JCAddMyFriendsMyArtistTypeFriends]||[self.tableViewType isEqualToString:JCAddMyFriendsMyArtistTypeJustRecentlyAdded]){
   
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    JCMyFriendsCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    //if user tapped is a friend add them, else remove them
    PFUser *user = [self.tableViewDataSource objectAtIndex:indexPath.row];
    
    //if relation for the current key doesnt exist on parse it will be created otherwise the existing one is is returned
    PFRelation *FriendsRelation = [[PFUser currentUser] relationForKey:@"FriendsRelation"];
    
       
    if ([self IsFriend:user]) {
        
        UIImage *removeFriends = [UIImage imageNamed:@"iconRemoveFriend.png"];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.cellButton.image = removeFriends;
        });

        for (PFUser *firend in self.myFriends){
            
            if ( [firend.objectId isEqualToString:user.objectId] ) {
                [self.myFriends removeObject:firend];
                break;
            }
            

           [PFObject unpinAllObjectsInBackgroundWithName:@"MyFriends"];
           [FriendsRelation removeObject:user];
            
        
        }
    }else{
        
        UIImage *addFriends = [UIImage imageNamed:@"iconAddFriend.png"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.cellButton.image = addFriends;
        });

        [self.myFriends addObject:user];
        [PFObject unpinAllObjectsInBackgroundWithName:@"MyFriends"];
        [FriendsRelation addObject:user];
        

        [self.JCParseQuerys postActivtyForUserActionAddFriend:user completionBlock:^(NSError *error) {
            
            if (error) {
                NSLog(@"%@",error);
            }
            
        }];
        
    }
       dispatch_async(dispatch_get_main_queue(), ^{
           [self.tableView reloadData];
       });
       
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error){
            NSLog(@"error saving friend relation delete friend %@",error);
        }else{
            NSLog(@"user saved");
        }
    
    
    }];
       
   }
   else if ([self.tableViewType isEqualToString:JCAddMyFriendsMyArtistTypeFacebookFriends]){
       
       
       
       
       
   }
}

#pragma - HelperMethods

-(void)didClickUnFollowArtistButton:(NSInteger)cellIndex{
    
    [self.JCParseQuerys UserUnfollowedArtistWithArtistObject:[self.tableViewDataSource objectAtIndex:cellIndex] complectionBlock:^(NSError *error) {
       
        [self.tableViewDataSource removeObjectAtIndex:cellIndex];
        
        dispatch_async(dispatch_get_main_queue(), ^{
                
            [self.tableView reloadData];
            });
        
    }];
    
}

-(BOOL)IsFriend:(PFUser *)user{
    
    for (PFUser *firend in self.myFriends){
        
        if ( [firend.objectId isEqualToString:user.objectId] ) {
            return YES;
        }
    }
    
    return NO;
}

-(PFImageView*)addLayerMaskToImageView:(PFImageView*)imageView{
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(2.0, 2.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height);
    maskLayer.path = maskPath.CGPath;
    imageView.layer.mask = maskLayer;
    return imageView;
}

-(void)getusersFacebookfriebndsAndRealodTableView{
    
    
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"/me/friends"
                                  parameters:nil
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        
        NSArray *facebookUsers = result[@"data"];
        NSMutableArray *facebookUserIds = [[NSMutableArray alloc]init];
        for (NSDictionary *facebookUser in facebookUsers) {
            NSString *FBUserId = facebookUser[@"id"];
            [facebookUserIds addObject:FBUserId];
        }
        
        [self.JCParseQuerys getPreAmpUsersThatMatchTheseFBids:facebookUserIds completionblock:^(NSError *error, NSArray *response) {
            
            if (error) {
                NSLog(@"error getting Users for FBIds %@",error);
            }else{
                self.tableViewDataSource = response;
                isLoading = NO;

                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }
            
        }];
    }];
}

- (void)setupNavBarForScreen:(NSString*)screenType
{
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton setImage:[UIImage imageNamed:@"iconPlus.png"] forState:UIControlStateNormal];
    //searchButton.adjustsImageWhenDisabled = NO;
    searchButton.frame = CGRectMake(0, 0, 40, 40);
    [searchButton addTarget:self action:@selector(serchbuttonPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *searchbarbutton = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    self.navigationItem.rightBarButtonItem = searchbarbutton;
    
}

-(void)serchbuttonPressed{
    //TODO why did that crash here?
    [self performSegueWithIdentifier:@"addFriends" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"addFriends"]){
        //Pass list of friends to add freinds VC so it knows who's alrealdy your friends3
        
        RKSwipeBetweenViewControllers *DVC = (RKSwipeBetweenViewControllers*)segue.destinationViewController;
        DVC.comingFromUserEventsPage = NO;
        DVC.myFriends = self.myFriends;
    }
};


- (void)addNavBarForMyFriendsMyAritst
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"iconMenu.png"] forState:UIControlStateNormal];
    backButton.adjustsImageWhenDisabled = NO;
    backButton.frame = CGRectMake(0, 0, 40, 40);
    [backButton addTarget:self action:@selector(BackButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    //create a UIBarButtonItem with the button as a custom view
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = customBarItem;
    //[self.tableView setContentInset:UIEdgeInsetsMake(-200,0,0,0)];
    self.shyNavBarManager.scrollView = self.tableView;
    
}
- (void)addcontentOffsetForPageView
{
    [self.tableView setContentInset:UIEdgeInsetsMake(80,0,0,0)];
}

-(void)BackButtonPressed{
    [self.sideMenuViewController presentLeftMenuViewController];

}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView
{
    if (isLoading) {
        
        JCMusicDiaryPreLoader *musicDiaryPreLoder = [JCMusicDiaryPreLoader instantiateFromNib];
        
        musicDiaryPreLoder.frame = self.tableView.frame;
        
//        
//        DGActivityIndicatorView *prelaoder = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallGridBeat tintColor:[UIColor colorWithRed:234.0f/255.0f green:65.0f/255.0f blue:150.0f/255.0f alpha:1.0f] size:100.0f];
//        prelaoder.center = musicDiaryPreLoder.center;
//        [musicDiaryPreLoder addSubview:prelaoder];
        musicDiaryPreLoder.UILableTextString.text = @"Loading..";
//        [prelaoder startAnimating];
        
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
    if ([self.tableViewType isEqualToString:JCAddMyFriendsMyArtistTypeArtist]) {
        text = @"Follow some Artists";
    }else if ([self.tableViewType isEqualToString:JCAddMyFriendsMyArtistTypeFacebookFriends]){
        text = @"No facebook friends found";
    }else if ([self.tableViewType isEqualToString:JCAddMyFriendsMyArtistTypeFriends]){
        text = @"Add some friends";
    }else if ([self.tableViewType isEqualToString:JCAddMyFriendsMyArtistTypeJustAddedFriends ]){
        text = @"No activity to report here";
    }else if ([self.tableViewType isEqualToString:JCAddMyFriendsMyArtistTypePreAmpFriends ]){
        text = @"Search for your friends";
    }else if ([self.tableViewType isEqualToString:JCUserEventUserGoing ]){
        text = @"Nobody updated to going yet";
    }else if ([self.tableViewType isEqualToString:JCUserEventUserMaybeGoing ]){
        text = @"Nobody updated to maybe yet";
    }else if ([self.tableViewType isEqualToString:JCUserEventUserGotTickets ]){
        text = @"Nobody has tickets yet";
    }else{
        text = @"oops";
    }
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

-(NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text;
    if ([self.tableViewType isEqualToString:JCAddMyFriendsMyArtistTypeArtist]) {
        text = @"Follow artist from the homesceen so we can build your personal gig discover calander";
    }else if ([self.tableViewType isEqualToString:JCAddMyFriendsMyArtistTypeFacebookFriends]){
        text = @"We cant find any of your facebook friends on Preamp right now";
    }else if ([self.tableViewType isEqualToString:JCAddMyFriendsMyArtistTypeFriends]){
        text = @"Click the plus icon in the top right to add some friends";
    }else if ([self.tableViewType isEqualToString:JCAddMyFriendsMyArtistTypeJustAddedFriends ]){
        text = @"Seems like nobody has added you recently";
    }else if ([self.tableViewType isEqualToString:JCAddMyFriendsMyArtistTypePreAmpFriends ]){
        text = @"Type your friends username to find them";
    }else if ([self.tableViewType isEqualToString:JCUserEventUserGoing ]){
        text = @"Be the first person to update your status to going";
    }else if ([self.tableViewType isEqualToString:JCUserEventUserMaybeGoing ]){
        text = @"Be the first person to update your status to maybe";
    }else if ([self.tableViewType isEqualToString:JCUserEventUserGotTickets ]){
        text = @"Be the first of your friends to get tickets";
    }else{
        text = @"oops";
    }
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}


@end
