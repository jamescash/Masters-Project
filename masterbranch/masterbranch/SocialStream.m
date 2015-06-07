//
//  SocialStream.m
//  Second_Prototype
//
//  Created by james cash on 01/06/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "SocialStream.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>


@interface SocialStream ()

@end

@implementation SocialStream

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self twitterSearch];
    [self instgramSearch];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
      // return [self.twitterResult count];
    return [self.instaResults count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SocialStream" forIndexPath:indexPath];
    
    
    
//    self.tweet = self.twitterResult [indexPath.row];
//    //cell.textLabel.text = self.tweet[@"text"];
//    //cell.textLabel.text = nil;
//
//    NSDictionary *entities = [self.tweet objectForKey:@"entities"];
//    NSArray *media  = entities [@"media"];
//    
//    NSArray *urlarray = [media valueForKey:@"media_url_https"];
//    NSString *url = urlarray[0];
//    
//    NSURL *mediapic = [NSURL URLWithString:url];
//    
//    NSData *data = [NSData dataWithContentsOfURL:mediapic];
//    UIImage *img = [[UIImage alloc] initWithData:data];
//    cell.imageView.image = img;
    
    self.instagramobject = self.instaResults [indexPath.row];
    
    NSDictionary *images = self.instagramobject [@"images"];
    NSDictionary *lowResolution = images [@"low_resolution"];
    NSString *pictureurl = lowResolution [@"url"];
    NSURL *pic = [NSURL URLWithString:pictureurl];
    NSData *data = [NSData dataWithContentsOfURL:pic];
    UIImage *img = [[UIImage alloc] initWithData:data];
    cell.imageView.image = img;

//    NSString *stringRep = [NSString stringWithFormat:@"%@",lowResolution];
//    NSLog(@"%@",stringRep);
    
    return cell;
}


- (void) twitterSearch {
    
    ACAccountStore *account = [[ACAccountStore alloc]init];
    
    ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    
    [account requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        
        if (granted == YES) {
            
            NSArray *arrayofaccounts = [account accountsWithAccountType:accountType];
            
            if ([arrayofaccounts count] > 0 ) {
                ACAccount *twitteraccount = [arrayofaccounts lastObject];
                
//                        NSString *stringRep = [NSString stringWithFormat:@"%@",[self.currentevent twitterSearchQuery] ];
//                                    NSLog(@"%@",stringRep);
                
                NSURL *requestAPI = [NSURL URLWithString:@"https://api.twitter.com/1.1/search/tweets.json"];
                NSDictionary *peramiters = @{@"count" : @"50",
                                             @"q" :[self.currentevent twitterSearchQuery],
                                             @"filter_level": @"medium",
                                             @"result_type": @"recent"
                                             };
                
                SLRequest *posts = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:requestAPI parameters:peramiters];
                
                
                posts.account = twitteraccount;
                
                
                [posts performRequestWithHandler:^(NSData *response, NSHTTPURLResponse *urlRespone, NSError *error) {
                    
                    
                    
                    NSDictionary *jsonResults =[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
                    
                    self.twitterResult = jsonResults[@"statuses"];
                    
                    if (self.twitterResult.count != 0) {
                        
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [self.tableView reloadData];
                            
                        });
                        
                    }
                    
                }];
                
            }
            
        } else {
            
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
    
};


- (void) instgramSearch {
    
 
    
 NSString *searchquery = [NSString stringWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?client_id=d767827366a74edca4bece00bcc8a42c",[self.currentevent InstaSearchQuery]];
    
  NSURL *url = [NSURL URLWithString:searchquery];
    
 [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            NSLog(@"fuck error");
        } else {
            
    NSDictionary *instaresults = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
     
            self.instaResults = instaresults [@"data"];
            
            if (self.instaResults.count != 0) {
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.tableView reloadData];
                    
                });
                
            }
            
//            NSString *stringRep = [NSString stringWithFormat:@"%@",self.instaResults];
//            NSLog(@"%@",stringRep);
            
    
        }
    }];
};



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}




@end
