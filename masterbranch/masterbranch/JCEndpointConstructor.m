//
//  JCEndpointConstructor.m
//  masterbranch
//
//  Created by james cash on 25/07/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "JCEndpointConstructor.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@implementation JCEndpointConstructor{
    BOOL instaPlaceIDfinished;
    BOOL instaHashTagFinished;
};



-(void)buildHappeningLaterEndPointsForEvent:(eventObject*)currentevent{
    
    
    NSString *latLong = [NSString stringWithFormat:@"%@,%@",[currentevent.LatLong valueForKey:@"lat"],[currentevent.LatLong valueForKey:@"long"]];
    
    self.endpoints = [[NSMutableArray alloc]init];

     instaPlaceIDfinished = NO;
     instaHashTagFinished = NO;
    
    [self getFbPlaceID:currentevent.venueName location:latLong];
    
    [self InstagramHashtagMediaSearchEndpoint:currentevent.InstaSearchQuery];
    
   
    
}



-(void)getFbPlaceID:(NSString*)venueName location:(NSString*)location{
    

    NSDictionary *parameters = @{@"q":venueName,@"type":@"place",@"center":location,@"distance":@"2000"};
    
    
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
            
        }else{
            NSDictionary *object1 = [data objectAtIndex:0];
           
            NSString *FBplaceID = [object1 valueForKey:@"id"];
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
        } else {
            
            NSDictionary *instaresults = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            
            
            NSArray *data = instaresults [@"data"];
            
            if ([data count]==0) {
                NSLog(@"couldnt get place ID from instagram");
            }else{
                NSDictionary *NSDdata = [data objectAtIndex:0];
               
                NSString  *instaPlaceID = NSDdata[@"id"];
                NSString  *Endpoint = [NSString stringWithFormat:@"https://api.instagram.com/v1/locations/%@/media/recent?client_id=d767827366a74edca4bece00bcc8a42c",instaPlaceID];
                
                //NSDictionary * instaPlace =[NSDictionary dictionaryWithObject:Endpoint forKey:@"insta"];

                
                [self.endpoints addObject:Endpoint];
                instaPlaceIDfinished = YES;
                [self considerRunningDelagationMethod];
               
                
            }
            
        }
   
    }];

};


-(void)InstagramHashtagMediaSearchEndpoint :(NSString*) instasearchquery{
   
   NSString *Endpoint = [NSString stringWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?client_id=d767827366a74edca4bece00bcc8a42c",instasearchquery];
    
     //NSDictionary * instaPlace =[NSDictionary dictionaryWithObject:Endpoint forKey:@"insta"];

    [self.endpoints addObject:Endpoint];
    instaHashTagFinished = YES;
    [self considerRunningDelagationMethod];
};


-(void) TwitterHashTagEndpoint{
    

   



};












-(void)considerRunningDelagationMethod{
    
    if (instaHashTagFinished && instaPlaceIDfinished) {
        
   
            [self.JCEndpointConstructordelegate reloadTabeView];

    
    }

}












@end
