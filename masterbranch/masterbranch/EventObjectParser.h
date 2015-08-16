//
//  EventObjectParser.h
//  masterbranch
//
//  Created by james cash on 25/06/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>



@interface EventObjectParser : NSObject

@property (nonatomic) UIImageView *thumbNail;


-(NSString*)formatDateForAPIcall:(NSDate*)date;

-(NSString*)getUnixTimeStamp:(NSString*)date;


//-(NSDictionary*)GetEventJSON: (NSString*)countyName dateObject:(NSString*)date;

-(NSString*)makeInstagramSearch: (NSString*) eventTitle;

-(NSString*)makeTitterSearch: (NSString*)eventTitle venueName:(NSString*)venueName eventStartDate:(NSString*) eventDate;

-(NSString*)GetEventStatus: (NSString*) currentEventDate;

-(UIImageView*)makeThumbNail: (NSData*) pictureData;

-(int)DistanceFromIreland: (CLLocation*)eventLocation;

+ (EventObjectParser*)sharedInstance;


@end
