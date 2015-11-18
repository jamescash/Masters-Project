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
#import "JCUpcomingGigTableViewCell.h"
#import "JCTimeDateLocationTableViewCell.h"
#import "JCParseQuerys.h"
#import "JCSelectFriends.h"
#import "MGSwipeButton.h"

#import <TLYShyNavBar/TLYShyNavBarManager.h>






@interface JCGigMoreInfoVC ()
//UIElements
@property (weak, nonatomic) IBOutlet UITableView *TableViewVC;
@property (nonatomic,strong) NSMutableDictionary *tableViewDataSource;
@property (nonatomic,strong) NSArray *tableViewDataSourcekeys;
@property (nonatomic,strong) JCHomeScreenDataController *bandsInTownAPI;
@property (nonatomic,strong) PFUser *currentUser;
@property (nonatomic,strong) JCParseQuerys *JCParseQuerys;
@property (strong,nonatomic ) CAGradientLayer *vignetteLayer;







@end

@implementation JCGigMoreInfoVC{
   NSString *header1Buttons;
   NSString *header2UpcomingGigs;
   NSString *timeDateLocaionCellId;
    BOOL userIsFollowingArtistMainVC;
}




- (void)viewDidLoad {
    [super viewDidLoad];
   

    self.JCParseQuerys = [JCParseQuerys sharedInstance];
    self.bandsInTownAPI = [[JCHomeScreenDataController alloc]init];
    self.tableViewDataSource = [[NSMutableDictionary alloc]init];

    header1Buttons = @"buttonsHeader";
    header2UpcomingGigs = @"MoreUpcomingGigs";
    timeDateLocaionCellId = @"timeDateLocationCell";
    
    self.TableViewVC.allowsSelection = NO;
    [self addCustomButtonOnNavBar];
    [self layouStickyHeaderView];
    
    
    NSArray *timeDateLocaionCellIdArray = @[timeDateLocaionCellId];
    [self.tableViewDataSource setObject:timeDateLocaionCellIdArray forKey:header1Buttons];
    self.tableViewDataSourcekeys = @[header1Buttons,header2UpcomingGigs];
    
    [self.bandsInTownAPI getUpcomingGigsForArtist:self.currentEvent.eventTitle competionBlock:^(NSError *error, NSArray *response){
        
        if (response !=nil) {
            [self.tableViewDataSource setObject:response forKey:header2UpcomingGigs];

        }
         dispatch_async(dispatch_get_main_queue(), ^{
            [self.TableViewVC reloadData];
        });
    }];

    
    [self.JCParseQuerys isUserFollowingArtist:self.currentEvent completionBlock:^(NSError *error, BOOL IsFollowingArtist) {
        
        if (error) {
            NSLog(@"%@",error);
        }else{
           
            
            if (IsFollowingArtist) {
                userIsFollowingArtistMainVC = YES;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.TableViewVC reloadData];
                    });
            }else{
                userIsFollowingArtistMainVC = NO;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.TableViewVC reloadData];
                    });

            }
            
            
        }
    }];



}

- (IBAction)FollowButton:(id)sender {
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
    return [self.tableViewDataSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSString *key = self.tableViewDataSourcekeys[section];
    NSArray *objectfromdataobject = [self.tableViewDataSource objectForKey:key];
    return [objectfromdataobject count];
}


#pragma mark - Table view delagate


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *section = [self.tableViewDataSourcekeys objectAtIndex:indexPath.section];
    
    if ([section isEqualToString:header1Buttons]) {
        JCTimeDateLocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:timeDateLocaionCellId];
        [cell formatCell:self.currentEvent];
        return cell;
    }
    
    if ([section isEqualToString:header2UpcomingGigs]) {
        JCUpcomingGigTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"upComingGig"];
        NSArray *upcomingGigs = self.tableViewDataSource[section];
        [cell formatCell:[upcomingGigs objectAtIndex:indexPath.row]];
        cell.leftButtons = @[[MGSwipeButton buttonWithTitle:@"Invite Friends" icon:nil backgroundColor:[UIColor colorWithRed:234.0f/255.0f green:65.0f/255.0f blue:150.0f/255.0f alpha:1.0f]]];
        cell.delegate = self;
        cell.leftSwipeSettings.transition = MGSwipeTransition3D;
        return cell;
    }

    return nil;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *section = [self.tableViewDataSourcekeys objectAtIndex:indexPath.section];
    
    if ([section isEqualToString:header1Buttons]) {
        
        return 145;
        
    }
    
    if ([section isEqualToString:header2UpcomingGigs]) {
        return 85;

    }
    
    return 90;
    
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        NSString *CellIdentifier = self.tableViewDataSourcekeys[section];
        JCInvteFollowHeaderVC *headerView = (JCInvteFollowHeaderVC*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (headerView == nil){
            headerView = [[JCInvteFollowHeaderVC alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [headerView formatCellButtons:userIsFollowingArtistMainVC];
        headerView.JCInvteFollowHeaderDelegate = self;
        return headerView;
    }else{
        NSString *CellIdentifier = self.tableViewDataSourcekeys[section];
        UITableViewCell *headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (headerView == nil){
            headerView = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        return headerView;
       }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSString *sectionTitle = self.tableViewDataSourcekeys[section];
    
    if ([sectionTitle isEqualToString:header1Buttons]) {
        
        return 80;
    
    }
    
    if ([sectionTitle isEqualToString:header2UpcomingGigs]) {
        return 60;
    }

    
    return 100;
}

-(BOOL) swipeTableCell:(MGSwipeTableCell*) cell tappedButtonAtIndex:(NSInteger) index direction:(MGSwipeDirection)direction fromExpansion:(BOOL) fromExpansion{
    
    NSLog(@"tapped button");
    
    return YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - Actions
- (IBAction)InviteFirends:(id)sender {
}



-(void)didClickFollowArtistButton:(BOOL)userIsFollowingArtist{
    
    if (userIsFollowingArtist) {
        NSLog(@"Follow Action");
        [self.JCParseQuerys UserFollowedArtist:self.currentEvent complectionBlock:^(NSError *error) {
            
            if (error) {
                
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"There was a problem follwing that artist try again" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alert show];
                
            };
            
        }];
    }else{
        
        [self.JCParseQuerys UserUnfollowedArtist:self.currentEvent complectionBlock:^(NSError *error) {
            
            
            
        }];
        
        NSLog(@"UnFollow Action");
    }
    
}

//- (IBAction)FollowArtist:(id)sender {
//    
//    //TODO set the button to following if the users already following the artist
//   
//    
//}




- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"SelectFriends"]) {
        
        
        UINavigationController *SelectFriendsNav = (UINavigationController*)segue.destinationViewController;
        JCSelectFriends *SelectFreindsVC = [SelectFriendsNav viewControllers][0];
        //pass the senderVC a referance to the current event that need to be sent
        SelectFreindsVC.currentEvent = self.currentEvent;
        
        NSLog(@"%@",SelectFreindsVC.currentEvent.eventTitle);
        
    }
    
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


-(void)BackButtonPressed{
    [self.JCGigMoreInfoVCDelegate JCGigMoreInfoVCDidSelectDone:self];
}










@end
