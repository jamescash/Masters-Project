//
//  JCloginVC.m
//  masterbranch
//
//  Created by james cash on 08/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "JCloginVC.h"
#import "JChomeScreenVC.h"
#import "AppDelegate.h"




@interface JCloginVC ()

@property(nonatomic,strong) PFLogInViewController *logInViewController;

@end

@implementation JCloginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    

        
       [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:nil];
       [PFTwitterUtils initializeWithConsumerKey:@"8eEctMqLZ8QScpfLDZRVT5ZTq" consumerSecret:@"s7lK6v39rxaAvPagEjs7breEsvDJzwRFdqLaVQASBEg8JeOOGk"];
        
        self.logInViewController = [[PFLogInViewController alloc] init];
        [self.logInViewController setDelegate:self]; // Set ourselves as the delegate
        [self.logInViewController setFacebookPermissions:@[ @"user_about_me", @"user_birthday", @"user_location"]];
        [self.logInViewController setFields:PFLogInFieldsUsernameAndPassword | PFLogInFieldsSignUpButton | PFLogInFieldsPasswordForgotten | PFLogInFieldsLogInButton |PFLogInFieldsFacebook |PFLogInFieldsTwitter];
    
        
        // Create the sign up view controller
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        

        
        // Assign our sign up controller to be displayed from the login controller
        [self.logInViewController setSignUpController:signUpViewController];
    
    
        [self presentViewController:self.logInViewController animated:YES completion:NULL];
        
        

    
}




-(void)logInViewController:(PFLogInViewController * __nonnull)logInController didLogInUser:(PFUser * __nonnull)user{
   
    

    AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
    
    appDelegateTemp.window.rootViewController =  [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"HomeScreen"];

}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    
//    if ([segue.identifier isEqualToString:@"ShowHomeScreen"])
//    {
//    
//        
//        JChomeScreenVC *jc = [segue destinationViewController];
//        
//    }
//}


@end
