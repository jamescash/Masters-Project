//
//  JCSignUp.m
//  PreAmp
//
//  Created by james cash on 25/09/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCSignUp.h"

//sign up new user and save to backend
#import <Parse/Parse.h>
#import "UIImage+Resize.h"
#import "IHKeyboardAvoiding.h"



@interface JCSignUp ()
@property (weak, nonatomic) IBOutlet UIImageView *UserProfilePicture;
@property (nonatomic,strong) UIImage *profileImage;
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (nonatomic,strong) UIImagePickerController *imagePicker;
@property (weak, nonatomic) IBOutlet UITextField *userFullName;

@property (weak, nonatomic) IBOutlet UIView *UiViewKeyboardDissmissView;
@property (weak, nonatomic) IBOutlet UIImageView *UIimageBackGround;

//methods
- (IBAction)signUp:(id)sender;
- (IBAction)addProfileImage:(id)sender;
- (IBAction)dissmissSignUpvc:(id)sender;
//resize the profile image before it is uplaoded to parse
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
@end

@implementation JCSignUp

- (void)viewDidLoad {
    [super viewDidLoad];
    [IHKeyboardAvoiding setAvoidingView:(UIView *)self.UiViewKeyboardDissmissView];
    self.screenName = @"Sign up screen";
    self.UserProfilePicture.image = [UIImage imageNamed:@"buttonProfileImage.png"];
    self.UIimageBackGround.image = [UIImage imageNamed:@"backgroundLogin"];
    self.UIimageBackGround.contentMode = UIViewContentModeScaleAspectFill;
    //self.UIimageBackGround = [self addVinettLayerToBackGroundToImage:self.UIimageBackGround];

    //setup image picker for the profile picture
    self.imagePicker = [[UIImagePickerController alloc]init];
    
    self.UserProfilePicture.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addProfileImage)];
    [self.UserProfilePicture addGestureRecognizer:tapGesture];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(IBAction)signUp:(id)sender {
    
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc]
                                             initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    

    activityView.center=self.view.center;
    activityView.color = [UIColor blackColor];
    [activityView startAnimating];
    [self.view addSubview:activityView];
    [sender setEnabled:NO];

NSString *userName = [self.userNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
NSString *userEmail = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
NSString *userFullName = [self.userFullName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
   
    //UIImage *profilePic = self.UserProfilePicture.image;
    
    //TODO cheack for valid email and duplicate usernames and valid profile picture
    if ([userName length] == 0 || [password length] == 0 || [userEmail length]== 0 ) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Please enter a vaild username & password!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [activityView stopAnimating];
        [sender setEnabled:YES];


        [alert show];
    }else if( self.profileImage == nil) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Please select a profile picture" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [activityView stopAnimating];
        [sender setEnabled:YES];


        [alert show];
        
        
    }else if ([self NSStringIsValidEmail:userEmail] == NO){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"That doesn't look like a valid email address, plaese try again!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [activityView stopAnimating];
        [sender setEnabled:YES];


        [alert show];
    }else if (![self validateName:userFullName]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Please make sure you full name is entered correctly!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [activityView stopAnimating];
        [sender setEnabled:YES];


        [alert show];
    }else if (![self validateUserName:userName]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Please make sure your username only contains letters or numbers with no white space" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [activityView stopAnimating];
        [sender setEnabled:YES];

        
        [alert show];
    }else if ([password length]< 4){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Please make sure your password is four characters long" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [activityView stopAnimating];
        [sender setEnabled:YES];

        
        [alert show];
    }else{
        
        //everything seems to be filled out so lets upload the profile image to the backend first
        NSData *fileData;
        NSString *fileName;
        NSString *fileType;
        
        
        //CGSize size = {self.profileImage.size.width/2, self.profileImage.size.height/2};
        
        CGSize size = {300,300};

        
        
        UIImage *newImage = [self.profileImage resizedImageToFitInSize:size scaleIfSmaller:YES];
        
        
        
        fileData = UIImagePNGRepresentation(newImage);
        fileName = @"profileImage.png";
        fileType = @"image";
        
        //create a file to upload to parse with the contents of the prfile image
        PFFile *fullSizeProfilePic = [PFFile fileWithName:fileName data:fileData];
        [fullSizeProfilePic saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            
            if (error) {
            
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"That profile pic didn't upload, Please try again" delegate:nil cancelButtonTitle:@"okay" otherButtonTitles:nil];
                [activityView stopAnimating];

                [alert show];
            }else{
                
                
                NSData *fileData;
                NSString *fileName;
                
                
                
                CGSize size = {150, 150};

                UIImage *thumbProfilePicture = [self.profileImage resizedImageToFitInSize:size scaleIfSmaller:YES];
                
                fileData = UIImagePNGRepresentation(thumbProfilePicture);
                fileName = @"thumbProfilePicture.png";
                
                PFFile *thumbnailProfilePicture = [PFFile fileWithName:fileName data:fileData];
                
                [thumbnailProfilePicture saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                
                    if (error) {
                        
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"That profile picture didn't upload, Please try again" delegate:nil cancelButtonTitle:@"okay" otherButtonTitles:nil];
                        [activityView stopAnimating];

                        [alert show];
                    }else{
                    
                        //okay profile picture is uploaded now lets upload the user object and realte it to the prfile image file
                        PFUser *newUser = [PFUser user];
                        newUser.username = userName;
                        newUser.password = password;
                        newUser.email = userEmail;
                        NSString *lowercaseUserName = [userName lowercaseString];
                        
                        //set a new collum in the user object called profile picture
                        [newUser setObject:lowercaseUserName forKey:@"searchUsername"];
                        [newUser setObject:userFullName forKey:@"realName"];
                        [newUser setObject:fullSizeProfilePic forKey:@"profilePicture"];
                        [newUser setObject:thumbnailProfilePicture forKey:@"thumbnailProfilePicture"];
                        //now save the new user to the backend
                        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                            if (error) {
                                
                                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"okay" otherButtonTitles:nil];
                                [activityView stopAnimating];

                                [alert show];
                            }else{
                                NSLog(@"User sucessfully sigend up");
                                [activityView stopAnimating];

                                //[self dismissViewControllerAnimated:YES completion:nil];
                                [self saveInstalation];
                                [self dismissViewControllerAnimated:YES completion:nil];
                                //[self performSegueWithIdentifier:@"unwindHomeScreenCollectionView" sender:self];
                            }
                            
                            
                        }];
                    }
                
                }];
            }
            
        }];
    }
}

