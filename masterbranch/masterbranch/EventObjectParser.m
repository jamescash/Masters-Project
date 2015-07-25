//
//  EventObjectParser.m
//  masterbranch
//
//  Created by james cash on 25/06/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "EventObjectParser.h"

@implementation EventObjectParser{
    NSDictionary *JSONresults;
};

-(NSString*)formatDateForAPIcall:(NSDate*)date{

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-LL-dd"];
    NSString *formattedDate = [dateFormat stringFromDate:date];

    return formattedDate;
};//end of formatDateForAPIcall






-(NSString*)makeInstagramSearch: (NSString*) eventTitle{
    
    //setup insta search query
    NSString *A = eventTitle;
    //remove any white space  //TAKE OUT ANY " OR ' OR ANYTHING THAT PEOPLE WOULDNT NORMALY HASHTAG
    NSString *b = [A stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *c = [b stringByReplacingOccurrencesOfString:@"'" withString:@""];
    //NSLog(@"%@",c);
    return c;

};//end of insta search query maker


-(NSString*)makeTitterSearch: (NSString*) eventTitle venueName:(NSString*)venueName{
    
    //setting twitter search query 1
    NSMutableString *artistNameHashtag = [[NSMutableString alloc]init];
    [artistNameHashtag appendString:@"#"];
    NSMutableString *venueHashtag = [[NSMutableString alloc]init];
    [venueHashtag appendString:@" #"];
    [artistNameHashtag appendString:eventTitle];
    [venueHashtag appendString:venueName];
    //encoding query for web
    NSString *artistNameEncodedRequest = [artistNameHashtag stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    
    return artistNameEncodedRequest;
    
};//end of twitter search query maker



-(NSString*)GetEventStatus: (NSString*) currentEventDate; {
    
    //identifying when the gig happened
    NSString *objectdate = currentEventDate;
    NSString *dateformatted = [objectdate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-LL-dd HH:mm:ss"];
    NSDate *date = [dateFormat dateFromString:dateformatted];
    NSDate *todaysdate = [NSDate date];
    
    //getting the diffrence in hours between the events date&time and NOW in +/-
    NSTimeInterval diff = ([date timeIntervalSinceDate:todaysdate]/60)/60;
    
    //NSLog(@"%f",diff);
    
    //setting event status based on the diffrent in event date&time and now
    if (diff < -3 ) {
       return @"alreadyHappened";
    }else if (diff > 1){
        return @"happeningLater";
    }else {
        return @"currentlyhappening";
    };

};//end of get event stauts


-(UIImageView*)makeThumbNail:(NSData *)pictureData{
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);

    dispatch_async(dispatch_get_main_queue(),^{
    
    
    UIImage *img = [[UIImage alloc] initWithData:pictureData];
    
    UIGraphicsBeginImageContext(CGSizeMake(img.size.width/5, img.size.height/5));
    
    [img drawInRect:CGRectMake(0,0,img.size.width/5, img.size.height/5)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    NSData *smallData = UIImagePNGRepresentation(newImage);
    
    UIImage *newimage = [[UIImage alloc] initWithData:smallData];
        
//        CALayer *imageLayer = newimage.layer;
//        [imageLayer setCornerRadius:5];
//        [imageLayer setBorderWidth:1];
//        [imageLayer setMasksToBounds:YES];
    
    self.thumbNail = [[UIImageView alloc] initWithImage:newimage];
     
        
    dispatch_semaphore_signal(sema);


    
    });

    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    return self.thumbNail;

};






@end
