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

    self.happeningLater = [[NSMutableArray alloc]init];

    self.countysInIreland = @[@"Dublin,Ireland",@"Cork,Ireland",@"Galway,Ireland",@"Belfast,United+Kingdom",@"Kildare,Ireland",@"Carlow,Ireland",@"Kilkenny,Ireland",
                              @"Donegal,Ireland",@"Mayo,Ireland",@"Sligo,Ireland",@"Derry,Ireland",@"Cavan,Ireland",@"Leitrim,Ireland",@"Monaghan,Ireland"
                              ,@"Louth,Ireland",@"Roscommon,Ireland",@"Longford,Ireland",@"Claregalway,Ireland",@"Tipperary,Ireland",@"Limerick,Ireland",@"Wexford,Ireland",@"Waterford,Ireland",@"Kerrykeel,Ireland"];
   // self.countysInIreland = @[@"Dublin,Ireland",@"Cork,Ireland",@"Galway,Ireland",@"Belfast,United+Kingdom"];
    
    
    int x = 0;
     while (x < [self.countysInIreland count]) {
    
     //format todays date for the API call
     NSDate * now = [NSDate date];
     NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
     [dateFormat setDateFormat:@"yyyy-LL-dd"];
     NSString *todaysdate = [dateFormat stringFromDate:now];
       
         
       //connet to the BandsinTown API get all events from the area on todays date
        NSString *endpoint = [NSString stringWithFormat:@"http://api.bandsintown.com/events/search.json?api_version=2.0&app_id=YOUR_APP_ID&date=%@,%@&location=%@",todaysdate,todaysdate,[self.countysInIreland objectAtIndex:x]];
     
         NSURL *url = [NSURL URLWithString:endpoint];
         [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {

        if (error) {
                NSLog(@"api call didnt work with %@",self.countysInIreland[x]);
            }else {

                //Turn the JSON data into a dictionary
                self.jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];

               
                
                //if there is data in the dictionary go ahead and parse it otherwise NSlog something
                if ([self.jsonData count]== 0 ) {
                  NSLog(@"there was no events in %@ today",self.countysInIreland[x]);
                }
                else {


                    //for eveny object in the dictionary self.jsonData parse it in this way
                    for (NSDictionary *object in self.jsonData) {
                    eventObject *event = [[eventObject alloc]init];

                    //find out if it an event with one or more artists
                    NSDictionary *artistdic = object [@"artists"];

                    //if it has one or more artist parse this way
                    //while loop and i counter to itterate each sningle artist in returened json event
                     if ([artistdic count] > 1 ) {

                            int i = 0;
                            while ( i < [artistdic count] ){

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

                                //getting artist mbid number
                                if (artistinfo[@"mbid"] == (id)[NSNull null]) {
                                    event.mbidNumber = @"empty";
                                }else{
                                    event.mbidNumber = artistinfo[@"mbid"];
                                };
                                

                                //retreving venue details
                                NSDictionary *venue = object [@"venue"];
                                //storing event lat/long in a dictionary
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
                                //encoding query for web
                                NSString *encodedrequest = [artistNameHashtag stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
                                event.twitterSearchQuery = encodedrequest;


                                
                                //identifying when the gig happened
                                NSString *objectdate = object [@"datetime"];
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
                                    event.status = @"alreadyHappened";
                                }else if (diff > 1){
                                     event.status = @"happeningLater";
                                }else {
                                    event.status = @"currentlyhappening";
                                };
                                
                                //to get the artist cover picture a seperate API call has to be made using either the artis name or the artist mbid number
                                //this gives back more info about that artist
                            
                                
                                if ([event.mbidNumber isEqualToString:@"empty"]) {
                                    
                                    
                                    //this method gets passed the current event and the artsit name
                                    //then makes an API call to bandsintown and gets the artist cover picture URL
                                    //then it sets that URL as a property in the current event object
                                    //than it adds the current event objet to the allEvents array
                                    //then on completetion it runs this completeion block
                                    //and if x is equal to self.countysInIreland count then the API calls are finished
                                    //and so call the second completeion block which goes into MapView.M and starts building the events annotations
                                    [self getArtistInfoByName:event.InstaSearchQuery currentevent:event completionBlock:^{
                                        
                                        int a = ([self.countysInIreland count]-1 );
                                        if (x == a) {
                                            completionBlock();
                                            
                                            NSString *stringRep1 = [NSString stringWithFormat:@"%@",self.allEvents];
                                            NSLog(@"%@",stringRep1);
                                         };
                                        
                                        
                                    }];
                                }else {
                                    
                                    
                                    [self getArtistInfoByMbidNumuber:event.mbidNumber currentevent:event completionBlock:^{
                                        
                                        int a = ([self.countysInIreland count]-1 );
                                        if (x == a) {
                                            completionBlock();
                                            
                                            
                                            NSString *stringRep1 = [NSString stringWithFormat:@"%@",self.allEvents];
                                            NSLog(@"%@",stringRep1);
                                        };
                                    }];
                                }
                           
                             //incrmenter for the while loop that parses objects that contain more than one artist
                             i++;



                            };//end of the while loop that parses events white more that one artist

                        }//End of Multie Artist

                        
                     //else the object only has one artist and so parse the JSON this way
                       else{
                            

                            event = [[eventObject alloc]init];
                            event.coverpictureURL = @"nil";

                           
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
                                event.eventTitle = @"Some silly goose forgeot to enter event title";
                                event.InstaSearchQuery = @"error";
                            }
                            
                            NSString *A = event.eventTitle;
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
                            [artistNameHashtag appendString:event.eventTitle];
                            [venueHashtag appendString:venue [@"name"]];
                            NSString *encodedrequest = [artistNameHashtag stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
                            event.twitterSearchQuery = encodedrequest;
                           
                            //calculate the diffrenece between NOW and event date&time so we can determain event status
                            NSString *objectdate = object [@"datetime"];
                            NSString *dateformatted = [objectdate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                            [dateFormat setDateFormat:@"yyyy-LL-dd HH:mm:ss"];
                            NSDate *date = [dateFormat dateFromString:dateformatted];
                            NSDate *todaysdate = [NSDate date];
                            NSTimeInterval diff = ([date timeIntervalSinceDate:todaysdate]/60)/60;
                            
                            
                            
                            //set event status based on diffrence of NOW and event date&time
                            if (diff < -5 && diff > -24) {
                                event.status = @"alreadyHappened";
                            }else if (diff > 1){
                                event.status = @"happeningLater";
                            }else {
                                event.status = @"currentlyhappening";
                            };
                           
                            
                            
                            
                            if ([event.mbidNumber isEqualToString:@"empty"]) {
                              
                                
                                [self getArtistInfoByName:event.InstaSearchQuery currentevent:event completionBlock:^{
                                
                                    int a = ([self.countysInIreland count]-1 );
                                    if (x == a) {
                                        completionBlock();
                                        NSString *stringRep1 = [NSString stringWithFormat:@"%@",self.allEvents];
                                        NSLog(@"%@",stringRep1);
                                        
                                    };
                                
                                }];
                                
                                
                            }else {
                                
                                
                                [self getArtistInfoByMbidNumuber:event.mbidNumber currentevent:event completionBlock:^{
                                    
                                    int a = ([self.countysInIreland count]-1 );
                                    if (x == a) {
                                        completionBlock();
                                        NSLog(@"correct completion block called");
                                        
                                        
                                    };
                                
                                
                                
                                }];
                            }

                         }//end of else statment for paring event object with single artist
                        
                    }//end of outter loop for every object in JSONdata


                }//end of outter if else statment if JSON error else parse
              

            }//end of outter if/else statment
        
         }];//end of completion block for api call all events are parsed and ready to go

       
         //increment x for the outter while loop
        x = x+1;
  }//end of outter while loop
}//end of build master array loop



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





@end
