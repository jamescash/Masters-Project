//
//  eventObject.m
//  Second_Prototype
//
//  Created by james cash on 01/06/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "eventObject.h"

@implementation eventObject{
    
    dispatch_queue_t todaysEvents;
    //dispatch_queue_t yesterdaysEvents;
    NSDictionary *JSONresults;
    BOOL todaysEventsFinishedParsing;
    BOOL yesterdaysEventsFinishedParsing;
    int y;
    int x;
    NSDictionary *coutyandsearchNumber;


};



-(void)buildmasterarray:(void (^)(void))completionBlock {

    //self.countysInIreland = [[NSDictionary alloc]init];
   
    self.allEvents = [[NSMutableArray alloc]init];
    
   todaysEventsFinishedParsing = NO;
   yesterdaysEventsFinishedParsing = NO;
    
    self.countysInIreland = [[NSDictionary alloc]init];
    
    self.countysInIreland = @{@"Antrim":@"24523",
                             @"Armagh":@"54835",
                             @"Carlow":@"57481",
                             @"Cavan":@"29314",
                             @"Clare":@"66811",
                             @"Cork":@"29313",
                             @"Derry":@"24606",
                             @"Donegal":@"66861",
                             @"Down":@"24523",
                             @"Dublin":@"29314",
                             //@"Fermanagh":@"00000000" ,
                             @"Galway":@"29315",
                             @"Kerry":@"26785",
                             @"Kildare":@"56323",
                             @"County Kildare":@"55793",
                             @"Kilkenny":@"35481",
                             @"Laois":@"67086",
                             @"Leitrim":@"67011",
                             @"Limerick":@"29316",
                             @"Longford":@"66986",
                             @"Louth":@"66991",
                             @"Mayo":@"67021",
                             @"Meath":@"29314",
                             @"Monaghan":@"57674",
                             //@"Offaly":@"00000000000",
                             @"Roscommon":@"67121",
                             @"Sligo":@"36055",
                             @"Tipperary":@"35085",
                             //@"Tyrone":@"00000000000",
                             @"Waterford":@"35762",
                             //@"Westmeath":@"00000000000",
                             @"Wexford":@"67206",
                             @"Wicklow":@"67211"};
    
    EventObjectParser *pasre = [[EventObjectParser alloc]init];
    
    
    NSDate *now = [NSDate date];
    NSString *todaysDate = [pasre formatDateForAPIcall:now];
    //NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow: -(60.0f*60.0f*24.0f)];
    //NSString *yesterdaysDate = [pasre formatDateForAPIcall:yesterday];

    if (!todaysEvents) {
        todaysEvents = dispatch_queue_create("APIcall.bandsintown.todaysevents", NULL);
    }
    
//    if (!yesterdaysEvents) {
//        yesterdaysEvents = dispatch_queue_create("APIcall.bandsintown.yesterdays", NULL);
//    }
    
//put the method that finds all the events that happened today onto its own queue
dispatch_async(todaysEvents, ^{
        
    
           y = 0;
    NSUInteger a = [self.countysInIreland count];
    

    for (id countyName in self.countysInIreland) {
        

        
       [self GetEventJSON:[self.countysInIreland objectForKey:countyName]];

        y++;

      
     
         if (y == a ) {
             todaysEventsFinishedParsing = YES;
             NSLog(@"completion block call next");
             completionBlock();
         };
         
//         if ( (x==a)&&(y==a) ) {
//             NSLog(@"completion block called");
//         }
     
     
     }
        
    
        
 
        
});
       
    
//    //put the method that finds all the events that happened yesterday onto its own queue
//    dispatch_async(yesterdaysEvents, ^{
//          
//           x = 0;
//        //int a = [self.countysInIreland count];
//
//
//        
//            for (NSString *countyName in self.countysInIreland) {
//            
//            [self GetEventJSON:countyName dateObject:yesterdaysDate];
//                //NSLog(@"x is equal to %d",x);
//                //NSLog(@"%i", yesterdaysEventsFinishedParsing);
//                //NSLog(@"%d",[self.countysInIreland count]);
//                int a = [self.countysInIreland count];
//                x++;
//
//                
//                if (x == a) {
//                    yesterdaysEventsFinishedParsing = YES;
//                    //completionBlock();
//
//                   };
//            
//                if ( (x==a)&&(y==a) ) {
//                    completionBlock();
//                    NSLog(@"completion block called");
//
//                }
//            
//            
//            }
//        
// });


};




