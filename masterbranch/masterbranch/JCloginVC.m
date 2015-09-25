//
//  JCloginVC.m
//  masterbranch
//
//  Created by james cash on 08/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "JCloginVC.h"
#import "AppDelegate.h"
#import "JCSignUp.h"





@interface JCloginVC ()
//@property(nonatomic,strong) PFLogInViewController *logInViewController;

@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

//methods
- (IBAction)login:(id)sender;


@end

@implementation JCloginVC

- (void)viewDidLoad {
    [super viewDidLoad];
  
    

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
    
NSString *userName = [self.userNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    if ([userName length] == 0 || [password length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Please enter a vaild username & password!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    }else{
        
        [PFUser logInWithUsernameInBackground:userName password:password block:^(PFUser * _Nullable user, NSError * _Nullable error) {
            
       
            if (error) {
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Gerr okay" otherButtonTitles:nil];
                [alert show];
            }else{
                
                NSLog(@"Logged in");
                [self dismissViewControllerAnimated:YES completion:nil];
                
            
            }
        
        
        }];
        
        
        
    }
    
    
    
}





//-(void)logInViewController:(PFLogInViewController * __nonnull)logInController didLogInUser:(PFUser * __nonnull)user{
//       
//    [self dismissViewControllerAnimated:YES completion:nil];
//}





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
