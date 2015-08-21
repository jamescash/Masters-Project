//
//  eventObject.m
//  Second_Prototype
//
//  Created by james cash on 01/06/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "eventObject.h"
//#import "coreLocation.h"

@interface eventObject ()

@property (nonatomic,strong) EventObjectParser *pasre;
@property (nonatomic,strong) CLLocation *aLocation;


@end

@implementation eventObject

    
    



////this method is called to get more artist info ie.cover picutre URL of a paticular artist
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




- (id)initWithTitle:(NSDictionary *)object {
    
    
    self = [super init];
    if (self) {
        
        
         _pasre = [EventObjectParser sharedInstance];
        
        
        
        
            NSDictionary *artistdic = object [@"artists"];
            NSArray *artists = object [@"artists"];
            NSDictionary *venue = object [@"venue"];
            
            //if it has one or more artist parse into concert
            //while loop and i counter to itterate each sningle artist in returened json event
            if ([artistdic count] > 1 ) {
                
                self.eventType = @"concert";
                self.eventTitle = venue [@"name"];
                
                int i = 0;
                while ( i < [artistdic count] ){
                    NSDictionary *artistinfo = artists [i];
                    self.artistNames = [[NSMutableArray alloc]init];
                    [self.artistNames addObject:artistinfo[@"name"]];
                    //NSLog(@"%@",event.artistNames);
                    i++;
                }
                
            }else{
                self.eventType = @"single";
                NSArray *artists = object [@"artists"];
                
                if ([artists count]>0) {
                    NSDictionary *artistinfo = artists [0];
                    self.eventTitle = artistinfo[@"name"];
                    
                    if (artistinfo[@"mbid"] == (id)[NSNull null]) {
                        self.mbidNumber = @"empty";
                    }else{
                        self.mbidNumber = artistinfo[@"mbid"];
                    };
                    
                }
                 else {
                    self.eventTitle = @"No event title";
                    self.InstaSearchQuery = @"error";
                    self.mbidNumber = @"empty";
                }
                
            }
       
            
            self.venueName = venue [@"name"];
            self.InstaSearchQuery = [self.pasre makeInstagramSearch:self.eventTitle];
            self.LatLong = @{ @"lat" : venue[@"latitude"],
                               @"long": venue[@"longitude"]
                               };
      
        self.country = venue[@"country"];
     
        
            self.eventDate = object[@"datetime"];
            self.InstaTimeStamp = [self.pasre getUnixTimeStamp:object[@"datetime"]];
            self.twitterSearchQuery = [self.pasre makeTitterSearch:self.eventTitle venueName:self.venueName eventStartDate:self.eventDate];
            self.status = [self.pasre GetEventStatus:object [@"datetime"]];
        
        NSString *latitude = self.LatLong[@"lat"];
        NSString *Long = self.LatLong[@"long"];
      
        

        //if (!self.aLocation) {
           
            self.aLocation = [[CLLocation alloc] initWithLatitude:[latitude doubleValue] longitude:[Long doubleValue]];
          //  NSLog(@"revers geo code");
        self.DistanceFromIreland = [self.pasre DistanceFromIreland:self.aLocation];

        //}
        
        
        
        
       }
    
    return self;
}





@end