//this method is called to get more artist info ie.cover picutre URL of a paticular artist
-(UIImageView*)getArtistInfoByName:(NSString*)artistname{
   
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    EventObjectParser *parser = [[EventObjectParser alloc]init];


    
    //conect to the endpoint with the artist name and get artist JSON
    NSString *endpoint = [NSString stringWithFormat:@"http://api.bandsintown.com/artists/%@.json?api_version=2.0&app_id=YOUR_APP_ID",artistname];
    NSURL *url = [NSURL URLWithString:endpoint];
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
       
        if (error) {
            NSLog(@"JSON ERROR adding coverpicture URL artsit search with name");
            dispatch_semaphore_signal(sema);




        }else {
            
            NSDictionary *jsonData = [[NSDictionary alloc]init];
            jsonData  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            
            if ([jsonData count]== 0 ) {
                NSLog(@"No info for that artist seched by name");
                dispatch_semaphore_signal(sema);

              
            }
            else {
                
                //if unknown artist object comes back form API call do this
                if (jsonData[@"errors"]) {
                    NSString *error = jsonData[@"errors"];
                    NSLog(@"%@",error);
                    dispatch_semaphore_signal(sema);


                }else{
                    //NSString *coverpicURL;
                    self.imageUrl = jsonData [@"thumb_url"];
                    dispatch_semaphore_signal(sema);

                    
                }
                
            }
        }
    }];

    
    
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
   
    
    
    NSString *pictureurl =self.imageUrl;
    
    NSURL *pic = [NSURL URLWithString:pictureurl];
    
    NSData *data = [NSData dataWithContentsOfURL:pic];
    
    
    return [parser makeThumbNail:data];

    
    
    
};

//work the same as the above method exept it just searchs by MBID number
-(UIImageView*)getArtistInfoByMbidNumuber:(NSString *)mbidNumber{
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    EventObjectParser *parser = [[EventObjectParser alloc]init];

    
    
    NSString *endpoint = [NSString stringWithFormat:@"http://api.bandsintown.com/artists/mbid_%@?format=json&api_version=2.0&app_id=YOUR_APP_ID",mbidNumber];
    NSURL *url = [NSURL URLWithString:endpoint];
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            NSLog(@" JSON error mbid number didnt work");
            NSLog(@"event added bad" );
            dispatch_semaphore_signal(sema);


        }else {
            
            
            NSDictionary *jsonData = [[NSDictionary alloc]init];
            jsonData  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            
            if ([jsonData count]== 0 ) {
                NSLog(@"No info for that artist via mbid api call");
                NSLog(@"event added bad" );
                dispatch_semaphore_signal(sema);




            }
            else {
                
                
                self.imageUrl = jsonData [@"thumb_url"];
                
                dispatch_semaphore_signal(sema);

             }
        }
        
    }];
    
    
    
  
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    NSString *pictureurl =self.imageUrl;
    
    NSURL *pic = [NSURL URLWithString:pictureurl];
    NSData *data = [NSData dataWithContentsOfURL:pic];
    return [parser makeThumbNail:data];


};




