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


@interface JCSignUp ()
@property (weak, nonatomic) IBOutlet UIImageView *UserProfilePicture;
@property (nonatomic,strong) UIImage *profileImage;
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (nonatomic,strong) UIImagePickerController *imagePicker;


//methods
- (IBAction)signUp:(id)sender;
- (IBAction)addProfileImage:(id)sender;
- (IBAction)dissmissSignUpvc:(id)sender;
//resize the profile image before it is uplaoded to parse
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
@end

@implementation JCSignUp{
    UITapGestureRecognizer *tapRecognizer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.UserProfilePicture.image = [UIImage imageNamed:@"Placeholder.png"];
    //setup image picker for the profile picture
    self.imagePicker = [[UIImagePickerController alloc]init];
    self.userNameField.delegate = self;
    
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



- (IBAction)signUp:(id)sender {

NSString *userName = [self.userNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
NSString *userEmail = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
   
    //UIImage *profilePic = self.UserProfilePicture.image;
    
    //TODO cheack for valid email and duplicate usernames and valid profile picture
    if ([userName length] == 0 || [password length] == 0 || [userEmail length]== 0 ) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"We have no psychics working at PreAmp yet! Please enter a vaild username & password!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    }else if( self.profileImage == nil) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Your friends would like to see your beautiful face! Please select a profile picture" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
        
        
    }else if ([self NSStringIsValidEmail:userEmail] == NO){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"That doesn't look like a valid email address, plaese try again!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    }else{
        
        //everything seems to be filled out so lets upload the profile image to the backend first
        NSData *fileData;
        NSString *fileName;
        NSString *fileType;
        
        
        //first resize the profile pic and uplaod that
        static const CGSize size = {110, 240};
        UIImage *newImage = [self imageWithImage:self.profileImage scaledToSize:size];
        fileData = UIImagePNGRepresentation(newImage);
        fileName = @"profileImage.png";
        fileType = @"image";
        
        //create a file to upload to parse with the contents of the prfile image
        PFFile *file = [PFFile fileWithName:fileName data:fileData];
        [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            
            if (error) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"That profile pic didn't upload, Please try again" delegate:nil cancelButtonTitle:@"Gerr okay" otherButtonTitles:nil];
                [alert show];
            }else{
                //okay profile picture is uploaded now lets upload the ruser object and realte it to the prfile image file
                PFUser *newUser = [PFUser user];
                newUser.username = userName;
                newUser.password = password;
                newUser.email = userEmail;
                //set a new collum in the user object called profile picture
                [newUser setObject:file forKey:@"profilePicture"];
                //now save the new user to the backend
                [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if (error) {
                        
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Gerr okay" otherButtonTitles:nil];
                        [alert show];
                    }else{
                        NSLog(@"User sucessfully sigend up");
                        [self dismissViewControllerAnimated:YES completion:nil];
                        [self.JCSignUpVCDelegat UserSignedUp];
                    }
                    
                    
                }];
                
                
                
            }
            
            
            
        }];
    }
}

- (IBAction)addProfileImage:(id)sender {
    
   UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Choose Source" delegate:self cancelButtonTitle:@"cancle" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo With Camera", @"Select Photo From Library", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    actionSheet.destructiveButtonIndex = 1;
    [actionSheet showInView:self.view];
}

- (IBAction)dissmissSignUpvc:(id)sender {
    
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
    self.UserProfilePicture.image = self.profileImage;
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];


}

-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma - textfield delgate methos

-(void) keyboardWillShow:(NSNotification *) note {
    [self.view addGestureRecognizer:tapRecognizer];
}

-(void) keyboardWillHide:(NSNotification *) note
{
    [self.view removeGestureRecognizer:tapRecognizer];
}

-(void)didTapAnywhere: (UITapGestureRecognizer*) recognizer {
    //TODO Implement propr resign first preponder on this screen
    [self.userNameField resignFirstResponder];
    [self.emailField resignFirstResponder];
    [self.passwordField resignFirstResponder];
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

@end
