
//
//  EngineRoom.m
//  masterbranch
//
//  Created by james cash on 06/06/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "EngineRoom.h"

@implementation EngineRoom//{
    //dispatch_queue_t myQueue;
//}



- (void) songKickApiCall:(void(^)(void))testblock {
    
    
//    if (!myQueue) {
//       myQueue = dispatch_queue_create("com.james.apicalls", NULL);
//    }

    
    //had to make a seperate function to buildl master array because the network call was takeing to long
    //a gave this function a completion block to the rest of the code in not called untill master array is built
  
    //dispatch_async( myQueue, ^{ [self buildmasterarray:^{ NSLog(@"now were working");}];});
    
    [self buildmasterarray:^{ testblock();NSLog(@"COMPLETEION BLOCK");}];

  
}



-(void)buildmasterarray:(void (^)(void))completionBlock {
    
    //self.masterArray = [[NSMutableArray alloc]init];
    
    self.countysInIreland = [[NSArray alloc]init];
    
    //self.eventObjects = [[NSMutableArray alloc]init];
    self.todaysObjects = [[NSMutableArray alloc]init];
    
    self.countysInIreland = @[@"Dublin,Ireland",@"Cork,Ireland",@"Galway,Ireland",@"Belfast,United+Kingdom",@"Kildare,Ireland",@"Carlow,Ireland",@"Kilkenny,Ireland",
                              @"Donegal,Ireland",@"Mayo,Ireland",@"Sligo,Ireland",@"Derry,Ireland",@"Cavan,Ireland",@"Leitrim,Ireland",@"Monaghan,Ireland"
                              ,@"Louth,Ireland",@"Roscommon,Ireland",@"Longford,Ireland",@"Claregalway,Ireland",@"Tipperary,Ireland",@"Limerick,Ireland",@"Wexford,Ireland",@"Waterford,Ireland",@"Kerrykeel,Ireland"];
   int x = 0;
    while (x < [self.countysInIreland count]) {
     //for (int x = 0; x<[self.countysInIreland count]; x++) {
     //NSLog(@"%@",self.countysInIreland[i]);
     NSDate * now = [NSDate date];
     NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
     [dateFormat setDateFormat:@"yyyy-LL-dd"];
     NSString *todaysdate = [dateFormat stringFromDate:now];
        
       
        NSString *endpoint = [NSString stringWithFormat:@"http://api.bandsintown.com/events/search.json?api_version=2.0&app_id=YOUR_APP_ID&date=%@,%@&location=%@",todaysdate,todaysdate,[self.countysInIreland objectAtIndex:x]];
       NSURL *url = [NSURL URLWithString:endpoint];
       [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            
        if (error) {
                NSLog(@"api call didnt work with %@",self.countysInIreland[x]);
            }else {
                
                
                self.jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];

                if ([self.jsonData count]== 0 ) {
                  //NSLog(@"there was no events in %@ today",self.countysInIreland[x]);
                }
                else {
                
                  
                    
                    for (NSDictionary *object in self.jsonData) {
                    eventObject *event = [[eventObject alloc]init];
                     
                    NSDictionary *artistdic = object [@"artists"];
               
                        
                     if ([artistdic count] > 1 ) {
                     //gig with multiple performers, while loop and i counter to itterate each sningle artist in returened json event
                            
                            int i = 0;
                            while ( i < [artistdic count] ){
                                //NEED TO ALOW MULIT ARTIST IN THE COVER PICTURE AREA
                                
                                event = [[eventObject alloc]init];

                                //retreving event title to be the artist name
                                NSArray *artists = object [@"artists"];
                                //i counter in the while loop to choose a diffrent artist everytime for the event object
                                NSDictionary *artistinfo = artists [i];
                                event.eventTitle = artistinfo[@"name"];
                                
                                

                                
                                    if (artistinfo[@"mbid"] == (id)[NSNull null]) {
                                        event.mbidNumber = @"empty";
                                
                                         }else{
                                        event.mbidNumber = artistinfo[@"mbid"];
                                        };
                                
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
                                
                                
                                
                                
                                [self getartistpicture:event];

                                
                                
                                
                                [self.todaysObjects addObject:event];
                                i++;
                                
                               // NSString *stringRep = [NSString stringWithFormat:@"%@",event.coverpictureURL];
                               // NSLog(@"%@",stringRep);
                            
                            
                            };
                            //NSLog(@"multiple artist event ");
                            
                        }
                    
                        else{
                            
                            
                            event = [[eventObject alloc]init];
                            //event.eventDate = eventDate;
                            //retreving event title to be the artist name
                            NSArray *artists = object [@"artists"];
                         
                            
                            //check and make sure there is an event title
                            if ([artists count]>0) {
                                NSDictionary *artistinfo = artists [0];
                                event.eventTitle = artistinfo[@"name"];

                                
                                    if (artistinfo[@"mbid"] == (id)[NSNull null]) {
                                     event.mbidNumber = @"empty";
                                    }else{
                                    event.mbidNumber = artistinfo[@"mbid"];
                                    };
                             
                            }else {
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
                            
                            
                            [self getartistpicture:event];

                            
                            
                            [self.todaysObjects addObject:event];
                            //NSLog(@"sinlge artist event");
                        
                           // NSString *stringRep = [NSString stringWithFormat:@"%@",event.coverpictureURL];
                           // NSLog(@"%@",stringRep);
                        
                        
                        }
                    }
                   
               
                }
                //***** add a stronger if statment here to make sure completion block is not called unill loop is finished
                int a = ([self.countysInIreland count]-1 );
                if (x == a) {
                    completionBlock();
                };
                
               
            }//end of outter if/else statment
        }];//end of completion block for api call all events are parsed and ready to go
     
       // NSLog(@"%d",x);
        x = x+1;
        

    
    }//end of while loop
}//end of build master array loop


