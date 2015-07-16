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
    dispatch_queue_t yesterdaysEvents;
    NSDictionary *JSONresults;
    BOOL todaysEventsFinishedParsing;
    BOOL yesterdaysEventsFinishedParsing;
    int y;
    int x;


};



-(void)buildmasterarray:(void (^)(void))completionBlock {

    self.countysInIreland = [[NSArray alloc]init];
   
    self.allEvents = [[NSMutableArray alloc]init];
    
   todaysEventsFinishedParsing = NO;
   yesterdaysEventsFinishedParsing = NO;
    

    self.countysInIreland = @[@"Dublin,Ireland",@"Cork,Ireland",@"Galway,Ireland",@"Belfast,United+Kingdom",@"Kildare,Ireland",@"Carlow,Ireland",@"Kilkenny,Ireland",
                              @"Donegal,Ireland",@"Mayo,Ireland",@"Sligo,Ireland",@"Derry,Ireland",@"Cavan,Ireland",@"Leitrim,Ireland",@"Monaghan,Ireland"
                              ,@"Louth,Ireland",@"Roscommon,Ireland",@"Longford,Ireland",@"Claregalway,Ireland",@"Tipperary,Ireland",@"Limerick,Ireland",@"Wexford,Ireland",@"Waterford,Ireland",@"Kerrykeel,Ireland"];
    
    
    EventObjectParser *pasre = [[EventObjectParser alloc]init];
    
    
    NSDate *now = [NSDate date];
    NSString *todaysDate = [pasre formatDateForAPIcall:now];
    NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow: -(60.0f*60.0f*24.0f)];
    NSString *yesterdaysDate = [pasre formatDateForAPIcall:yesterday];

    if (!todaysEvents) {
        todaysEvents = dispatch_queue_create("APIcall.bandsintown.todaysevents", NULL);
    }
    
    if (!yesterdaysEvents) {
        yesterdaysEvents = dispatch_queue_create("APIcall.bandsintown.yesterdays", NULL);
    }
    
//put the method that finds all the events that happened today onto its own queue
dispatch_async(todaysEvents, ^{
        
           y = 0;
    int a = [self.countysInIreland count];

    
     for (NSString *countyName in self.countysInIreland) {
        
     [self GetEventJSON:countyName dateObject:todaysDate];
         //NSLog(@"y is equal to %d",y);
         //NSLog(@"%i", todaysEventsFinishedParsing);

         y++;

      
     
         if (y == a ) {
             todaysEventsFinishedParsing = YES;
         };
         
         if ( (x==a)&&(y==a) ) {
             completionBlock();
             NSLog(@"completion block called");
         }
     
     
     }
        
    
        
 
        
});
       
    
    //put the method that finds all the events that happened yesterday onto its own queue
    dispatch_async(yesterdaysEvents, ^{
          
           x = 0;
        //int a = [self.countysInIreland count];


        
            for (NSString *countyName in self.countysInIreland) {
            
            [self GetEventJSON:countyName dateObject:yesterdaysDate];
                //NSLog(@"x is equal to %d",x);
                //NSLog(@"%i", yesterdaysEventsFinishedParsing);
                //NSLog(@"%d",[self.countysInIreland count]);
                int a = [self.countysInIreland count];
                x++;

                
                if (x == a) {
                    yesterdaysEventsFinishedParsing = YES;
                    //completionBlock();

                   };
            
                if ( (x==a)&&(y==a) ) {
                    completionBlock();
                    NSLog(@"completion block called");

                }
            
            
            }
        
 });


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
                    NSLog(@"unkown artist picture %@",error);
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
            NSLog(@"JSON error mbid number didnt work");
            dispatch_semaphore_signal(sema);


        }else {
            
            
            NSDictionary *jsonData = [[NSDictionary alloc]init];
            jsonData  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            
            if ([jsonData count]== 0 ) {
                NSLog(@"No info for that artist via mbid api call");
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
    
    //dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
//    
  

    EventObjectParser *pasre = [[EventObjectParser alloc]init];
    //for eveny object in the dictionary self.jsonData parse it in this way
    for (NSDictionary *object in JSONresult) {
        eventObject *event = [[eventObject alloc]init];
        
        NSDictionary *artistdic = object [@"artists"];
        NSArray *artists = object [@"artists"];
        NSDictionary *venue = object [@"venue"];
        
        
        
        //if it has one or more artist parse into concert
        //while loop and i counter to itterate each sningle artist in returened json event
        if ([artistdic count] > 1 ) {
            
            event.eventType = @"concert";
            event.eventTitle = venue [@"name"];
            
            
            int i = 0;
            while ( i < [artistdic count] ){
                NSDictionary *artistinfo = artists [i];
                event.artistNames = [[NSMutableArray alloc]init];
                [event.artistNames addObject:artistinfo[@"name"]];
                //NSLog(@"%@",event.artistNames);
                i++;
            }
            
        }else{
            event.eventType = @"single";
            NSArray *artists = object [@"artists"];
            
            if ([artists count]>0) {
                NSDictionary *artistinfo = artists [0];
                event.eventTitle = artistinfo[@"name"];
            
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
        
        
        event.venueName = venue [@"name"];
        event.InstaSearchQuery = [pasre makeInstagramSearch:event.eventTitle];
        
        
       //NSDictionary *artistinfo = artists [0];
        
        
        
        
        
        event.LatLong = @{ @"lat" : venue[@"latitude"],
                           @"long": venue[@"longitude"]
                           };
        
        event.eventDate = object [@"datetime"];
        event.twitterSearchQuery = [pasre makeTitterSearch:event.eventTitle venueName:event.venueName];
        event.status = [pasre GetEventStatus:object [@"datetime"]];
       
        //NSLog(@"%@",object);
        
        [self.allEvents addObject:event];
        
        //NSLog(@"%d %@ %@",[self.allEvents count],event.eventTitle,event.venueName);
        
    };//end of JSON parsing loop






};



-(void)GetEventJSON: (NSString*)countyName dateObject:(NSString*)date {
    
    //creat semaphore to signle when asynch API request is finished
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    
    
    
    
    
    //connet to the BandsinTown API get all events from the area on todays date
    NSString *endpoint = [NSString stringWithFormat:@"http://api.bandsintown.com/events/search.json?api_version=2.0&app_id=preamp&date=%@,%@&location=%@",date,date,countyName];
    
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

            if ([JSONresults count]== 0 ) {
                
                NSLog(@"there was no events in %@ today %@",countyName,date);

            }
            else {
                
               // NSLog(@"JSON result wit %d getting packaged for county %@ %@",[JSONresults count],countyName,date);
                [self praseJSONresult:JSONresults];
                
                

            }

            
            
    
    
    
    //return JSONresults;
    
};//end of GetEvntJSON







@end
