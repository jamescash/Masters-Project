//
//  JCMainViewController.m
//  
//
//  Created by james cash on 22/08/2015.
//
//

#import "JCMainViewController.h"
#import "JCleftSlideOutVC.h"
//so we can acsess the count of friends
#import "JCProfilePage.h"
#import "JCParseQuerys.h"



@interface JCMainViewController ()
@property (nonatomic,strong) PFRelation *FriendRelations;
@property (nonatomic,strong) PFRelation *artistRelations;

@property (nonatomic,strong) JCParseQuerys *ParseQuerys;



@end

@implementation JCMainViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.ParseQuerys = [JCParseQuerys sharedInstance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)awakeFromNib
{
    self.menuPreferredStatusBarStyle = UIStatusBarStyleLightContent;
    self.contentViewShadowColor = [UIColor blackColor];
    self.contentViewShadowOffset = CGSizeMake(0, 0);
    self.contentViewShadowOpacity = 0.6;
    self.contentViewShadowRadius = 12;
    self.contentViewShadowEnabled = YES;
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentViewController"];
    self.leftMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftMenuViewController"];
    //self.rightMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"rightMenuViewController"];
    self.backgroundImage = [UIImage imageNamed:@"SlidOutMenuBackGroung"];
    self.delegate = self;
}

#pragma mark RESideMenu Delegate

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(JCleftSlideOutVC *)menuViewController
{
    PFUser *currentUser = [PFUser currentUser];
    PFFile *imageFile = currentUser[@"profilePicture"];
    menuViewController.userName.text = currentUser.username;

    //get friends count
    self.FriendRelations = [[PFUser currentUser] objectForKey:@"FriendsRelation"];
    PFQuery *query  = [self.FriendRelations query];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"Error: %@ %@", error, [error localizedDescription]);
        }
        
        menuViewController.numberOfFriends.text = [NSString stringWithFormat:@"%d",[objects count]];
        
    }];
    
    
    //get profile picture
    [imageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error && imageData){
          menuViewController.profilePicture.image = [UIImage imageWithData:imageData];
        
        }else{
            
            NSLog(@"Error: %@ %@", error, [error localizedDescription]);
        }
    
     }];
    
//    //get artist count
//    self.artistRelations = [[PFUser currentUser] objectForKey:@"ArtistRelation"];
//    PFQuery *artistquery  = [self.artistRelations query];
//    [artistquery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
//        
//        if (error) {
//            NSLog(@"Error: %@ %@", error, [error localizedDescription]);
//        }
//        
//        menuViewController.numberOfArtistFollowing.text = [NSString stringWithFormat:@"%d",[objects count]];
//        
//    }];
    
    [self.ParseQuerys getMyAtrits:^(NSError *error, NSArray *response) {
        
    NSLog(@"got artist");
        
    menuViewController.numberOfArtistFollowing.text = [NSString stringWithFormat:@"%d",[response count]];

    }];
    

}



- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{
    //NSLog(@"didShowMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{
   // NSLog(@"willHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}

- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{
   // NSLog(@"didHideMenuViewController: %@", NSStringFromClass([menuViewController class]));
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)getMyFriendscount{
    
   
    
}

@end
