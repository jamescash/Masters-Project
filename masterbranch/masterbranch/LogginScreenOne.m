//
//  LogginScreenOne.m
//  PreAmp
//
//  Created by james cash on 13/11/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "LogginScreenOne.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Google/Analytics.h>
#import "GAI.h"
#import "JCTutorialPageViewController.h"



@interface LogginScreenOne ()
@property (weak, nonatomic) IBOutlet UIImageView *UIimageBackground;
@property (nonatomic, strong) NSArray* descStrings;
@property (nonatomic, strong) UILabel* welcomeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *UIImageLoginLogo;

@end

@implementation LogginScreenOne

- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenName = @"Loggin Screen One";

    self.UIImageLoginLogo.image = [UIImage imageNamed:@"LogoPreAmp"];
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
    
    
    //Track Facebook Loggin Button clicks
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"       // Event category (required)
                                                          action:@"button_press"    // Event action (required)
                                                           label:@"signup_Facebook" // Event label
                                                           value:nil] build]];      // Event value
    
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
- (IBAction)UIButtonRegisterWithFacebook:(id)sender {
    
    
    //Track Facebook Loggin Button clicks
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"       // Event category (required)
                                                          action:@"button_press"    // Event action (required)
                                                           label:@"Signup_Email" // Event label
                                                           value:nil] build]];      // Event value
}
- (IBAction)UIButtonLoggin:(id)sender {
    
    //Track Button clicks
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"       // Event category (required)
                                                          action:@"button_press"    // Event action (required)
                                                           label:@"loggin" // Event label
                                                           value:nil] build]];      // Event value
}





@end
