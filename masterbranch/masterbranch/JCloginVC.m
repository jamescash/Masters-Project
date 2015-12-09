//
//  JCloginVC.m
//  masterbranch
//
//  Created by james cash on 08/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "JCloginVC.h"
#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "UIImage+Resize.h"
#import "IHKeyboardAvoiding.h"





@interface JCloginVC ()
//@property(nonatomic,strong) PFLogInViewController *logInViewController;
@property (weak, nonatomic) IBOutlet UIImageView *UIImagePreAmpLogo;

@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

//methods
- (IBAction)login:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewBackGround;

@property (weak, nonatomic) IBOutlet UIView *UiViewKeyboardAvoiding;

@end

@implementation JCloginVC{
   // UITapGestureRecognizer *tapRecognizer;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [IHKeyboardAvoiding setAvoidingView:(UIView *)self.UiViewKeyboardAvoiding];
    self.UIImagePreAmpLogo.image = [UIImage imageNamed:@"welcomeScreen"];
    self.UIImagePreAmpLogo.contentMode = UIViewContentModeScaleAspectFill;
    //self.imageViewBackGround = [self addVinettLayerToBackGroundToImage:self.imageViewBackGround];
    self.imageViewBackGround.image = [UIImage imageNamed:@"backgroundLogin"];
    self.imageViewBackGround.contentMode = UIViewContentModeScaleAspectFill;
}

-(void)UserSignedUp{
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
}

- (IBAction)login:(id)sender {
    
    //TODO resign first responder for testfields in login view controller
    
    NSString *userName = [self.userNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    if ([userName length] == 0 || [password length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Please enter a vaild username & password" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    }else{
        
        [PFUser logInWithUsernameInBackground:userName password:password block:^(PFUser * _Nullable user, NSError * _Nullable error) {
            
       
            if (error) {
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Please enter a vaild username & password" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alert show];
            }else{
                
                 NSLog(@"Logged in");
                //UNWind segue to homescreen 
                [self dismissViewControllerAnimated:YES completion:nil];
               }
            }];
     }





}
- (IBAction)dissmissbutton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.userNameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

//- (IBAction)logginWithFaceBook:(id)sender {
//    // Set permissions required from the facebook user account
//    NSArray *permissionsArray = @[ @"user_about_me",@"user_friends"];
//    
//     //Login PFUser using Facebook
//    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
//        if (!user) {
//            //TODO add alert here saying pleease try that againg something went wrong
//            NSLog(@"Uh oh. The user cancelled the Facebook login.");
//        } else if (user.isNew) {
//            //New user signed up and logged in through Facebook
//            //[self saveUserIdToNewInstalation];
//            [self performSegueWithIdentifier:@"JCFBAddUserName" sender:self];
//
//            
//
//        } else {
//            NSLog(@"User logged in through Facebook!");
//            [self saveUserIdToNewInstalation];
//
//            [self dismissViewControllerAnimated:YES completion:nil];
//
//
//        }
//    }];
//    
//}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"showSignUp"]) {
        JCSignUp *DVC = segue.destinationViewController;
        DVC.JCSignUpVCDelegat = self;
    }
    
}

-(void)saveUserIdToNewInstalation{

    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    currentInstallation[@"installationUser"] = [[PFUser currentUser]objectId];
    [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"intalation error %@",error);
        }else{
            NSLog(@"intaltion sucess %@",currentInstallation);
        }
        
    }];

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



//    self.logInViewController = [[PFLogInViewController alloc]init];
//
//    [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:nil];
//    [PFTwitterUtils initializeWithConsumerKey:@"8eEctMqLZ8QScpfLDZRVT5ZTq" consumerSecret:@"s7lK6v39rxaAvPagEjs7breEsvDJzwRFdqLaVQASBEg8JeOOGk"];
//
//    //UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PreAmp.png"]];
//    //self.logInViewController.logInView.logo = imageView;
//    [self.logInViewController setDelegate:self]; // Set ourselves as the delegate
//    //[self.logInViewController setFacebookPermissions:@[ @"user_about_me",@"email",@"user_friends"]];
//    //[self.logInViewController setFields:PFLogInFieldsUsernameAndPassword | PFLogInFieldsSignUpButton | PFLogInFieldsPasswordForgotten | PFLogInFieldsLogInButton |PFLogInFieldsTwitter|PFLogInFieldsFacebook];
//    [self.logInViewController setFields:PFLogInFieldsUsernameAndPassword | PFLogInFieldsSignUpButton | PFLogInFieldsPasswordForgotten | PFLogInFieldsLogInButton ];
//
//    // Create the sign up view controller
//    JCSignUp *signUpViewController = [[JCSignUp alloc] init];
//    //[signUpViewController setDelegate:self]; // Set ourselves as the delegate
//
//    //Assign our sign up controller to be displayed from the login controller
//    //[self.logInViewController setSignUpController:signUpViewController];
//
//
////    PFUser *currentUser = [PFUser currentUser];
////
////        if (currentUser == nil) {
////
////            [self presentViewController:self.logInViewController animated:YES completion:NULL];
////
////        }else{
////
////            [self dismissViewControllerAnimated:YES completion:nil];
////
////        }
//





@end
