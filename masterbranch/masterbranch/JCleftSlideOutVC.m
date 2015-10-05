//
//  JCleftSlideOutVC.m
//  masterbranch
//
//  Created by james cash on 17/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "JCleftSlideOutVC.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "AppDelegate.h"
#import "JCHomeMainScreenVC.h"
#import <Parse/Parse.h>




@interface JCleftSlideOutVC ()
//@property (strong, readwrite, nonatomic) UITableView *tableView;
@property (strong,readwrite,nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) PFUser *currentUser;
//Friends lable
@property (weak, nonatomic) IBOutlet UILabel *friends;
@property (weak, nonatomic) IBOutlet UILabel *artist;

@end

@implementation JCleftSlideOutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentUser = [PFUser currentUser];
    
    
        //set up taleview
        self.tableView.opaque = NO;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.backgroundView = nil;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.bounces = NO;
        self.tableView.scrollsToTop = NO;
    
    //Make the labes tapabul for number for friends
    //TODO make the number lable work
    self.friends.userInteractionEnabled = YES;
    self.numberOfFriends.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(numberOfFriendsLableTap)];
    [self.numberOfFriends addGestureRecognizer:tapGesture];
    [self.friends addGestureRecognizer:tapGesture];
    
    
    //Make artist lable tapabul
    self.artist.userInteractionEnabled = YES;
    self.numberOfArtistFollowing.userInteractionEnabled = YES;
    UITapGestureRecognizer *artisttapped =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(numberOfArtistLableTap)];
    [self.numberOfArtistFollowing addGestureRecognizer:artisttapped];
    [self.artist addGestureRecognizer:artisttapped];
    
    
    
    
    

}

-(void)viewWillAppear:(BOOL)animated{
    
//    NSLog(@"%@",[self.currentUser objectForKey:@"username"]);
//    
//    PFFile *imageFile = self.currentUser[@"profilePicture"];
//    
//    NSLog(@"%@",[imageFile description]);
//    
//    [imageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
//        if (!error && imageData)
//        {
//            //If there was no error with the internet request and some kind of data was returned, use that data to form the profile image with the handy method of UIImage.
//            
//            //Set the image view to the image with the data returned from Parse.
//            NSLog(@"Profile image returned");
//            self.profilePicture.image = [UIImage imageWithData:imageData];
//        }
//        else
//        {
//            //Use Ben Jakuben's easy to read error printing technique.
//            NSLog(@"Error: %@ %@", error, [error localizedDescription]);
//        }
//    }];
//    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"HomeScreenCollectionView"]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
       //Bring the center view cintroller to the center screen
        //case 1:
         //[self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"ProfilePage"]]
           //                                              animated:YES];
          //[self.sideMenuViewController hideMenuViewController];
           // break;
        case 1:
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"JCInbox"]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 3:
            NSLog(@"User Logged out delgation method engaged");
            [self UserSelectedLogOut];
            break;
        default:
            break;
    }
}

-(void)UserSelectedLogOut{
    NSLog(@"User Logged Out");
    [PFUser logOut];
    
    
  
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"HomeScreenCollectionView"]]
                                                 animated:YES];
    [self.sideMenuViewController hideMenuViewController];
    
}

#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    
    NSArray *titles = @[@"Home",@"Music Diary", @"Gig Invites", @"Log Out"];
    NSArray *images = @[@"IconHome",@"IconEmpty", @"IconEmpty", @"IconEmpty"];
    cell.textLabel.text = titles[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:images[indexPath.row]];
    
    return cell;
}




//-(void)loadData {
//
//
//    if ([FBSDKAccessToken currentAccessToken]) {
//
//        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
//         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
//             if (!error) {
//                 NSLog(@"fetched user:%@", result);
//             }else{
//                 NSLog(@"%@",error);
//             }
//         }];
//    }
//
//
//    // ...
//
//            // result is a dictionary with the user's Facebook data
//           // NSDictionary *userData = (NSDictionary *)result;
//           // NSLog(@"%@",userData);
//            //NSString *facebookID = userData[@"id"];
//            //NSString *name = userData[@"name"];
//            //NSString *location = userData[@"location"][@"name"];
//            //NSString *gender = userData[@"gender"];
//            //NSString *birthday = userData[@"birthday"];
//            //NSString *relationship = userData[@"relationship_status"];
//
//       //NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
//
//
////            NSLog(@"%@",facebookID);
////            NSLog(@"%@",name);
////            NSLog(@"%@",location);
////            NSLog(@"%@",gender);
////            NSLog(@"%@",birthday);
//          //  NSLog(@"%@",relationship);
//            // Now add the data to the UI elements
//            // ...
//
//
//
//   // }];
//}


- (void)numberOfFriendsLableTap {
    
    
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"ProfilePage"]]
                                                 animated:YES];
    [self.sideMenuViewController hideMenuViewController];
    
}

- (void)numberOfArtistLableTap {

    NSLog(@"Lable tapped");
    
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"followingArtist"]]
                                                 animated:YES];
    [self.sideMenuViewController hideMenuViewController];


}


@end
