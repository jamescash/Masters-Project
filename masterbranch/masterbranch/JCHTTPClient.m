//
//  JCHTTPClient.m
//  masterbranch
//
//  Created by james cash on 30/07/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "JCHTTPClient.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "JCFeedObject.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface JCHTTPClient ()
@property (nonatomic, strong) dispatch_queue_t addToArrayThreadSafe;


@end


@implementation JCHTTPClient


- (id)initWithEvent:(eventObject *)curentEvent
{
    self = [super init];
    if (self) {
        
        if ([curentEvent.status isEqualToString:@"alreadyHappened"]) {
            
            self.InstaPlacesResults = [[NSArray alloc ]init];
            self.InstaHashTagResults = [[NSArray alloc]init];
            self.ParseTwitterResults = [[NSArray alloc]init];



            
            NSLog(@"JCHTTPClient initiated with event title %@",curentEvent.eventTitle);
            
           NSString *latLong = [NSString stringWithFormat:@"%@,%@",[curentEvent.LatLong valueForKey:@"lat"],[curentEvent.LatLong valueForKey:@"long"]];
            
            //insta places media
            [self getInstaPlaceIDwithFbPlaceID:curentEvent.venueName location:latLong];
            //insta hashtag media
            [self InstagramFromHashtag:curentEvent.InstaSearchQuery];
            //twitter search
            [self Twittersearch:curentEvent.twitterSearchQuery];
        }
      }
    return self;
}




-(void)getInstaPlaceIDwithFbPlaceID:(NSString*)venueName location:(NSString*)LatLong{
    
    
    NSDictionary *parameters = @{@"q":venueName,@"type":@"place",@"center":LatLong,@"distance":@"2000"};
    
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"search"
                                  parameters:parameters
                                  HTTPMethod:@"GET"];
    
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        
        NSDictionary *JsonResult = result;
        
        NSArray *data = JsonResult[@"data"];
        
        if ([data count]==0) {
            
            NSLog(@"Couldnt find a place ID on FaceBook for the venue %@",venueName);
            self.InstaPlacesResults = @[];
            
        }else{
            NSDictionary *object1 = [data objectAtIndex:0];
            
            NSString *FBplaceID = [object1 valueForKey:@"id"];
            
            NSLog(@"FB place ID %@",FBplaceID);
            [self getInstagramPlaceIDfromFBplaceID:FBplaceID];
        }
        
    }];
    
};


-(void)getInstagramPlaceIDfromFBplaceID: (NSString*) FBplaceIDstring{
    
    
    NSString *InstaPlaceIdSearch = [NSString stringWithFormat:@"https://api.instagram.com/v1/locations/search?facebook_places_id=%@&client_id=d767827366a74edca4bece00bcc8a42c",FBplaceIDstring];
    
    
    NSURL *url = [NSURL URLWithString:InstaPlaceIdSearch];
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            NSLog(@"error coming from InstaPlaceIdSearch %@",error);
            self.InstaPlacesResults = @[];

        } else {
            
            NSDictionary *instaresults = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            
            
            NSArray *data = instaresults [@"data"];
            
            if ([data count]==0) {
                NSLog(@"couldnt get place ID from instagram");
                self.InstaPlacesResults = @[];

            }else{
                NSDictionary *NSDdata = [data objectAtIndex:0];
                
                NSString  *instaPlaceID = NSDdata[@"id"];
                NSString  *Endpoint = [NSString stringWithFormat:@"https://api.instagram.com/v1/locations/%@/media/recent?client_id=d767827366a74edca4bece00bcc8a42c",instaPlaceID];
                NSLog(@"Insta place ID %@",instaPlaceID);
                [self InstagramData:Endpoint];
                
                
            }
            
        }
        
    }];
    
};


-(void)InstagramData:(NSString*)endpoint {
    
    NSURL *url = [NSURL URLWithString:endpoint];
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            NSLog(@"error coming from insta APIcall %@",error);
            self.InstaPlacesResults = @[];

        } else {
            
            NSDictionary *instaresults = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
           
            NSArray *data = instaresults[@"data"];
            
             NSMutableArray *entities = [[NSMutableArray alloc]init];
            
                
                [data  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [entities addObject:[[JCFeedObject alloc] initWithDictionary:obj]];
                }];
                
            
            NSLog(@"Insta objects added from insdie insta endpoint methid %d",[entities count]);

            self.InstaPlacesResults = entities;
   
            
            
            
        }
        
    }];
    
};


-(void)InstagramFromHashtag: (NSString*)instasearchquery {
    
      NSString *endpoint = [NSString stringWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?client_id=d767827366a74edca4bece00bcc8a42c",instasearchquery];
    
    
    NSURL *url = [NSURL URLWithString:endpoint];
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            NSLog(@"error coming from insta APIcall %@",error);
            self.InstaHashTagResults = @[];

        } else {
            
            NSDictionary *instaresults = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            
            NSArray *data = instaresults[@"data"];
            
            
            NSMutableArray *entities = [[NSMutableArray alloc]init];
            
            
            [data  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [entities addObject:[[JCFeedObject alloc] initWithDictionary:obj]];
            }];
            
            
            self.InstaHashTagResults = entities;
            
            
        }
        
    }];
    
};


- (void) Twittersearch: (NSString*) twittersearchquery {
    
    
    ACAccountStore *account = [[ACAccountStore alloc]init];
    
    ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    
    [account requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        
        if (granted == YES) {
            
            NSArray *arrayofaccounts = [account accountsWithAccountType:accountType];
            
            if ([arrayofaccounts count] > 0 ) {
                ACAccount *twitteraccount = [arrayofaccounts lastObject];
                
                NSURL *requestAPI = [NSURL URLWithString:@"https://api.twitter.com/1.1/search/tweets.json"];
                NSDictionary *peramiters = @{@"count" : @"15",
                                             @"q" :twittersearchquery,
                                             @"filter_level": @"medium",
                                             @"result_type": @"recent",
                                             @"lang": @"eu"
                                             };
                
                SLRequest *posts = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:requestAPI parameters:peramiters];
                
                
                posts.account = twitteraccount;
                
                
                [posts performRequestWithHandler:^(NSData *response, NSHTTPURLResponse *urlRespone, NSError *error) {
                    
                    
                    
                    NSDictionary *jsonResults =[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
                    
                    
                    NSArray *results = jsonResults[@"statuses"];
                    
                    
                    if (results.count != 0) {
                        
                         NSMutableArray *entities = [[NSMutableArray alloc]init];
                        
                        
                        [results enumerateObjectsUsingBlock:^(id obj,NSUInteger idx,BOOL *stop){
                            
                            JCFeedObject *cellModel = [[JCFeedObject alloc]initWithTwitterDic:obj];
                            
                                 if (cellModel == nil){
                                 
                                 }else{
                                     [entities addObject:cellModel];
                                 }
                            
                            // [entities addObject:[[JCFeedObject alloc] initWithTwitterDic:obj]];
                        
                        }];
                     
                        NSLog(@"%@",twittersearchquery);
                        self.ParseTwitterResults = entities;
                    
                    
                    
                    }else{
                       
                        NSLog(@"%@",twittersearchquery);
                        self.ParseTwitterResults = @[];

                    
                    }
                    
                }];
                
            }
            
        } else {
            
            NSLog(@"%@", [error localizedDescription]);
        }
    }];
    
};





@end
