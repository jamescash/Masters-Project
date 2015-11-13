//
//  LogginScreenOne.m
//  PreAmp
//
//  Created by james cash on 13/11/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "LogginScreenOne.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface LogginScreenOne ()
@property (weak, nonatomic) IBOutlet UIImageView *UIimageBackground;


@end

@implementation LogginScreenOne

- (void)viewDidLoad {
    [super viewDidLoad];
    self.UIimageBackground.image = [UIImage imageNamed:@"backgroundLogin.png"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