-(void)saveInstalation{
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    currentInstallation[@"installationUser"] = [[PFUser currentUser]objectId];
    [currentInstallation saveInBackground];
}

-(IBAction)addProfileImage:(id)sender {
    
    [self addProfileImage];
}

-(void)addProfileImage{
    [self resignFirstRespomders];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Choose Source" delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo With Camera", @"Select Photo From Library", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    actionSheet.destructiveButtonIndex = 1;
    [actionSheet showInView:self.view];
}

-(IBAction)dissmissSignUpvc:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma - ImagePicker

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self TakePhotoWithCamera];
    }
    else if (buttonIndex == 1)
    {
        [self SelectPhotoFromLibrary];
    }
    
    else if (buttonIndex == 2)
    {
        NSLog(@"cancel");
    }
}

-(void) TakePhotoWithCamera
{
    [self startCameraPickerFromViewController:self usingDelegate:self];
}

-(void) SelectPhotoFromLibrary
{
    [self startLibraryPickerFromViewController:self usingDelegate:self];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"dismiss image picker");
    
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)startCameraPickerFromViewController:(UIViewController*)controller usingDelegate:(id<UIImagePickerControllerDelegate>)delegateObject
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePicker.allowsEditing = NO;
        self.imagePicker.delegate = self;
        [controller presentViewController:self.imagePicker animated:YES completion:nil];
    }
    return YES;
}

- (BOOL)startLibraryPickerFromViewController:(UIViewController*)controller usingDelegate:(id<UIImagePickerControllerDelegate>)delegateObject
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.imagePicker.allowsEditing = NO;
        self.imagePicker.delegate = self;
        [controller presentViewController:self.imagePicker animated:YES completion:nil];
    }
    return YES;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *img = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    self.profileImage = img;
    
    self.UserProfilePicture = [self addLayerMaskToImageView:self.UserProfilePicture];
    self.UserProfilePicture.image = self.profileImage;
    self.UserProfilePicture.contentMode = UIViewContentModeScaleAspectFill;
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];


}

-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


#pragma - helperMethods

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}


- (BOOL)validateName:(NSString *)string
{
    NSError *error             = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:
                                  @"[a-zA-Z ]" options:0 error:&error];
    
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:string options:0 range:NSMakeRange(0, [string length])];
    return numberOfMatches == string.length;
}

- (BOOL)validateUserName:(NSString *)string
{
    NSError *error             = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:
                                  @"[a-zA-Z0-9]" options:0 error:&error];
    
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:string options:0 range:NSMakeRange(0, [string length])];
    return numberOfMatches == string.length;
}

-(void)resignFirstRespomders{
    [self.emailField resignFirstResponder];
    [self.userFullName resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self.userNameField resignFirstResponder];
}


-(UIImageView*)addLayerMaskToImageView:(UIImageView*)imageView{
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(2.0, 2.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height);
    maskLayer.path = maskPath.CGPath;
    imageView.layer.mask = maskLayer;
    return imageView;
}
@end
