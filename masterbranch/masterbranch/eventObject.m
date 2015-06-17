//
//  eventObject.m
//  Second_Prototype
//
//  Created by james cash on 01/06/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "eventObject.h"

@implementation eventObject{
    
    
    
    //dispatch_queue_t myQueue;
   
};



//- (void) songKickApiCall:(void(^)(void))testblock {
////    if (!myQueue) {
////       myQueue = dispatch_queue_create("com.james.apicalls", NULL);
////    }
////had to make a seperate function to buildl master array because the network call was takeing to long
////a gave this function a completion block so the rest of the code is not called untill master array is built
////dispatch_async( myQueue, ^{ [self buildmasterarray:^{ NSLog(@"now were working");}];});
//
//    [self buildmasterarray:^{ testblock();NSLog(@"COMPLETEION BLOCK");}];
//}
-(void)buildmasterarray:(void (^)(void))completionBlock {

    //self.masterArray = [[NSMutableArray alloc]init];
    self.countysInIreland = [[NSArray alloc]init];
  //  self.happeningLater = [[NSMutableArray alloc]init];
  //  self.currentlyHappening = [[NSMutableArray alloc]init];
  //  self.alreadlyHappened = [[NSMutableArray alloc]init];
    self.allEvents = [[NSMutableArray alloc]init];

    //self.eventObjects = [[NSMutableArray alloc]init];
    self.happeningLater = [[NSMutableArray alloc]init];

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
        // NSLog(@"%@",todaysdate);

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
                                
                                //setup insta search query
                                NSString *A = event.eventTitle;
                                //remove any white space  //TAKE OUT ANY " OR ' OR ANYTHING THAT PEOPLE WOULDNT NORMALY HASHTAG
                                
                                NSString *b = [A stringByReplacingOccurrencesOfString:@" " withString:@""];
                                NSString *c = [b stringByReplacingOccurrencesOfString:@"'" withString:@""];
                                event.InstaSearchQuery = c;


                               
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


                                
                                //for gigs with more then one artist
                                NSString *objectdate = object [@"datetime"];
                                NSString *dateformatted = [objectdate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                                
                                
                                // Convert string to date object
                                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                                [dateFormat setDateFormat:@"yyyy-LL-dd HH:mm:ss"];
                               
                                NSDate *date = [dateFormat dateFromString:dateformatted];
                                NSDate *todaysdate = [NSDate date];
                                NSTimeInterval diff = ([date timeIntervalSinceDate:todaysdate]/60)/60;
                                
                                
                                
                                
                                
                                if (diff < -5 && diff > -24) {
                                    
                                 //[self.alreadlyHappened addObject:event];
                                    event.status = @"alreadyHappened";

                                }else if (diff > 1){
                                
                                //[self.happeningLater addObject:event];
                                    event.status = @"happeningLater";

                                }else {
                                    //[self.currentlyHappening addObject:event];
                                    event.status = @"currentlyhappening";

                                
                                };
                                
                                [self.allEvents addObject:event];
                                
                                    i++;



                            };
                            //NSLog(@"multiple artist event ");

                        }//End of Multie Artist

                        else{


                            event = [[eventObject alloc]init];
                            //event.eventDate = eventDate;
                            //retreving event title to be the artist name
                            NSArray *artists = object [@"artists"];
                            
                            NSString *A = event.eventTitle;
                            NSString *b = [A stringByReplacingOccurrencesOfString:@" " withString:@""];
                            NSString *c = [b stringByReplacingOccurrencesOfString:@"'" withString:@""];
                            event.InstaSearchQuery = c;


                            //check and make sure there is an event title
                            if ([artists count]>0) {
                                NSDictionary *artistinfo = artists [0];
                                event.eventTitle = artistinfo[@"name"];
                            
                            }else {
                                event.eventTitle = @"Some silly goose forgeot to enter event title";
                                event.InstaSearchQuery = @"jesign";
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

                            //for gigs with more then one artist
                            NSString *objectdate = object [@"datetime"];
                            NSString *dateformatted = [objectdate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                            // Convert string to date object
                            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                            [dateFormat setDateFormat:@"yyyy-LL-dd HH:mm:ss"];
                            
                            NSDate *date = [dateFormat dateFromString:dateformatted];
                            NSDate *todaysdate = [NSDate date];
                            NSTimeInterval diff = ([date timeIntervalSinceDate:todaysdate]/60)/60;
                            

                            
                            
                            if (diff < -5 && diff > -24) {
                                
                                //[self.alreadlyHappened addObject:event];
                                event.status = @"alreadyHappened";
                                
                            }else if (diff > 1){
                                
                                //[self.happeningLater addObject:event];
                                event.status = @"happeningLater";

                                
                            }else {
                                //[self.currentlyHappening addObject:event];
                                event.status = @"currentlyhappening";
                             };
                            
                    
                            [self.allEvents addObject:event];


                        }
                    }


                }
                
                //***** add a stronger if statment here to make sure completion block is not called unill loop is finished
                int a = ([self.countysInIreland count]-1 );
                if (x == a) {
                    completionBlock();
                    //NSString *stringRep1 = [NSString stringWithFormat:@"%@",self.happeningLater];
                    //NSLog(@"%@",stringRep1);
//                    NSString *stringRep = [NSString stringWithFormat:@"%@",self.currentlyHappening];
//                    NSLog(@"%@",stringRep);
//                    NSString *stringRep0 = [NSString stringWithFormat:@"%@",self.alreadlyHappened];
//                    NSLog(@"%@",stringRep0);
                
                };


            }//end of outter if/else statment
        }];//end of completion block for api call all events are parsed and ready to go

       // NSLog(@"%d",x);
        x = x+1;



    }//end of while loop
    
 

}//end of build master array loop

-(NSString*)getArtistInfoByName:(NSString*)artistname completionBolock:(void(^)(void))completionBlock{
    
    
    
    NSString *endpoint = [NSString stringWithFormat:@"http://api.bandsintown.com/artists/%@.json?api_version=2.0&app_id=YOUR_APP_ID",artistname];
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
                    
                    self.imageUrl = jsonData [@"image_url"];
                }
                
            }
        }
    }];
    NSLog(@"%@ coming from the artist info class",self.imageUrl);
    completionBlock();
    return self.imageUrl;
};


-(NSString*)getArtistInfoByMbidNumuber:(NSString *)mbidNumber completionBolock:(void (^)(void))completionBlock{
    
    
    
    NSString *endpoint = [NSString stringWithFormat:@"http://api.bandsintown.com/artists/mbid_%@?format=json&api_version=2.0&app_id=YOUR_APP_ID",mbidNumber];
    
    
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
                
                
                self.imageUrl = jsonData[@"image_url"];
                
                
                completionBlock();
                
                //self.imageUrl = jsonData[@"image_url"];
                //NSLog(@"%@",returnString);
            }
        }
        
    }];
    
    // NSLog(@"%@",returnString);
    
    
    //NSLog(@"%@ coming from the artist info class",self.imageUrl);
    return self.imageUrl;
    
};





@end