//parsing the Raw JSON results from bandsintwonAPI call
-(void)praseJSONresult: (NSDictionary*)JSONresult{
    
  
  

   // EventObjectParser *pasre = [[EventObjectParser alloc]init];
    //for eveny object in the dictionary self.jsonData parse it in this way
    
    
      //NSString *results = JSONresult [@"totalEntries"];

  
    
    
    EventObjectParser *pasre = [[EventObjectParser alloc]init];
    NSDate *now = [NSDate date];
    NSString *todaysDate = [pasre formatDateForAPIcall:now];
    
    
//
   for (NSDictionary *object in JSONresult) {
       
       
       //hammer down to the results
       NSDictionary *resultsPage = JSONresult [@"resultsPage"];
       NSDictionary *results = resultsPage [@"results"];
       NSArray *eventArray = results[@"event"];
 
       //see if there are any upcoming events
    if ([results count] > 0) {
    
//        NSLog(@"there are no upcoming events here %d",[results count] );
//        NSLog(@"%@",results);
//        
//     }else{
    
         for (NSDictionary *eventobj in eventArray) {
            
             NSDictionary *start = eventobj [@"start"];
             NSString *eventDate = start[@"date"];
             NSArray *artistdic = eventobj[@"performance"];
             NSDictionary *venue = eventobj [@"venue"];

             
             if ([todaysDate isEqualToString:eventDate]) {
                
                 eventObject *event = [[eventObject alloc]init];
                         //if it has one or more artist parse into concert
                         //while loop and i counter to itterate each sningle artist in returened json event
                         if ([artistdic count] > 1 ) {
                 
                             event.eventTitle = eventobj[@"displayName"];
                 
                 
                             int i = 0;
                             while ( i < [artistdic count] ){
                                 NSDictionary *artistinfo = artistdic[i];
                                 event.artistNames = [[NSMutableArray alloc]init];
                                 [event.artistNames addObject:artistinfo[@"displayName"]];
                                 //NSLog(@"%@",event.artistNames);
                                 i++;
                             }
                 
                         }else{
                 
                             if ([artistdic count]>0) {
                                 NSDictionary *artistinfo = artistdic [0];
                                 event.eventTitle = artistinfo[@"displayName"];
                 
                                 if (artistinfo[@"mbid"] == (id)[NSNull null]) {
                                     event.mbidNumber = @"empty";
                                 }else{
                                     event.mbidNumber = artistinfo[@"mbid"];
                                 };
                             
                             }
                             
                             
                             else {
                                 event.eventTitle = @"Some silly goose forgeot to enter event title";
                                 event.InstaSearchQuery = @"error";
                                 event.mbidNumber = @"empty";
                             }
                             
                         }
             
                         event.eventType = eventobj[@"type"];
                         event.venueName = venue [@"displayName"];
                         event.InstaSearchQuery = [pasre makeInstagramSearch:event.eventTitle];
                 
                 
                         event.LatLong = @{ @"lat" : venue[@"lat"],
                                            @"long": venue[@"lng"]
                                            };
                 
                         event.eventDate = start[@"date"];
                         event.twitterSearchQuery = [pasre makeTitterSearch:event.eventTitle venueName:event.venueName];
                         //event.status = [pasre GetEventStatus:object [@"datetime"]];
                         
                         
                         
                 
                        
                         
                         [self.allEvents addObject:event];
             
             
             
             
             }else{
                 
                 //that event was not on todays date
                 //NSLog(@"%@",eventDate);
             };
             
             
             
         };//end of inner loop for event array
       
    }//end of if no events else events statmen
        
    };//end of JSON parsing loop






};



-(void)GetEventJSON: (NSString*)countyName {
    
    //creat semaphore to signle when asynch API request is finished
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    
    
    
    
    
    //connet to the songkick API get all events from the area on todays date
    NSString *endpoint = [NSString stringWithFormat:@"http://api.songkick.com/api/3.0/metro_areas/%@/calendar.json?apikey=Tbr0JJzi5KzsT4Z6",countyName];
    
    NSURL *url = [NSURL URLWithString:endpoint];
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            NSLog(@"api call didnt work with %@",error);
            //dispatch_semaphore_signal(sema);
            
        }else {
            JSONresults = [[NSDictionary alloc]init];
            JSONresults = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            //NSString *stringRep = [NSString stringWithFormat:@"%@",JSONresults];
            //NSLog(@"%@",stringRep);
            dispatch_semaphore_signal(sema);

            
        }
        
    }];
    
    
       dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);

           // if ([JSONresults[@"totalEntries"] isEqualToString:@"0"] ) {
                
           //     NSLog(@"there was no events in %@ today",countyName);
//
           // }
    
    
           // else {
                
                
               // NSLog(@"JSON result wit %d getting packaged for county %@ %@",[JSONresults count],countyName,date);
                [self praseJSONresult:JSONresults];
               // NSDictionary *results = JSONresults[@"results"];
             
                

            //}

            
            
    
    
    
    //return JSONresults;
    
};//end of GetEvntJSON







@end
