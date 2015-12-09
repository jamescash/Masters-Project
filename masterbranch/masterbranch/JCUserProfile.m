//
//  JCUserProfile.m
//  PreAmp
//
//  Created by james cash on 20/11/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCUserProfile.h"
#import "RKSwipeBetweenViewControllers.h"
#import "RESideMenu.h"
#import "HeaderViewWithImage.h"
#import "HeaderView.h"
#import "JCConstants.h"
#import "JCUserProfileHeaderView.h"
#import "JCParseQuerys.h"
#import <Parse/Parse.h>
#import "JCTerm&ConditionsVC.h"
#import "UIImage+Resize.h"

@interface JCUserProfile ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) CAGradientLayer *vignetteLayer;
@property (nonatomic,strong) JCParseQuerys *JCParseQuerys;
@property (nonatomic,strong) NSString *webViewType;
@property (nonatomic,strong) UIImagePickerController *imagePicker;
@property (nonatomic,strong) JCUserProfileHeaderView *headerView;
@end

@implementation JCUserProfile{
    NSString *webViewTypeAboutUs;
    NSString *webViewTypePrivacyPolicy;
    NSString *webViewTermsAndConditions;
    UITapGestureRecognizer *changeProfilePic;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    webViewTermsAndConditions = @"https://preampapp.wordpress.com/terms-of-service/";
    webViewTypeAboutUs = @"https://preampapp.wordpress.com/about-us/";
    webViewTypePrivacyPolicy = @"https://www.iubenda.com/privacy-policy/879863";
    self.imagePicker = [[UIImagePickerController alloc]init];

    [self customiseNavBar];
    [self layouStickyHeaderView];
    self.tableView.allowsSelection = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.tableView shouldPositionParallaxHeader];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
 
    return 1;

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *profileButtons = [tableView dequeueReusableCellWithIdentifier:@"profileButtons"forIndexPath:indexPath];
    
    
    return profileButtons;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 356;
}




#pragma - Actions

- (IBAction)reportBug:(id)sender {
    
    [self launchMailAppOnDeviceWithSubject:@"Bug Report" andBody:@""];
    
}

- (IBAction)contactUs:(id)sender {
    [self launchMailAppOnDeviceWithSubject:@"General Inquiry" andBody:@""];
}

- (IBAction)enableNofications:(id)sender {
    
    
    BOOL isRegisteredForRemoteNotifications = [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];

    NSLog(@"%d",isRegisteredForRemoteNotifications);
    
    if (isRegisteredForRemoteNotifications) {
        NSLog(@"Unregistered");
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];

    }else{
        NSLog(@"Registered");

        //-- Set Notification
        if ([[UIApplication sharedApplication]respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
        {
            // iOS 8 Notifications
            [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
            
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        }
        else
        {
            // iOS < 8 Notifications
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
             (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
        }
    }
   
}

- (IBAction)logOutButton:(id)sender {
    [self UserSelectedLogOut];
}

- (IBAction)aboutUs:(id)sender {
    self.webViewType = webViewTypeAboutUs;
    [self performSegueWithIdentifier:@"webView" sender:self];
}

- (IBAction)privacyPolicy:(id)sender {
    self.webViewType = webViewTypePrivacyPolicy;
    [self performSegueWithIdentifier:@"webView" sender:self];

}

- (IBAction)termsAndConditions:(id)sender {
    self.webViewType = webViewTermsAndConditions;
    [self performSegueWithIdentifier:@"webView" sender:self];

}

-(void)changeProfilePic{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Choose Source" delegate:self cancelButtonTitle:@"cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo With Camera", @"Select Photo From Library", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    actionSheet.destructiveButtonIndex = 1;
    [actionSheet showInView:self.view];
    
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
    self.headerView.BGImage.image = img;
    self.headerView.ProfileImage.image = img;
   
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
    [self saveNewProfilePic];
    
    
}

-(void)saveNewProfilePic{
    //everything seems to be filled out so lets upload the profile image to the backend first
    NSData *fileData;
    NSString *fileName;
    NSString *fileType;
    
    
    //CGSize size = {self.profileImage.size.width/2, self.profileImage.size.height/2};
    
    CGSize size = {300,300};
    
    
    
    UIImage *newImage = [self.headerView.ProfileImage.image resizedImageToFitInSize:size scaleIfSmaller:YES];
    
    
    
    fileData = UIImagePNGRepresentation(newImage);
    fileName = @"profileImage.png";
    fileType = @"image";
    
    //create a file to upload to parse with the contents of the prfile image
    PFFile *fullSizeProfilePic = [PFFile fileWithName:fileName data:fileData];
    
    [fullSizeProfilePic saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        
       
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"We had an error adding your new profile Image, try again" delegate:nil cancelButtonTitle:@"okay" otherButtonTitles:nil];
            
            [alert show];
        }else{
            
            NSData *fileData;
            NSString *fileName;
            
            
            
            CGSize size = {150, 150};
            
            UIImage *thumbProfilePicture = [self.headerView.ProfileImage.image resizedImageToFitInSize:size scaleIfSmaller:YES];
            
            fileData = UIImagePNGRepresentation(thumbProfilePicture);
            fileName = @"thumbProfilePicture.png";
            
            PFFile *thumbnailProfilePicture = [PFFile fileWithName:fileName data:fileData];
            
            [thumbnailProfilePicture saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                
                PFUser *user = [PFUser currentUser];
                [user setObject:fullSizeProfilePic forKey:@"profilePicture"];
                [user setObject:thumbnailProfilePicture forKey:@"thumbnailProfilePicture"];
                
                [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if (error) {
                        
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"We had an error adding your new profile Image, try again" delegate:nil cancelButtonTitle:@"okay" otherButtonTitles:nil];
                        
                        [alert show];
                        
                    }
                    
                }];
                
                
            }];
            
            
        }
        
        
        
        
    }];
}

