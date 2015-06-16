//
//  eventObject.h
//  Second_Prototype
//
//  Created by james cash on 01/06/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface eventObject : NSObject

@property (nonatomic) NSString *eventTitle;
@property (nonatomic) NSString *coverpictureURL;
@property (nonatomic) NSDate *eventDate;
@property (nonatomic) int startTime;
@property (nonatomic) NSString *venueName;
@property (nonatomic) NSDictionary *LatLong;
@property (nonatomic) NSString *twitterSearchQuery;
@property (nonatomic) NSString *InstaSearchQuery;
@property (nonatomic) NSMutableArray *artistsAtEvent;
@property (nonatomic) NSString *mbidNumber;


@property (nonatomic) NSMutableArray *jsonData;
@property (nonatomic) NSMutableArray *todaysObjects;
@property (nonatomic) NSArray *countysInIreland;


-(void) buildmasterarray:(void(^)(void))completionBlock;
//-(void) getartistpicture:(eventObject*)currentEvent;







@end
