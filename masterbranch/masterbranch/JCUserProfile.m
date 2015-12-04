//
//  JCUserProfile.m
//  PreAmp
//
//  Created by james cash on 20/11/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCUserProfile.h"
#import "RKSwipeBetweenViewControllers.h"
#import "RESideMenu.h"
#import "HeaderViewWithImage.h"
#import "HeaderView.h"
#import "JCConstants.h"
#import "JCUserProfileHeaderView.h"
#import "JCParseQuerys.h"
#import <Parse/Parse.h>

@interface JCUserProfile ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) CAGradientLayer *vignetteLayer;
@property (nonatomic,strong) JCParseQuerys *JCParseQuerys;

@end

@implementation JCUserProfile

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customiseNavBar];
    [self layouStickyHeaderView];
    self.tableView.allowsSelection = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.tableView shouldPositionParallaxHeader];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
 
    return 1;

}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

 UITableViewCell *profileButtons = [tableView dequeueReusableCellWithIdentifier:@"profileButtons"forIndexPath:indexPath];
 

    return profileButtons;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 230;
}


- (IBAction)logOutButton:(id)sender {
    [self UserSelectedLogOut];
}

-(void)UserSelectedLogOut{
    
    [self.JCParseQuerys getMyFriends:^(NSError *error, NSArray *response) {
        [PFObject unpinAllInBackground:response];
    }];
    
    [self.JCParseQuerys getMyAtrits:^(NSError *error, NSArray *response) {
        [PFObject unpinAllInBackground:response];
    }];
    [PFObject unpinAllObjectsInBackgroundWithName:@"MyArtist"];
    [PFObject unpinAllObjectsInBackgroundWithName:@"MyFriends"];
    [PFUser logOut];
    [self performSegueWithIdentifier:@"showLoginPage" sender:self];
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"HomeScreenCollectionView"]]
                                                 animated:YES];
    [self.sideMenuViewController hideMenuViewController];
    
}

- (void)customiseNavBar
{
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage im];
    //imageView.alpha = 0.5; //Alpha runs from 0.0 to 1.0
    
    [menuButton setImage:[UIImage imageNamed:@"iconMenu.png"] forState:UIControlStateNormal];
    //[menuButton setImage:[UIImage imageNamed:@"iconMenu.png"] forState:UIControlStateHighlighted];
    menuButton.adjustsImageWhenDisabled = NO;
    //set the frame of the button to the size of the image (see note below)
    menuButton.frame = CGRectMake(0, 0, 40, 40);
    menuButton.opaque = YES;
    [menuButton addTarget:self action:@selector(BackButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    //create a UIBarButtonItem with the button as a custom view
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    
    self.navigationItem.leftBarButtonItem = customBarItem;
    
    self.navigationItem.hidesBackButton = YES;
    
    
}
-(void)BackButtonPressed{
    [self.sideMenuViewController presentLeftMenuViewController];
}

-(void)layouStickyHeaderView{
    JCUserProfileHeaderView *headerView = [JCUserProfileHeaderView instantiateFromNib];
    headerView.BGImage.file = [[PFUser currentUser]objectForKey:JCUserProfilePicture];
    headerView.BGImage.contentMode = UIViewContentModeScaleAspectFill;
    [headerView.BGImage loadInBackground];
    headerView.ProfileImage.file = [[PFUser currentUser]objectForKey:JCUserProfilePicture];
    headerView.ProfileImage.contentMode = UIViewContentModeScaleAspectFill;
    headerView.ProfileImage = [self addLayerMaskToImageView:headerView.ProfileImage withConorRadious:50];
    [headerView.ProfileImage loadInBackground];
    headerView.blurView.alpha = .8;
    headerView.UILableUserName.text = [[PFUser currentUser]objectForKey:JCUserRealName];
    headerView.UILableUserParseName.text = [[PFUser currentUser]objectForKey:JCUserUserName];
    [self.tableView setParallaxHeaderView:headerView
                                       mode:VGParallaxHeaderModeFill
                                     height:200];
}

-(PFImageView*)addLayerMaskToImageView:(PFImageView*)imageView withConorRadious: (int) conorRadious {
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(conorRadious,conorRadious)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height);
    maskLayer.path = maskPath.CGPath;
    imageView.layer.mask = maskLayer;
    return imageView;
}

@end
