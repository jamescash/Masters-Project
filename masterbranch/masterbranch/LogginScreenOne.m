//
//  LogginScreenOne.m
//  PreAmp
//
//  Created by james cash on 13/11/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "LogginScreenOne.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>


static NSString * const tutDiscriptionPagg1 = @"Welcome to Preamp, Browse our homescreen to find gig's happening around you";

static NSString * const tutDiscriptionPagg2 = @"Found one you like? Ask all your friends to come along";

static NSString * const tutDiscriptionPagg3 = @"Instantly collaborate and find out who is interested in going";

static NSString * const tutDiscriptionPagg4 = @"Follow your favourite artists an create a gig diary from all their upcoming Irish gig's";

@interface LogginScreenOne ()
@property (weak, nonatomic) IBOutlet UIImageView *UIimageBackground;
@property (nonatomic, strong) NSArray* descStrings;
@property (nonatomic, strong) UILabel* welcomeLabel;

@property (nonatomic,strong) GHWalkThroughView *tutorialView;
@end

@implementation LogginScreenOne

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.UIimageBackground = [self addVinettLayerToBackGroundToImage:self.UIimageBackground];

    self.UIimageBackground.image = [UIImage imageNamed:@"backgroundLogin"];
    self.UIimageBackground.contentMode = UIViewContentModeScaleAspectFill;
    self.descStrings = [NSArray arrayWithObjects:tutDiscriptionPagg1,tutDiscriptionPagg2, tutDiscriptionPagg3, tutDiscriptionPagg4, nil];

    CGRect frame = self.view.frame;
    frame.size.height = self.view.frame.size.height - 130;
    
    self.tutorialView = [[GHWalkThroughView alloc] initWithFrame:frame];
    [self.tutorialView setDataSource:self];
     self.tutorialView.backgroundColor = [UIColor clearColor];
    [self.tutorialView setWalkThroughDirection:GHWalkThroughViewDirectionHorizontal];
//    UILabel* welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
//    welcomeLabel.text = @"Welcome";
//    welcomeLabel.font = [UIFont fontWithName:@"HelveticaNeue-light" size:30];
//    welcomeLabel.textColor = [UIColor whiteColor];
//    welcomeLabel.textAlignment = NSTextAlignmentCenter;
//    self.welcomeLabel = welcomeLabel;
    [self.tutorialView setFloatingHeaderView:self.welcomeLabel];
    [self.tutorialView showInView:self.view animateDuration:.03];
    //[self.view addSubview:ghView];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([PFUser currentUser]) {
        [self dismissViewControllerAnimated:NO completion:nil];
        
    };
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIImageView*)addVinettLayerToBackGroundToImage:(UIImageView*)imageView{
    CAGradientLayer *vignetteLayer = [CAGradientLayer layer];
    [vignetteLayer setBounds:[imageView bounds]];
    [vignetteLayer setPosition:CGPointMake([imageView bounds].size.width/2.0f, [imageView bounds].size.height/2.0f)];
    UIColor *lighterBlack = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.3];
    [vignetteLayer setColors:@[(id)[[UIColor clearColor] CGColor], (id)[lighterBlack CGColor]]];
    [vignetteLayer setLocations:@[@(.20), @(1.0)]];
    [[imageView layer] addSublayer:vignetteLayer];
    return imageView;
}
- (IBAction)buttonFacebookLoggin:(id)sender {
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[ @"user_about_me",@"user_friends"];
    
    //Login PFUser using Facebook
    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        if (!user) {
            //TODO add alert here saying pleease try that againg something went wrong
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            //New user signed up and logged in through Facebook
            [self saveUserIdToNewInstalation];
            [self performSegueWithIdentifier:@"JCFBAddUserName" sender:self];
            
            
            
        } else {
            NSLog(@"User logged in through Facebook!");
            [self saveUserIdToNewInstalation];
            [self dismissViewControllerAnimated:YES completion:nil];
            
            
        }
    }];

    
}
-(void)saveUserIdToNewInstalation{
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    currentInstallation[@"installationUser"] = [[PFUser currentUser]objectId];
    [currentInstallation saveInBackground];
    NSLog(@"instalation saved");
    
    
}

#pragma - Tutorial Data source

-(NSInteger) numberOfPages
{
    return 4;
}

- (void) configurePage:(GHWalkThroughPageCell *)cell atIndex:(NSInteger)index
{

    cell.title = [NSString stringWithFormat:@"Welcome to Preamp"];
    //cell.titleImage = [UIImage imageNamed:[NSString stringWithFormat:@"title%ld", index+1]];
    cell.titleFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    cell.titleImage = [UIImage imageNamed:[NSString stringWithFormat:@"tutorialScreen%ld",index+1]];
    cell.imgPositionY = -380;
    cell.titlePositionY = 405;
    cell.descPositionY = 390;
    cell.desc = [self.descStrings objectAtIndex:index];
}

- (UIImage*) bgImageforPage:(NSInteger)index
{
    UIImage* image = [UIImage imageNamed:@"bgimage"];
    return image;
}

@end
