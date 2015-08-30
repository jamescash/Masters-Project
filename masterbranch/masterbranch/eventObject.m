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

- (id)initWithTitle:(NSDictionary *)object {
    
    
    self = [super init];
    
    if (self) {
        
        //TODO assign the event object a uniqe so I can use it to romove resultes from the serch array when
        //they match with a switch statment
        
        //Made the parse call a shared instance so its only initiated once to save memory
         _pasre = [EventObjectParser sharedInstance];
        
        
         //Make a new photoDownload for every event
         self.photoDownload = [[JCPhotoDownLoadRecord alloc]init];
         self.artistNames = [[NSMutableArray alloc]init];

        
            NSDictionary *artistdic = object [@"artists"];
            //Array contaning a dictionarry with all the artsit at the event
            NSArray *artists = object [@"artists"];
            //Dictionary contain artist info
            NSDictionary *artistinfo = artists [0];
            //dictionart contaning all the venue infrmation
            NSDictionary *venue = object [@"venue"];
            
            //while loop and i counter to itterate each sningle artist in returened json event
            if ([artistdic count] > 1 ) {
                
                self.eventType = @"concert";
                self.eventTitle = artistinfo[@"name"];
                
                    int i = 0;
                        while ( i < [artistdic count] ){
                            [self.artistNames addObject:artistinfo[@"name"]];
                            //self.CellTitle = artistinfo[@"name"];
                        
                            //Take the first most popular artist infor for displaying event pictures
                            if (i==0) {
                                if (artistinfo[@"mbid"] == (id)[NSNull null]) {
                                    self.mbidNumber = @"empty";
                                    self.photoDownload.artistMbid = @"error";
                                }else{
                                    self.mbidNumber = artistinfo[@"mbid"];
                                    self.photoDownload.artistMbid = self.mbidNumber;
                                };
                            };
                        
                            i++;

                        }
                    }else{
                        //self.eventType = @"single";
                
               //NSArray *artists = object [@"artists"];
                if ([artists count]>0) {
                    self.eventType = @"single";
                    self.eventTitle = artistinfo[@"name"];
                    
                        if (artistinfo[@"mbid"] == (id)[NSNull null]) {
                            self.mbidNumber = @"empty";
                            self.photoDownload.artistMbid = @"error";
                        }else{
                            self.mbidNumber = artistinfo[@"mbid"];
                            self.photoDownload.artistMbid = self.mbidNumber;
                        };
                    
                }else {
                    self.CellTitle = @"error";
                    self.eventTitle = @"error";
                    self.InstaSearchQuery = @"error";
                    self.mbidNumber = @"empty";
                    self.photoDownload.artistMbid = @"error";
                    self.photoDownload.name = @"error";
                }
             }
       
        
            self.venueName = venue [@"name"];
            self.InstaSearchQuery = [self.pasre makeInstagramSearch:self.eventTitle];
            self.photoDownload.name = self.InstaSearchQuery;
            self.LatLong = @{ @"lat" : venue[@"latitude"],
                               @"long": venue[@"longitude"]
                               };
            self.country = venue[@"country"];
            self.county = venue[@"city"];
            self.eventDate = object[@"datetime"];
            self.InstaTimeStamp = [self.pasre getUnixTimeStamp:object[@"datetime"]];
            self.twitterSearchQuery = [self.pasre makeTitterSearch:self.eventTitle venueName:self.venueName eventStartDate:self.eventDate];
        
            self.status = [self.pasre GetEventStatus:object [@"datetime"]];
        
        
            //Go off and calulate the distance from Ireland
            //TODO add an if statment around this so it only calculate form the search results it unsed infromation on
            //the homescreen events
            NSString *latitude = self.LatLong[@"lat"];
            NSString *Long = self.LatLong[@"long"];
            self.aLocation = [[CLLocation alloc] initWithLatitude:[latitude doubleValue] longitude:[Long doubleValue]];
            self.DistanceFromIreland = [self.pasre DistanceFromIreland:self.aLocation];

        
        
        
       }
    
    return self;
}





@end
