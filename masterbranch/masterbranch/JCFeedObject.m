//
//  JCFeedObject.m
//  masterbranch
//
//  Created by james cash on 28/06/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "JCFeedObject.h"

@implementation JCFeedObject



- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = super.init;
    if (self) {
        
        NSDictionary *caption = dictionary [@"caption"];
        
        // really handy way to make an array of all the keys of a dictionary.
        //NSString *allKeys = [[dictionary allKeys] objectAtIndex:i];
        
        if ( caption == (id)[NSNull null]) {
            self.content = @"No content for here";
            self.title = @"No title";
            self.time = @"no time";
        }else{
             NSDictionary *from = caption[@"from"];
            self.content = caption[@"text"];
            self.title = from[@"full_name"];
            self.time = caption[@"created_time"];

         }
        
        
        
        self.imageName = dictionary[@"imageName"];
        
        NSDictionary *images = dictionary [@"images"];
        NSDictionary *lowResolution = images [@"low_resolution"];
        NSString *pictureurl = lowResolution [@"url"];
        NSURL *pic = [NSURL URLWithString:pictureurl];
        NSData *data = [NSData dataWithContentsOfURL:pic];
        UIImage *img = [[UIImage alloc] initWithData:data];
        self.imageName = img;
        
    }
    return self;
}


- (instancetype)initWithTwitterDic:(NSDictionary *)dictionary
{
    
    self = super.init;
    if (self) {
        
        NSString *tweetText = dictionary[@"text"];
        
        if ([tweetText rangeOfString:@"RT"].location == NSNotFound) {
           // NSLog(@"No bad tweet");
            
        } else {
            return nil;
        }
        
        self.time = dictionary[@"created_at"];
       
        //NSTimeInterval interval = dictionary[@"created_at"];
//       
//        [NSDate dateWithTimeIntervalSince1970:dictionary[@"created_at"];
//        NSDate *aDate = [NSDate dateWithTimeIntervalSince1970: interval];
//        NSLog(@"Date = %@", aDate);
        
        self.content = dictionary[@"text"];
        //NSLog(@"%@",dictionary);
        
        NSDictionary *entities = [dictionary objectForKey:@"entities"];
        NSArray *media  = entities [@"media"];
        NSArray *urlarray = [media valueForKey:@"media_url_https"];
        NSString *url = urlarray[0];
        NSURL *mediapic = [NSURL URLWithString:url];
        NSData *data = [NSData dataWithContentsOfURL:mediapic];
        UIImage *img = [[UIImage alloc] initWithData:data];
        self.imageName = img;
        
        //puting in the display links for tweets with URLS
        //NSArray *displayUrls = entities[@"urls"];
       
//        if ([displayUrls count]>0) {
//            NSDictionary *displayURLs = [displayUrls objectAtIndex:0];
//            NSString *display_url = displayURLs[@"display_url"];
//            NSString *expanded_url = displayURLs[@"expanded_url"];
//            NSString *url = displayURLs[@"url"];
//            //NSLog(@"%@",display_url);
//           // NSLog(@"%@",expanded_url);
//           // NSLog(@"%@",url);
//            NSURL *mediapic = [NSURL URLWithString:display_url];
//            NSData *data = [NSData dataWithContentsOfURL:mediapic];
//            UIImage *img = [[UIImage alloc] initWithData:data];
//            self.imageName = img;
//         }
        
       
        
        NSDictionary *user = dictionary[@"user"];
        
        self.title = user[@"name"];
      
    }
   
  return self;
    
}

@end
