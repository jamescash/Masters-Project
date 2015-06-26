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



//-(NSDictionary*)GetEventJSON: (NSString*)countyName dateObject:(NSString*)date {
//
//    //creat semaphore to signle when asynch API request is finished
//    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
//
//    
//    //connet to the BandsinTown API get all events from the area on todays date
//    NSString *endpoint = [NSString stringWithFormat:@"http://api.bandsintown.com/events/search.json?api_version=2.0&app_id=YOUR_APP_ID&date=%@,%@&location=%@",date,date,countyName];
//    
//    NSURL *url = [NSURL URLWithString:endpoint];
//    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//        
//        if (error) {
//            NSLog(@"api call didnt work with %@",countyName);
//            dispatch_semaphore_signal(sema);
//
//        }else {
//            JSONresults = [[NSDictionary alloc]init];
//            JSONresults = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
//            
//            //signil method to returen
//            dispatch_semaphore_signal(sema);
//
//       
//        }
//   
//    }];
//    
//    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
//    
//    return JSONresults;
//
//};//end of GetEvntJSON


-(NSString*)makeInstagramSearch: (NSString*) eventTitle{
    
    //setup insta search query
    NSString *A = eventTitle;
    //remove any white space  //TAKE OUT ANY " OR ' OR ANYTHING THAT PEOPLE WOULDNT NORMALY HASHTAG
    NSString *b = [A stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *c = [b stringByReplacingOccurrencesOfString:@"'" withString:@""];
   
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
    
    //setting event status based on the diffrent in event date&time and now
    if (diff < -4 && diff > -24) {
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
    
    self.thumbNail = [[UIImageView alloc] initWithImage:newimage];
        dispatch_semaphore_signal(sema);

        
//        dispatch_queue_t me = dispatch_get_current_queue();
//        NSString *stringRep = [NSString stringWithFormat:@"%s",dispatch_queue_get_label(me)];
//        NSLog(@"%@",stringRep);
    
    });

    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    return self.thumbNail;

};






@end
