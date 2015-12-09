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
    [self setNeedsStatusBarAppearanceUpdate];
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
    self.backgroundImage = [UIImage imageNamed:@"backgroundLogin"];
    self.parallaxEnabled = NO;
    self.scaleContentView = NO;
    self.scaleMenuView = NO;
    self.bouncesHorizontally = YES;
    self.animationDuration = .27f;
    //self.menuViewControllerTransformation = CGAffineTransformMakeScale(3.0f, 3.0f);
    //self.view.backgroundColor = [UIColor blackColor];
    //self.scaleBackgroundImageView = NO;
    //self.panMinimumOpenThreshold = 10.0;
    self.delegate = self;
}

#pragma mark RESideMenu Delegate

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(JCleftSlideOutVC *)menuViewController
{
    PFUser *currentUser = [PFUser currentUser];
    PFFile *imageFile = currentUser[@"profilePicture"];
    menuViewController.userName.text = currentUser.username;

    
    [self.ParseQuerys getMyFriends:^(NSError *error, NSArray *response) {
        if (error) {
            NSLog(@"Error: %@ %@", error, [error localizedDescription]);
        }
        
        menuViewController.numberOfFriends.text = [NSString stringWithFormat:@"%u",[response count]];
        
    }];

    //get profile picture
    [imageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error && imageData){
         
        menuViewController.profilePicture.image = [UIImage imageWithData:imageData];
            menuViewController.profilePicture = [self addLayerMaskToImageView:menuViewController.profilePicture];
            menuViewController.profilePicture.contentMode = UIViewContentModeScaleAspectFill;
            
//        menuViewController.profilePicture.layer.cornerRadius = menuViewController.profilePicture.frame.size.height /2;
//        menuViewController.profilePicture.layer.masksToBounds = YES;
//        menuViewController.profilePicture.layer.borderWidth = 0;
        
        }else{
            NSLog(@"Error: %@ %@", error, [error localizedDescription]);
        }
    
     }];
    

    [self.ParseQuerys getMyAtrits:^(NSError *error, NSArray *response) {
        menuViewController.numberOfArtistFollowing.text = [NSString stringWithFormat:@"%lu",(unsigned long)[response count]];
     
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

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

-(UIImageView*)addLayerMaskToImageView:(UIImageView*)imageView{
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(0, 0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height);
    maskLayer.path = maskPath.CGPath;
    imageView.layer.mask = maskLayer;
    return imageView;
}

@end
