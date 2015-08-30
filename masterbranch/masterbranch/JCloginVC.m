//
//  JCloginVC.m
//  masterbranch
//
//  Created by james cash on 08/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "JCloginVC.h"
#import "AppDelegate.h"




@interface JCloginVC ()

@property(nonatomic,strong) PFLogInViewController *logInViewController;

@end

@implementation JCloginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
     JCleftSlideOutVC *leftSlideOut = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"leftMenuViewController"];
    leftSlideOut.JCleftSlideOutVCDelegat = self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    

        
       [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:nil];
       [PFTwitterUtils initializeWithConsumerKey:@"8eEctMqLZ8QScpfLDZRVT5ZTq" consumerSecret:@"s7lK6v39rxaAvPagEjs7breEsvDJzwRFdqLaVQASBEg8JeOOGk"];
        
    
    //[PFFacebookUtils initializeFacebook];
    
    self.logInViewController = [[PFLogInViewController alloc] init];
    
        //UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PreAmp.png"]];
        //self.logInViewController.logInView.logo = imageView;
    
         [self.logInViewController setDelegate:self]; // Set ourselves as the delegate
    
        [self.logInViewController setFacebookPermissions:@[ @"user_about_me", @"user_birthday", @"user_location"]];
    
        [self.logInViewController setFields:PFLogInFieldsUsernameAndPassword | PFLogInFieldsSignUpButton | PFLogInFieldsPasswordForgotten | PFLogInFieldsLogInButton |PFLogInFieldsFacebook |PFLogInFieldsTwitter|PFLogInFieldsDismissButton];
    
        
        // Create the sign up view controller
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
    
         [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        //signUpViewController.signUpView.logo = imageView;

    
        // Assign our sign up controller to be displayed from the login controller
        [self.logInViewController setSignUpController:signUpViewController];
    
         //self.view = self.logInViewController.view;
    
        [self presentViewController:self.logInViewController animated:YES completion:NULL];
        
}




-(void)logInViewController:(PFLogInViewController * __nonnull)logInController didLogInUser:(PFUser * __nonnull)user{
   
//
    NSLog(@"User logged in");
   
    AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
    
    
    appDelegateTemp.window.rootViewController =  [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"JCMainViewController"];
 

}






@end
