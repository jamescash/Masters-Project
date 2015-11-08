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
#import "JCMyArtistCell.h"
#import "JCMyFriendsCell.h"
#import "JCAddMyFriendsVC.h"
#import "JCConstants.h"

#import <TLYShyNavBar/TLYShyNavBarManager.h>
#import "RESideMenu.h"





@interface JCMyFiriendsMyArtistVC () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *tableViewDataSource;
@property (nonatomic,strong) JCParseQuerys *JCParseQuerys;
@property (nonatomic,strong) NSMutableArray *imageFiles;
@property (nonatomic,strong) NSArray *MyFireds;


@end

@implementation JCMyFiriendsMyArtistVC{
    NSString *firendskey;
    NSString *artistkey;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.imageFiles = [[NSMutableArray alloc]init];
    self.tableView.allowsSelection = NO;
    self.JCParseQuerys = [JCParseQuerys sharedInstance];
}


- (void) viewWillAppear:(BOOL)animated{
    firendskey = @"friends";
    artistkey =@"artist";
    
    
    if ([self.tableViewType isEqualToString:JCAddMyFriendsMyArtistTypeFriends]) {
        [self addNavBarForMyFriendsMyAritst];

        [self setupNavBarForScreen:self.tableViewType];
         self.navigationItem.title = @"My Friends";
        [self.JCParseQuerys getMyFriends:^(NSError *error, NSArray *response) {
            
            self.tableViewDataSource = response;
            self.MyFireds = response;


            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                 });
         }];
    }else if ([self.tableViewType isEqualToString:JCAddMyFriendsMyArtistTypeArtist]){
         self.navigationItem.title = @"My artist";
        [self addNavBarForMyFriendsMyAritst];

        [self.JCParseQuerys getMyAtrits:^(NSError *error, NSArray *response) {
            
            self.tableViewDataSource = response;
            for (PFObject *artist in response) {
                 PFFile *imageFile = [artist objectForKey:@"thmbnailAtistImage"];
                [self.imageFiles addObject:[@{@"pfFile":imageFile} mutableCopy]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                 [self.tableView reloadData];
            });
         }];
    }else if ([self.tableViewType isEqualToString:JCUserEventUserGoing]){
        
        [self addcontentOffsetForPageView];
        
        [self.JCParseQuerys getUserGoingToEvent:self.currentUserEvent forEventStatus:JCUserEventUserGoing completionBlock:^(NSError *error, NSArray *userGoing) {
            self.tableViewDataSource = userGoing;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
        }];
        
    }else if ([self.tableViewType isEqualToString:JCUserEventUserGotTickets]){
        
        [self addcontentOffsetForPageView];

        [self.JCParseQuerys getUserGoingToEvent:self.currentUserEvent forEventStatus:JCUserEventUserGotTickets completionBlock:^(NSError *error, NSArray *userGoing) {
            self.tableViewDataSource = userGoing;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
        }];
       
        
    }else if ([self.tableViewType isEqualToString:JCUserEventUserMaybeGoing]){
        
        [self addcontentOffsetForPageView];
        
        [self.JCParseQuerys getUserGoingToEvent:self.currentUserEvent forEventStatus:JCUserEventUserMaybeGoing completionBlock:^(NSError *error, NSArray *userGoing) {
            self.tableViewDataSource = userGoing;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
        }];
        
        
    }else if ([self.tableViewType isEqualToString:JCUserEventUsersEventInvited]){
        
        [self addcontentOffsetForPageView];
        
        [self.JCParseQuerys getUserGoingToEvent:self.currentUserEvent forEventStatus:JCUserEventUsersEventInvited completionBlock:^(NSError *error, NSArray *userGoing) {
            self.tableViewDataSource = userGoing;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
        }];
        
        
    }
    
    
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.tableViewType isEqualToString:JCAddMyFriendsMyArtistTypeFriends]||[self.tableViewType isEqualToString:JCUserEventUserGoing]||[self.tableViewType isEqualToString:JCUserEventUsersEventInvited]||[self.tableViewType isEqualToString:JCUserEventUserMaybeGoing]||[self.tableViewType isEqualToString:JCUserEventUserGotTickets]){
    
        JCMyFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendsCell" forIndexPath:indexPath];
    
        
        PFUser *user =[self.tableViewDataSource objectAtIndex:indexPath.row];
        [cell formateCell:user];
        PFFile *profilePic = [user objectForKey:@"thumbnailProfilePicture"];
        cell.userImage.file = profilePic;
        
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

        
        [cell.userImage loadInBackground];
       
        return cell;
      }else if ([self.tableViewType isEqualToString:JCAddMyFriendsMyArtistTypeArtist]){
    
    JCMyArtistCell *cell = [tableView dequeueReusableCellWithIdentifier:@"artistCell" forIndexPath:indexPath];
    [cell formatCell:[self.tableViewDataSource objectAtIndex:indexPath.row]];
        UIImage *artistImage = self.imageFiles[indexPath.row][@"image"];

  
        if (artistImage) {
            cell.artistImage.image = artistImage;
            cell.artistImage.contentMode = UIViewContentModeScaleToFill;
        }else {
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
            
            [self DownloadImageForeventAtIndex:indexPath completion:^(UIImage* image, NSError* error) {
                if (!error) {
                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
                
            }];
        }
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

-(void)DownloadImageForeventAtIndex:(NSIndexPath *)indexPath completion:(void (^)( UIImage *,NSError*)) completion {
    
    // if we fetched already, just return it via the completion block
    UIImage *existingImage = self.imageFiles[indexPath.row][@"image"];
    
    if (existingImage){
        completion(existingImage, nil);
    }
    
    PFFile *pfFile = self.imageFiles[indexPath.row][@"pfFile"];
    
    if (!pfFile) {
      UIImage *eventImage = [UIImage imageNamed:@"loadingYellow.png"];
        completion(eventImage, nil);
    }
    
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

#pragma - HelperMethods


- (void)setupNavBarForScreen:(NSString*)screenType
{
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton setImage:[UIImage imageNamed:@"iconSearch.png"] forState:UIControlStateNormal];
    [searchButton setImage:[UIImage imageNamed:@"iconSearch.png"] forState:UIControlStateHighlighted];
    searchButton.adjustsImageWhenDisabled = NO;
    searchButton.frame = CGRectMake(0, self.tableView.frame.size.width-40 , 40, 40);
    
    [searchButton addTarget:self action:@selector(serchbuttonPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *searchbarbutton = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    self.navigationItem.rightBarButtonItem = searchbarbutton;
    //self.navigationItem.hidesBackButton = YES;
    //self.navigationItem.leftBarButtonItem =item1;
}

-(void)serchbuttonPressed{
    [self performSegueWithIdentifier:@"addFriends" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"addFriends"]){
        //Pass list of friends to add freinds VC so it knows who's alrealdy your friends3
        JCAddMyFriendsVC *addfirendsPage = (JCAddMyFriendsVC*)segue.destinationViewController;
        addfirendsPage.myFriends = [NSMutableArray arrayWithArray:self.MyFireds];
    }
};


- (void)addNavBarForMyFriendsMyAritst
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage im];
    //imageView.alpha = 0.5; //Alpha runs from 0.0 to 1.0
    
    [backButton setImage:[UIImage imageNamed:@"iconMenu.png"] forState:UIControlStateNormal];
    backButton.adjustsImageWhenDisabled = NO;
    //set the frame of the button to the size of the image (see note below)
    backButton.frame = CGRectMake(0, 0, 40, 40);
    backButton.opaque = YES;
    
    [backButton addTarget:self action:@selector(BackButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    //create a UIBarButtonItem with the button as a custom view
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.navigationItem.leftBarButtonItem = customBarItem;
    
    self.shyNavBarManager.scrollView = self.tableView;
    
}
- (void)addcontentOffsetForPageView
{
    
    
    [self.tableView setContentInset:UIEdgeInsetsMake(80,0,0,0)];


    
}

-(void)BackButtonPressed{
    [self.sideMenuViewController presentLeftMenuViewController];

}


@end