-(void) getartistpicture:(eventObject*)currentEvent{
    
//    NSString *stringRep = [NSString stringWithFormat:@"%@",currentEvent.mbidNumber];
//    NSLog(@"%@",stringRep);
    
    NSString *empty = @"empty";
    
    if (currentEvent.mbidNumber == empty) {
        
         NSString *endpoint = [NSString stringWithFormat:@"http://api.bandsintown.com/artists/%@.json?api_version=2.0&app_id=YOUR_APP_ID",currentEvent.InstaSearchQuery];
         NSURL *url = [NSURL URLWithString:endpoint];
        [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            
            if (error) {
                NSLog(@"JSON ERROR api artist serch by name for image");
            }else {
                
                
                NSDictionary *jsonData = [[NSDictionary alloc]init];
                jsonData  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                
                if ([jsonData count]== 0 ) {
                    NSLog(@"No info for that artist seched by name");
                }
                else {
                    
                    
                    if (jsonData[@"errors"]) {
                        NSString *error = jsonData[@"errors"];
                        NSLog(@"%@",error);
                    
                    }else{
                        NSString *imageurl = jsonData [@"image_url"];
                       // NSString *stringRep = [NSString stringWithFormat:@"%@",jsonData];
                      //NSLog(@"%@",stringRep);
                       // NSLog(@"%@",imageurl);
                       // NSLog(@"%@",currentEvent.eventTitle);
                    
                        currentEvent.coverpictureURL = imageurl;
                    }
                    
                }
             }
          }];

    
    }else {
    
    
    
        
        NSString *endpoint = [NSString stringWithFormat:@"http://api.bandsintown.com/artists/mbid_%@?format=json&api_version=2.0&app_id=YOUR_APP_ID",currentEvent.mbidNumber];
        
        
        NSURL *url = [NSURL URLWithString:endpoint];
        [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            
            if (error) {
                NSLog(@" JSON error mbid number didnt work");
            }else {
                
                
                NSDictionary *jsonData = [[NSDictionary alloc]init];
                jsonData  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                
                if ([jsonData count]== 0 ) {
                    NSLog(@"No info for that artist via mbid api call");
                }
                else {
                   // NSLog(@"MBID number worked but gave back null object");
                    
                                        //   NSString *stringRep = [NSString stringWithFormat:@"%@",jsonData[@"image_url"]];
                                      //  NSLog(@"%@",stringRep);
                    currentEvent.coverpictureURL = jsonData[@"image_url"];

                    
                }
                
            }
         }];
    }
  //  NSString *stringRep = [NSString stringWithFormat:@"%@",artistName];
  //  NSLog(@"%@",stringRep);
}//end of method call
     






























@end
