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


@interface JCleftSlideOutVC ()
@property (strong, readwrite, nonatomic) UITableView *tableView;

@end

@implementation JCleftSlideOutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //get facebook stuff
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 54 * 5) / 2.0f, self.view.frame.size.width, 54 * 5) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView.scrollsToTop = NO;
        tableView;
    });
    [self.view addSubview:self.tableView];
    
    
    
    [self loadData];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)loadData {
    // ...
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            NSLog(@"%@",userData);
            //NSString *facebookID = userData[@"id"];
            //NSString *name = userData[@"name"];
            //NSString *location = userData[@"location"][@"name"];
            //NSString *gender = userData[@"gender"];
            //NSString *birthday = userData[@"birthday"];
            //NSString *relationship = userData[@"relationship_status"];
            
       //NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            
            
//            NSLog(@"%@",facebookID);
//            NSLog(@"%@",name);
//            NSLog(@"%@",location);
//            NSLog(@"%@",gender);
//            NSLog(@"%@",birthday);
          //  NSLog(@"%@",relationship);
            // Now add the data to the UI elements
            // ...
        
        
            // URL should point to https://graph.facebook.com/{facebookId}/picture?type=large&return_ssl_resources=1
//            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
//            
//            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:pictureURL];
//            
//            // Run network request asynchronously
//            [NSURLConnection sendAsynchronousRequest:urlRequest
//                                               queue:[NSOperationQueue mainQueue]
//                                   completionHandler:
//             ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//                 if (connectionError == nil && data != nil) {
//                     // Set the image in the imageView
//                     // ...
//                 }
//             }];
        
        
        }
    }];
}


#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            //[self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"HomeScreenCollectionView"]]
                                                     //    animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
      //  case 1:
          //  [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"secondViewController"]]
          //                                               animated:YES];
         //   [self.sideMenuViewController hideMenuViewController];
          //  break;
        case 4:
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
    
    AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
    
    
    UIViewController* rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegateTemp.window.rootViewController = rootController;
    
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
    return 5;
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
    
    NSArray *titles = @[@"Home", @"Calendar", @"Profile", @"Settings", @"Log Out"];
    NSArray *images = @[@"IconHome", @"IconCalendar", @"IconProfile", @"IconSettings", @"IconEmpty"];
    cell.textLabel.text = titles[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:images[indexPath.row]];
    
    return cell;
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