#pragma - Helper Methods

-(void)UserSelectedLogOut{
    
    [self.JCParseQuerys getMyFriends:^(NSError *error, NSArray *response) {
        [PFObject unpinAllInBackground:response];
    }];
    
    [self.JCParseQuerys getMyAtrits:^(NSError *error, NSArray *response) {
        [PFObject unpinAllInBackground:response];
    }];
    [PFObject unpinAllObjectsInBackgroundWithName:@"MyArtist"];
    [PFObject unpinAllObjectsInBackgroundWithName:@"MyFriends"];
    [PFUser logOut];
    //[self performSegueWithIdentifier:@"showLoginPage" sender:self];
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"HomeScreenCollectionView"]]
                                                 animated:YES];
    [self.sideMenuViewController hideMenuViewController];
    
}

- (void)customiseNavBar
{
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage im];
    //imageView.alpha = 0.5; //Alpha runs from 0.0 to 1.0
    
    [menuButton setImage:[UIImage imageNamed:@"iconMenu.png"] forState:UIControlStateNormal];
    //[menuButton setImage:[UIImage imageNamed:@"iconMenu.png"] forState:UIControlStateHighlighted];
    menuButton.adjustsImageWhenDisabled = NO;
    //set the frame of the button to the size of the image (see note below)
    menuButton.frame = CGRectMake(0, 0, 40, 40);
    menuButton.opaque = YES;
    [menuButton addTarget:self action:@selector(BackButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    //create a UIBarButtonItem with the button as a custom view
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    
    self.navigationItem.leftBarButtonItem = customBarItem;
    
    self.navigationItem.hidesBackButton = YES;
    
    
}
-(void)BackButtonPressed{
    [self.sideMenuViewController presentLeftMenuViewController];
}

-(void)layouStickyHeaderView{
    self.headerView = [JCUserProfileHeaderView instantiateFromNib];
    self.headerView.BGImage.file = [[PFUser currentUser]objectForKey:JCUserProfilePicture];
    self.headerView.BGImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.headerView.BGImage loadInBackground];
    self.headerView.ProfileImage.file = [[PFUser currentUser]objectForKey:JCUserProfilePicture];
    self.headerView.ProfileImage.contentMode = UIViewContentModeScaleAspectFill;
    self.headerView.ProfileImage = [self addLayerMaskToImageView:self.headerView.ProfileImage withConorRadious:50];
    [self.headerView.ProfileImage loadInBackground];
    self.headerView.blurView.alpha = .8;
    //headerView.UIViewHitTargetChangeProfilePic
    changeProfilePic = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeProfilePic)];
    [self.headerView.UIViewHitTargetChangeProfilePic addGestureRecognizer:changeProfilePic];
    self.headerView.UILableUserName.text = [[PFUser currentUser]objectForKey:JCUserRealName];
    self.headerView.UILableUserParseName.text = [[PFUser currentUser]objectForKey:JCUserUserName];
    [self.tableView setParallaxHeaderView:self.headerView
                                       mode:VGParallaxHeaderModeFill
                                     height:200];
}

-(PFImageView*)addLayerMaskToImageView:(PFImageView*)imageView withConorRadious: (int) conorRadious {
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(conorRadious,conorRadious)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height);
    maskLayer.path = maskPath.CGPath;
    imageView.layer.mask = maskLayer;
    return imageView;
}

-(void)launchMailAppOnDeviceWithSubject:(NSString*)subject andBody:(NSString*)bodytext
{
    NSString *recipients = [NSString stringWithFormat: @"mailto:info@preamp.ie?subject=%@",subject];
    NSString *body = [NSString stringWithFormat: @"&body=%@",bodytext];
    
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"webView"]) {
        
        
        UINavigationController *DVC = (UINavigationController*)[segue destinationViewController];
        JCTerm_ConditionsVC *webview = [[DVC viewControllers]firstObject];
        
        
        
        
        if ([self.webViewType isEqualToString:webViewTermsAndConditions]) {
            webview.url = webViewTermsAndConditions;
        }else if ([self.webViewType isEqualToString:webViewTypeAboutUs]){
            webview.url = webViewTypeAboutUs;
        }else if ([self.webViewType isEqualToString:webViewTypePrivacyPolicy]){
            webview.url = webViewTypePrivacyPolicy;
        }
        
        
    }
}

@end
