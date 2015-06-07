//
//  EngineRoom.m
//  masterbranch
//
//  Created by james cash on 06/06/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "EngineRoom.h"

@implementation EngineRoom{
    dispatch_queue_t myQueue;
}





-(void) buildEventObjectArray {
    //init objects that will be needed
    self.eventObjects = [[NSMutableArray alloc]init];
    self.todaysObjects = [[NSMutableArray alloc]init];
    eventObject *event = [[eventObject alloc]init];
//    [self.masterArray addObject:self.corkGigs];
//    NSString *stringRep = [NSString stringWithFormat:@"%@",self.masterArray ];
//      NSLog(@"%@",stringRep);


    
    
    for (NSArray *item in self.masterArray) {
        
        for (NSDictionary *object in item) {
            
            
            //for gigs with more then one artist
            NSDictionary *artistdic = object [@"artists"];
            //get the date and compare to determin if the gig happens today
            NSString *objectdate = object [@"datetime"];
           
            //NSLog(@"%@",objectdate);

            NSString *dateformatted = [objectdate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
            // Convert string to date object
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-LL-dd HH-mm-ss"];
            NSDate *eventDate = [dateFormat dateFromString:dateformatted];
            //todays date
            NSDate * now = [NSDate date];
            NSComparisonResult result = [now compare:eventDate];
            
            
            
            //      if(result==NSOrderedAscending)
            //            NSLog(@"today is less");
            //      else if(result==NSOrderedDescending)
            //            NSLog(@"newDate is less");
            //      else
            //           NSLog(@"BOOOOOOOOOOOOOOOOM");
            
            
            
            if (result==NSOrderedDescending) {
                
                
                
                
                  if ([artistdic count] > 1 ) {
                    
                                //gig with multiple performers, while loop and i counter to itterate each sningle artist in returened json event
                    
                                int i = 0;
                                while ( i < [artistdic count] )
                                {
                    
                                    event = [[eventObject alloc]init];
                    
                    
                    
                                    //retreving event title to be the artist name
                                    NSArray *artists = object [@"artists"];
                                    //i counter in the while loop to choose a diffrent artist everytime for the event object
                                    NSDictionary *artistinfo = artists [i];
                                    event.eventTitle = artistinfo[@"name"];
                    
                                    //retreving venue details
                                    NSDictionary *venue = object [@"venue"];
                                    event.venueName = venue [@"name"];
                                    event.LatLong = @{ @"lat" : venue[@"latitude"],
                                                       @"long": venue[@"longitude"]
                                                       };
                    
                                    //retreving event date
                                    event.eventDate = object [@"datetime"];
                    
                                    //setting twitter search query 1
                                    NSMutableString *artistNameHashtag = [[NSMutableString alloc]init];
                                    [artistNameHashtag appendString:@"#"];
                                    NSMutableString *venueHashtag = [[NSMutableString alloc]init];
                                    [venueHashtag appendString:@" #"];
                                    [artistNameHashtag appendString:artistinfo[@"name"]];
                                    [venueHashtag appendString:venue [@"name"]];
                                    // [artistNameHashtag appendString:venueHashtag];
                                    NSString *encodedrequest = [artistNameHashtag stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
                    
                                    event.twitterSearchQuery = encodedrequest;
                                    
                                    
                                    //setup insta search query
                                    NSString *A = event.eventTitle;
                                    //remove any white space  //TAKE OUT ANY " OR ' OR ANYTHING THAT PEOPLE WOULDNT NORMALY HASHTAG
                                    
                                    NSString *b = [A stringByReplacingOccurrencesOfString:@" " withString:@""];
                                    NSString *c = [b stringByReplacingOccurrencesOfString:@"'" withString:@""];
                                    event.InstaSearchQuery = c;
                                    
                                    
                                    [self.todaysObjects addObject:event];
                                    i++;
                           
                                };
                      NSLog(@"multiple artist event ");
                  
                  }else{

                
                
                event = [[eventObject alloc]init];
                event.eventDate = eventDate;
                
                //retreving event title to be the artist name
                NSArray *artists = object [@"artists"];
                
                
                if ([artists count]>0) {
                    NSDictionary *artistinfo = artists [0];
                    event.eventTitle = artistinfo[@"name"];
                } else {
                    event.eventTitle = @"NO EVENT TITLE ****FIX*** ";
                }
                
                
                //retreving venue details
                NSDictionary *venue = object [@"venue"];
                event.venueName = venue [@"name"];
                event.LatLong = @{ @"lat" : venue[@"latitude"],
                                   @"long": venue[@"longitude"]
                                   };
                
                //retreving event date
                event.eventDate = object [@"datetime"];
                
                //setting twitter search query 1
                NSMutableString *artistNameHashtag = [[NSMutableString alloc]init];
                [artistNameHashtag appendString:@"#"];
                NSMutableString *venueHashtag = [[NSMutableString alloc]init];
                [venueHashtag appendString:@" #"];
                // [artistNameHashtag appendString:artistinfo[@"name"]];
                [artistNameHashtag appendString:event.eventTitle];
                [venueHashtag appendString:venue [@"name"]];
                //[artistNameHashtag appendString:venueHashtag];
                NSString *encodedrequest = [artistNameHashtag stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
                
                event.twitterSearchQuery = encodedrequest;
                
                //setup insta search query
                NSString *A = event.eventTitle;
                //remove any white space  //TAKE OUT ANY " OR ' OR ANYTHING THAT PEOPLE WOULDNT NORMALY HASHTAG
                
                NSString *b = [A stringByReplacingOccurrencesOfString:@" " withString:@""];
                NSString *c = [b stringByReplacingOccurrencesOfString:@"'" withString:@""];
                event.InstaSearchQuery = c;
                
                
                [self.todaysObjects addObject:event];
                    NSLog(@"sinlge artist event");
                }
            
            
            }else{
                NSLog(@"wasnt todays date");
            }
            
            
     }
    
}
    
    

    



};

- (void) songKickApiCall:(void(^)(void))testblock {
    
    
    if (!myQueue) {
       myQueue = dispatch_queue_create("com.james.apicalls", NULL);
    }

    
    //had to make a seperate function to buildl master array because the network call was takeing to long
    //a gave this function a completion block to the rest of the code in not called untill master array is built
  
    dispatch_async( myQueue, ^{ [self buildmasterarray:^{ NSLog(@"now were working");}];});

    [NSThread sleepForTimeInterval:1];
    
    [self buildEventObjectArray];
    
    testblock();



}



-(void)buildmasterarray:(void (^)(void))completionBlock {
    
    self.masterArray = [[NSMutableArray alloc]init];
    
    self.galwayGigs = [[NSMutableArray alloc]init];
    
    self.corkGigs = [[NSMutableArray alloc]init];
    
    self.countysInIreland = [[NSArray alloc]init];
    
    self.countysInIreland = @[@"Dublin,Ireland",@"Cork,Ireland",@"Galway,Ireland",@"Belfast,UnitedKingdom",@"Kildare,Ireland"];
    
    
    
    
    
    for (int i = 0; i < [self.countysInIreland count]; i++) {
        
        
        NSString *endpoint = [NSString stringWithFormat:@"http://api.bandsintown.com/events/search.json?api_version=2.0&app_id=YOUR_APP_ID&location=%@",[self.countysInIreland objectAtIndex:i]];
       
        NSURL *url = [NSURL URLWithString:endpoint];
        
        [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            
            
           
            
            if (error) {
                NSLog(@"api call didnt work with %@",self.countysInIreland[i]);
            } else {
                
             //   NSLog(@"%@",self.countysInIreland[i]);
                
               // if ([[self.countysInIreland objectAtIndex:i] isEqual:@"Dublin,Ireland"]){
                  
                    self.upcomingDublinGigs = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                    
                    [self.masterArray addObject:self.upcomingDublinGigs];
                
//                           NSString *stringRep = [NSString stringWithFormat:@"%@",self.masterArray ];
//                           NSLog(@"%@",stringRep);
                
                  }
            
            }
            

//            NSString *stringRep = [NSString stringWithFormat:@"%@",self.upcomingDublinGigs ];
//            NSLog(@"%@",stringRep);
            
        ];
        
    }
  
    completionBlock();
    
  
    

 
}








































@end
