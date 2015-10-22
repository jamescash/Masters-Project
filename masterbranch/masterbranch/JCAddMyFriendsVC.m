//
//  JCAddMyFriendsVC.m
//  PreAmp
//
//  Created by james cash on 21/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCAddMyFriendsVC.h"
#import <Parse/Parse.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>




@interface JCAddMyFriendsVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation JCAddMyFriendsVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
//    // Issue a Facebook Graph API request to get your user's friend list
//    [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
//        if (!error) {
//            // result will contain an array with your user's friends in the "data" key
//            NSArray *friendObjects = [result objectForKey:@"data"];
//            NSMutableArray *friendIds = [NSMutableArray arrayWithCapacity:friendObjects.count];
//            // Create a list of friends' Facebook IDs
//            for (NSDictionary *friendObject in friendObjects) {
//                [friendIds addObject:[friendObject objectForKey:@"id"]];
//            }
//            
//            // Construct a PFUser query that will find friends whose facebook ids
//            // are contained in the current user's friend list.
//            PFQuery *friendQuery = [PFUser query];
//            [friendQuery whereKey:@"fbId" containedIn:friendIds];
//            
//            // findObjects will return a list of PFUsers that are friends
//            // with the current user
//            NSArray *friendUsers = [friendQuery findObjects];
//        }
//    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
