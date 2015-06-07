//
//  EngineRoom.m
//  masterbranch
//
//  Created by james cash on 06/06/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "EngineRoom.h"

@implementation EngineRoom


-(void) buildEventObjectArray {
    
    self.eventObjects = [[NSMutableArray alloc]init];
    self.todaysObjects = [[NSMutableArray alloc]init];
    
    eventObject *event = [[eventObject alloc]init];
    
    
    for (NSDictionary *object in self.upcomingDublinGigs) {
        
        
        NSDictionary *artistdic = object [@"artists"];
        
        //for gigs with more then one artist
        NSString *objectdate = object [@"datetime"];
        NSString *dateformatted = [objectdate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        
        // Convert string to date object
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-LL-dd HH:mm:ss "];
        NSDate *date = [dateFormat dateFromString:dateformatted];
        
//            NSString *stringRep = [NSString stringWithFormat:@"%@", date];
//            NSLog(@"%@",stringRep);
        
        //todays date
        NSDate * now = [NSDate date];
        
        
        NSComparisonResult result = [now compare:date];
      
//        if(result==NSOrderedAscending)
//            NSLog(@"today is less");
//        else if(result==NSOrderedDescending)
//            NSLog(@"newDate is less");
//        else
//            NSLog(@"BOOOOOOOOOOOOOOOOM");
        
        
        
        if (result==NSOrderedDescending) {
            //int i = 0;
            //NSLog(@"newDate is less");
            //gigs with only one act
            // NSLog(@"this shit is fucked up");
            event = [[eventObject alloc]init];
            event.eventDate = date;
            
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
            
            //self.i++;
            
            [self.todaysObjects addObject:event];
       
        
        }
        
        else if ([artistdic count] > 1 ) {
            
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
                
                
                [self.eventObjects addObject:event];
                i++;
                
                
            };
        }
        
        
        //for gigs with one artist
        else {
            
            
            
            //int i = 0;
            //gigs with only one act
            // NSLog(@"this shit is fucked up");
            event = [[eventObject alloc]init];
            
            
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
            
            //self.i++;
            
            [self.eventObjects addObject:event];
            
            
            
            
            
        }
     
        
        
    };
    



};

- (void) songKickApiCall:(void(^)(void))testblock {
    
    NSURL *url = [NSURL URLWithString:@"http://api.bandsintown.com/events/search.json?api_version=2.0&app_id=YOUR_APP_ID&location=Dublin,Ireland"];
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            NSLog(@"error");
        } else {
            
        
    self.upcomingDublinGigs = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            
            
            
            
            //go bild event objects befour the block testblock is call so all the arrarys are full befour the code moves on
            [self buildEventObjectArray];
            //testblock call fuctions in the mapview classs
            testblock();
            
            
        }
    }];
}

@end
