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


//make sure this class is a sinleton
+ (EventObjectParser*)sharedInstance
{
    // 1
    static EventObjectParser *_sharedInstance = nil;
    
    // 2
    static dispatch_once_t oncePredicate;
    
    //Use Grand Central Dispatch (GCD) to execute a block which initializes an instance of LibraryAPI. This is the essence of the Singleton design pattern: the initializer is never called again once the class has been instantiated.
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[EventObjectParser alloc] init];
    });
    return _sharedInstance;
}



-(NSString*)formatDateForAPIcall:(NSDate*)date{

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    [dateFormat setDateFormat:@"yyyy-LL-dd"];
    
    NSString *formattedDate = [dateFormat stringFromDate:date];

    return formattedDate;
};//end of formatDateForAPIcall



-(NSString*)getUnixTimeStamp:(NSString*)date{
    //identifying when the gig happened
    NSString *objectdate = date;
    NSString *dateformatted = [objectdate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-LL-dd HH:mm:ss"];
    
    //TODO crash caused here EXC_BAD_ACCESS
    NSDate *returndate = [dateFormat dateFromString:dateformatted];
    
    // NSDate *UNIX = [[NSDate alloc]init]
    //int timestamp = [[NSDate date] timeIntervalSince1970];
   
    NSTimeInterval ti = [returndate timeIntervalSince1970];

    
    NSString *UnixTimeStamp = [NSString stringWithFormat:@"%f",ti];
    //NSLog(@"%@",UnixTimeStamp);
    //NSLog(@"unix time stamp is %f",ti);
    
    return UnixTimeStamp;
};//end of formatDateForAPIcall



-(NSString*)makeInstagramSearch: (NSString*) eventTitle{
    
    //setup insta search query
    NSString *A = eventTitle;
    //remove any white space  //TAKE OUT ANY " OR ' OR ANYTHING THAT PEOPLE WOULDNT NORMALY HASHTAG
    NSString *b = [A stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *c = [b stringByReplacingOccurrencesOfString:@"'" withString:@""];
    NSString *d = [c stringByReplacingOccurrencesOfString:@"!" withString:@""];
    //NSLog(@"%@",c);
    return d;

};//end of insta search query maker


-(NSString*)makeTitterSearch: (NSString*) eventTitle venueName:(NSString*)venueName eventStartDate:(NSString *)eventDate{
    
    //prepare title
    NSString *a = eventTitle;
    NSString *c = [a stringByReplacingOccurrencesOfString:@"'" withString:@""];
    NSString *d = [c stringByReplacingOccurrencesOfString:@"!" withString:@""];
   
  //  NSString *artistNameEncodedRequest = [d stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
//    
//    
//    //prepare the date
//    //NSString *objectdate = eventDate;
//    
//    
//    //identifying when the gig happened
//    NSString *objectdate = eventDate;
//    NSString *dateformatted = [objectdate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
//    
//    // Convert string to date object
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    [dateFormat setDateFormat:@"yyyy-LL-dd HH:mm:ss"];
//    NSDate *date = [dateFormat dateFromString:dateformatted];
//    NSDateFormatter *secondFormatter = [[NSDateFormatter alloc]init];
//    [secondFormatter setDateFormat:@"yyyy-LL-dd"];
//   //NSDate *finishedDate = [secondFormatter
//    
//    
//    //trying to format date for twittr search query not having any luck at all
//    
//    NSString *stringdate = [dateFormat stringFromDate:date]; // Convert date to string
//    
//    
//    
//    NSString *twittweSearchQuery = [NSString stringWithFormat:@"%@ since:%@",d,stringdate];
//    
//    NSLog(@"%@",twittweSearchQuery);
    
    //NSString *VenueNameEncodedRequest = [venueWithSpace stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    
   // NSString *encodedSearchForTwitter = [NSString stringWithFormat:@"%@%@",artistNameEncodedRequest,VenueNameEncodedRequest];
    
    //NSLog(@"%@ twitter search query",d);
    //NSLog(@"%@ event title",eventTitle);
    
    //NSString *testSearchQery = @"food since:2015-08-04 ";
    
    //return artistNameEncodedRequest;
    return d;
    
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
        
        //return @"happeningLater";

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


-(int)DistanceFromIreland:(CLLocation*)eventLocation{
    
    
   
    

    
    NSString *Irelandslatitude = @"53.346452";
    NSString *IrelandsLong = @"-7.844238";
    
    CLLocation *ireland = [[CLLocation alloc] initWithLatitude:[Irelandslatitude doubleValue] longitude:[IrelandsLong doubleValue]];

    
    CLLocationDistance meters = [eventLocation distanceFromLocation:ireland];
    
    //NSLog(@"%f",meters/1000);
    
    
    
     // 53.0000° N, 8.0000° W
    
    //CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    

//     [geocoder reverseGeocodeLocation:eventLocation // You can pass aLocation here instead
//                   completionHandler:^(NSArray *placemarks, NSError *error) {
//                       
//                       dispatch_async(dispatch_get_main_queue(),^ {
//                           // do stuff with placemarks on the main thread
//                           
//                           if (placemarks.count == 1) {
//                               
//                               CLPlacemark *place = [placemarks objectAtIndex:0];
//                               
//                               NSString *country = place.country;
//                               
//                               NSLog(@"%@",country);
//                               
//                              // NSLog(@"placemarker Full %@",placemarks);
//                               
//                              // NSString *zipString = [place.addressDictionary valueForKey:@"ZIP"];
//                               
//                               //[self performSelectorInBackground:@selector(showWeatherFor:) withObject:zipString];
//                               
//                           }
//                           
//                       });
//                       
//                   }];
    
    int KM = meters/1000;
    
    
    return KM;
};





@end
