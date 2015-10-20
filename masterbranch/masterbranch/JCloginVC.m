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
    
    //TODO resign first responder for testfields in login view controller
    
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
                //[self saveUserIdToNewInstalation];
                [self dismissViewControllerAnimated:YES completion:nil];
               }
            }];
     }
}

- (IBAction)logginWithFaceBook:(id)sender {
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[ @"user_about_me", @"user_birthday"];
    
     //Login PFUser using Facebook
    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            NSLog(@"New user signed up and logged in through Facebook!");
            [self dismissViewControllerAnimated:YES completion:nil];
            [self saveUserIdToNewInstalation];
            [self getUsersFacebookData];

        } else {
            NSLog(@"User logged in through Facebook!");
            
            [self dismissViewControllerAnimated:YES completion:nil];
//
//            [self saveInstalation];
//            [self getUsersFacebookData];

        }
    }];
    
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"showSignUp"]) {
        JCSignUp *DVC = segue.destinationViewController;
        DVC.JCSignUpVCDelegat = self;
    }
    
}


-(void)getUsersFacebookData{
    
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {


        
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *facebookID = userData[@"id"];
            NSString *name = userData[@"name"];
            //NSString *location = userData[@"location"][@"name"];
            //NSString *gender = userData[@"gender"];
            //NSString *birthday = userData[@"birthday"];
            //NSString *relationship = userData[@"relationship_status"];
            
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            
            
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:pictureURL];

            [NSURLConnection sendAsynchronousRequest:urlRequest
                                               queue:[NSOperationQueue mainQueue]
                                   completionHandler:
             ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                 

                 if (connectionError == nil && data != nil) {
                     

                     
                     UIImage *userprofileImage = [UIImage imageWithData:data];
                     
                     NSData *fileData;
                     NSString *fileName;
                     NSString *fileType;
                     
                     fileData = UIImagePNGRepresentation(userprofileImage);
                     fileName = @"profilImage.png";
                     fileType = @"image";
                     
                     PFFile *profilePicture = [PFFile fileWithName:fileName data:fileData];

                     [profilePicture saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                         

                         
                         if (error) {
                             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error :(" message:@"Couldnt save your profile picture" delegate:self cancelButtonTitle:@"okay" otherButtonTitles:nil];
                             [alert show];
                         }else{
                             
                             NSData *fileData;
                             NSString *fileName;
                             
                             //resize the image and save a thumbnail
                             //CGFloat originalWidth =  userprofileImage.size.width;
                             //CGFloat originalHeight = userprofileImage.size.height;
                             CGSize size = {150, 150};
                             UIImage *thumbProfilePicture = [userprofileImage resizedImageToFitInSize:size scaleIfSmaller:YES];
                             
                             fileData = UIImagePNGRepresentation(thumbProfilePicture);
                             fileName = @"thumbProfilePicture.png";
                             
                             PFFile *thumbnailProfilePicture = [PFFile fileWithName:fileName data:fileData];
                             
                             [thumbnailProfilePicture saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                                 
                                 if (error) {
                                     UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error :(" message:@"Couldnt save your profile picture" delegate:self cancelButtonTitle:@"okay" otherButtonTitles:nil];
                                     [alert show];
                                 }else{
                                     
                                     [[PFUser currentUser] setObject:name forKey:@"username"];
                                     [[PFUser currentUser] setObject:profilePicture forKey:@"profilePicture"];
                                     [[PFUser currentUser] setObject:thumbnailProfilePicture forKey:@"thumbnailProfilePicture"];
                                      NSLog(@"should saved thubnail");
                                     [[PFUser currentUser] saveInBackground];
                                 }
                             
                             }];
                            }
                     
                      }];
                     
                 }else{
                     NSLog(@"Facebook profile image download error %@",error);

                 }
             
             }];
        }else{
            NSLog(@"Facebook error %@",error);
        }
        
    }];
    
    
}

-(void)saveUserIdToNewInstalation{

    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    currentInstallation[@"installationUser"] = [[PFUser currentUser]objectId];
    [currentInstallation saveInBackground];

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
