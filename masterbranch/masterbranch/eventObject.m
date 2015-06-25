//
//  eventObject.m
//  Second_Prototype
//
//  Created by james cash on 01/06/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "eventObject.h"

@implementation eventObject



-(void)buildmasterarray:(void (^)(void))completionBlock {

    self.countysInIreland = [[NSArray alloc]init];
   
    self.allEvents = [[NSMutableArray alloc]init];

    self.countysInIreland = @[@"Dublin,Ireland",@"Cork,Ireland",@"Galway,Ireland",@"Belfast,United+Kingdom",@"Kildare,Ireland",@"Carlow,Ireland",@"Kilkenny,Ireland",
                              @"Donegal,Ireland",@"Mayo,Ireland",@"Sligo,Ireland",@"Derry,Ireland",@"Cavan,Ireland",@"Leitrim,Ireland",@"Monaghan,Ireland"
                              ,@"Louth,Ireland",@"Roscommon,Ireland",@"Longford,Ireland",@"Claregalway,Ireland",@"Tipperary,Ireland",@"Limerick,Ireland",@"Wexford,Ireland",@"Waterford,Ireland",@"Kerrykeel,Ireland"];
    
    
    EventObjectParser *pasre = [[EventObjectParser alloc]init];
    
    
    NSDate *now = [NSDate date];
    NSString *todaysDate = [pasre formatDateForAPIcall:now];
    NSDictionary *JSONresultes = [[NSDictionary alloc]init];
    NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow: -(60.0f*60.0f*24.0f)];
    NSString *yesterdaysDate = [pasre formatDateForAPIcall:yesterday];

    
    
    
    
    for (NSString *countyName in self.countysInIreland) {
        
    JSONresultes = [pasre GetEventJSON:countyName dateObject:todaysDate];
    
    if ([JSONresultes count]== 0 ) {
        NSLog(@"there was no events in that county today");
    }
    else {
        
    [self praseJSONresult:JSONresultes];
        
    }

 }
   
    
    for (NSString *countyName in self.countysInIreland) {
        
        JSONresultes = [pasre GetEventJSON:countyName dateObject:yesterdaysDate];
        
        if ([JSONresultes count]== 0 ) {
            NSLog(@"there was no events in that county yesterday");
        }
        else {
            
            [self praseJSONresult:JSONresultes];
            
        }
        
    }
    
    
    
    
    
    
    
    

    completionBlock();

};




//this method is called to get more artist info ie.cover picutre URL of a paticular artist
-(NSString*)getArtistInfoByName:(NSString*)artistname currentevent:(eventObject*)currentevent completionBlock:(void(^)(void))completionBlock{
    
    
    //conect to the endpoint with the artist name and get artist JSON
    NSString *endpoint = [NSString stringWithFormat:@"http://api.bandsintown.com/artists/%@.json?api_version=2.0&app_id=YOUR_APP_ID",artistname];
    NSURL *url = [NSURL URLWithString:endpoint];
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
       
        if (error) {
            NSLog(@"JSON ERROR adding coverpicture URL artsit search with name");
            //add event with the cover picture URL
            [self.allEvents addObject:currentevent];
            //call the comletion block
            completionBlock();



        }else {
            
            NSDictionary *jsonData = [[NSDictionary alloc]init];
            jsonData  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            
            if ([jsonData count]== 0 ) {
                NSLog(@"No info for that artist seched by name");
                [self.allEvents addObject:currentevent];
                completionBlock();
            }
            else {
                
                //if unknown artist object comes back form API call do this
                if (jsonData[@"errors"]) {
                    NSString *error = jsonData[@"errors"];
                    NSLog(@"%@",error);
                    [self.allEvents addObject:currentevent];
                    NSLog(@"event added bad" );
                    completionBlock();

                }else{
                    
                    currentevent.coverpictureURL = jsonData [@"thumb_url"];
                    [self.allEvents addObject:currentevent];
                    NSLog(@"event added good" );
                    completionBlock();
                }
                
            }
        }
    }];
    //remove this reture type when time theres no need for it
    return self.imageUrl;
};

//work the same as the above method exept it just searchs by MBID number
-(NSString*)getArtistInfoByMbidNumuber:(NSString *)mbidNumber currentevent:(eventObject*)currentevent completionBlock:(void(^)(void))completionBlock{
    
    
    
    NSString *endpoint = [NSString stringWithFormat:@"http://api.bandsintown.com/artists/mbid_%@?format=json&api_version=2.0&app_id=YOUR_APP_ID",mbidNumber];
    NSURL *url = [NSURL URLWithString:endpoint];
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            NSLog(@" JSON error mbid number didnt work");
            [self.allEvents addObject:currentevent];
            NSLog(@"event added bad" );
            completionBlock();

        }else {
            
            
            NSDictionary *jsonData = [[NSDictionary alloc]init];
            jsonData  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            
            if ([jsonData count]== 0 ) {
                NSLog(@"No info for that artist via mbid api call");
                [self.allEvents addObject:currentevent];
                NSLog(@"event added bad" );
                completionBlock();



            }
            else {
                
                
                currentevent.coverpictureURL = jsonData[@"thumb_url"];
                
                [self.allEvents addObject:currentevent];
                NSLog(@"event added good" );
                completionBlock();
                
            }
        }
        
    }];
    
//remove reture type
    return 0;
};


-(void)praseJSONresult: (NSDictionary*)JSONresult{
    
    

    //for eveny object in the dictionary self.jsonData parse it in this way
    for (NSDictionary *object in JSONresult) {
        EventObjectParser *pasre = [[EventObjectParser alloc]init];
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
                i++;
            }
            
        }else{
            event.eventType = @"single";
            NSArray *artists = object [@"artists"];
            
            if ([artists count]>0) {
                NSDictionary *artistinfo = artists [0];
                event.eventTitle = artistinfo[@"name"];
            }
            
            
            else {
                event.eventTitle = @"Some silly goose forgeot to enter event title";
                event.InstaSearchQuery = @"error";
            }
            
        }
        
        
        event.venueName = venue [@"name"];
        event.InstaSearchQuery = [pasre makeInstagramSearch:event.eventTitle];
        
        
        NSDictionary *artistinfo = artists [0];
        
        if (artistinfo[@"mbid"] == (id)[NSNull null]) {
            event.mbidNumber = @"empty";
        }else{
            event.mbidNumber = artistinfo[@"mbid"];
        };
        
        
        event.LatLong = @{ @"lat" : venue[@"latitude"],
                           @"long": venue[@"longitude"]
                           };
        
        event.eventDate = object [@"datetime"];
        event.twitterSearchQuery = [pasre makeTitterSearch:event.eventTitle venueName:event.venueName];
        event.status = [pasre GetEventStatus:object [@"datetime"]];
        
        [self.allEvents addObject:event];
        
    };//end of JSON parsing loop






};






@end
