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

@interface JCleftSlideOutVC ()

@end

@implementation JCleftSlideOutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
   
    UIColor * backroundcolour = [UIColor
                          colorWithRed:247.0/255.0
                          green:249.0/255.0
                          blue:250.0/255.0
                          alpha:1.0];
    
    self.view.backgroundColor =backroundcolour;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
