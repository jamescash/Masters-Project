//
//  JCFBAddUserName.m
//  PreAmp
//
//  Created by james cash on 22/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCFBAddUserName.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "UIImage+Resize.h"
#import <UIKit/UIKit.h>




@interface JCFBAddUserName ()
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel     *userFacebookName;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
- (IBAction)userSelectedDone:(id)sender;

@end

@implementation JCFBAddUserName{
    UITapGestureRecognizer *tapRecognizer;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userImage.image = [UIImage imageNamed:@"loadingstrokeYellow.png"];
    self.userFacebookName.text = @"loading...";
    [self getUsersFacebookData];
    
    
    
    //register for keyboard notification
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self selector:@selector(keyboardWillShow:) name:
     UIKeyboardWillShowNotification object:nil];
    
    [nc addObserver:self selector:@selector(keyboardWillHide:) name:
     UIKeyboardWillHideNotification object:nil];
    
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                            action:@selector(didTapAnywhere:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)getUsersFacebookData{
    
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        
        
        
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *facebookID = userData[@"id"];
            NSString *name = userData[@"name"];
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:pictureURL];
            [NSURLConnection sendAsynchronousRequest:urlRequest
                                               queue:[NSOperationQueue mainQueue]
                                   completionHandler:
             ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                 
                 
                 if (connectionError == nil && data != nil) {
                     
                     
                     UIImage *userprofileImage = [UIImage imageWithData:data];
                     self.userImage.image = userprofileImage;
                     self.userFacebookName.text = name;
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
                                     
                                     [[PFUser currentUser] setObject:name forKey:@"facebookName"];
                                     [[PFUser currentUser] setObject:facebookID forKey:@"facebookId"];
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





- (IBAction)userSelectedDone:(id)sender {
    NSString *userName = [self.userNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
   
    if ([userName length] == 0 ) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Please enter a username!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    }else if([userName length]>15){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Please enter a username under 10 characters long!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    }else if ([userName length]<3){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Please enter a username more then 3 characters long!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    }else if (![self validateUserName:userName]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Please make sure your username only contains letters or numbers" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    }else{
        
        [self checkIfUserNameExists:userName completionblock:^(bool usernameExists) {
            
            
            if (usernameExists) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Username is already taken" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alert show];
            }else{
                
                NSString *lowercaseUserName = [userName lowercaseString];
                
                [[PFUser currentUser] setObject:userName forKey:@"username"];
                [[PFUser currentUser] setObject:lowercaseUserName forKey:@"searchUsername"];
                [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    
                    [self performSegueWithIdentifier:@"unwindHomeScreenCollectionView" sender:self];
                    NSLog(@"all signed up");
                    
                }];
             
            }
            
        }];
        
        
        
    }
}

#pragma - textfield delagets
-(void) keyboardWillShow:(NSNotification *) note {
    [self.view addGestureRecognizer:tapRecognizer];
}

-(void) keyboardWillHide:(NSNotification *) note
{
    [self.view removeGestureRecognizer:tapRecognizer];
}

-(void)didTapAnywhere: (UITapGestureRecognizer*) recognizer {
    //TODO Implement tap return to resigen first responder
    [self.userNameTextField resignFirstResponder];
    
}


#pragma - Helper Methods 

- (BOOL)validateUserName:(NSString *)string
{
    NSError *error             = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:
                                  @"[a-zA-Z0-9]" options:0 error:&error];
    
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:string options:0 range:NSMakeRange(0, [string length])];
    return numberOfMatches == string.length;
}

-(void)checkIfUserNameExists:(NSString*)username completionblock:(void(^)(bool usernameExists))finishedcheking{
    
    PFQuery *doesUserNameExist = [PFUser query];
    [doesUserNameExist whereKey:@"username" equalTo:username];
    
    
    [doesUserNameExist findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if ([objects count] == 0) {
            finishedcheking(NO);
        }else{
            finishedcheking(YES);
        }
        
    }];
}

//[self performSegueWithIdentifier:@"unwindToHomeScreen" sender:self];













@end
