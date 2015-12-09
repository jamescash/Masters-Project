//
//  eventObject.m
//  Second_Prototype
//
//  Created by james cash on 01/06/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "eventObject.h"

@interface eventObject ()
@property (nonatomic,strong) EventObjectParser *pasre;
@property (nonatomic,strong) CLLocation *aLocation;
@end

@implementation eventObject

- (id)initWithTitle:(NSDictionary *)object {
    
    
    self = [super init];
    
    if (self) {
        
        
        //Made the parse call a shared instance so its only initiated once to save memory
         _pasre = [EventObjectParser sharedInstance];
        
        
         //Make a new photoDownload for every event
         self.photoDownload = [[JCPhotoDownLoadRecord alloc]init];
         self.artistNames = [[NSMutableArray alloc]init];
         self.isInIreland = NO;
         self.isNearIreland = NO;
         NSDictionary *artistdic = object [@"artists"];
         //Array contaning a dictionarry with all the artsit at the event
         NSArray *artists = object [@"artists"];
        //TODO parse thisJSON correctly
            if ([artists count]==0) {
                NSLog(@"no artist found for event");
                return nil;
                }
        self.userIsInterestedInEvent = NO;
        self.isUserInterestedInUpcomingGigFinishedLoading = NO;
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
                    self.imageUrl = artistinfo [@"image_url"];
                    
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
        
            if ([self.country isEqualToString:@"Ireland"]){
                self.isInIreland = YES;
                self.isNearIreland = NO;
            }
        
        
            self.eventDate = object[@"datetime"];
            self.formattedDateTime = object[@"formatted_datetime"];
            self.InstaTimeStamp = [self.pasre getUnixTimeStamp:object[@"datetime"]];
            self.twitterSearchQuery = [self.pasre makeTitterSearch:self.eventTitle venueName:self.venueName eventStartDate:self.eventDate];
        
            //self.status = [self.pasre GetEventStatus:object [@"datetime"]];
            //Go off and calulate the distance from Ireland
            NSString *latitude = self.LatLong[@"lat"];
            NSString *Long = self.LatLong[@"long"];
            self.aLocation = [[CLLocation alloc] initWithLatitude:[latitude doubleValue] longitude:[Long doubleValue]];
            self.DistanceFromIreland = [self.pasre DistanceFromIreland:self.aLocation];
        
            if (self.DistanceFromIreland<4000&&!self.isInIreland) {
                self.isNearIreland = YES;
            }
        
       }
    
    return self;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.photoDownload = [[JCPhotoDownLoadRecord alloc]init];

    }
    return self;
}


@end
