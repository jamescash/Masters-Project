//
//  JCloginVC.m
//  masterbranch
//
//  Created by james cash on 08/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "JCloginVC.h"
#import "JChomeScreenVC.h"



@interface JCloginVC ()

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
    
    
  
  if (![PFUser currentUser]) { // No user logged in
        
        // Create the log in view controller
        
       [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:nil];
       [PFTwitterUtils initializeWithConsumerKey:@"8eEctMqLZ8QScpfLDZRVT5ZTq" consumerSecret:@"s7lK6v39rxaAvPagEjs7breEsvDJzwRFdqLaVQASBEg8JeOOGk"];
        
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        
        [logInViewController setFacebookPermissions:@[ @"user_about_me", @"user_birthday", @"user_location"]];
        
        
        [logInViewController setFields:PFLogInFieldsUsernameAndPassword | PFLogInFieldsSignUpButton | PFLogInFieldsPasswordForgotten | PFLogInFieldsLogInButton |PFLogInFieldsFacebook |PFLogInFieldsTwitter];
    
        
        // Create the sign up view controller
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        

        
        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];
    
       //[self addChildViewController:logInViewController];
    
         [self presentViewController:logInViewController animated:YES completion:NULL];
        
        
   }else{
        
//       UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Logged in" message:@"You are logged in" delegate:nil cancelButtonTitle:@"Log me out" otherButtonTitles:nil, nil];
//       
//       [alert show];
      // [PFUser logOut];
       
       [self performSegueWithIdentifier:@"ShowHomeScreen" sender:nil];
      [PFUser logOut];


   }
    
    
}

-(void)logInViewController:(PFLogInViewController * __nonnull)logInController didLogInUser:(PFUser * __nonnull)user{
   
    
    
     NSLog(@"preforming segue");

    [self performSegueWithIdentifier:@"ShowHomeScreen" sender:nil];


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
