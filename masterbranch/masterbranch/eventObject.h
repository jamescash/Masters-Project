//
//  eventObject.h
//  Second_Prototype
//
//  Created by james cash on 01/06/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "EventObjectParser.h"

#import "JCPhotoDownLoadRecord.h"


@interface eventObject : NSObject

@property (nonatomic) NSString *eventTitle;
@property (nonatomic) NSString *coverpictureURL;
@property (nonatomic) NSString *eventDate;
@property (nonatomic) NSString *formattedDateTime;
@property (nonatomic) NSString *venueName;
@property (nonatomic) NSDictionary *LatLong;
@property (nonatomic) NSString *twitterSearchQuery;
@property (nonatomic) NSString *InstaSearchQuery;
@property (nonatomic) NSMutableArray *artistsAtEvent;
@property (nonatomic) NSString *mbidNumber;
@property (nonatomic) NSString *status;
@property (nonatomic) NSString *eventType;
@property (nonatomic) NSMutableArray *artistNames;
@property (nonatomic) UIImageView *coverpic;
@property (nonatomic) NSString *InstaTimeStamp;
@property (nonatomic) NSString *imageUrl;
@property (nonatomic) NSString *country;
@property (nonatomic) NSString *county;
@property (nonatomic) int DistanceFromIreland;
@property (nonatomic) JCPhotoDownLoadRecord *photoDownload;
@property (nonatomic) NSString *CellTitle;
@property (nonatomic) BOOL isInIreland;
@property (nonatomic) BOOL isNearIreland;
@property (nonatomic) BOOL userIsInterestedInEvent;
@property (nonatomic) BOOL isUserInterestedInUpcomingGigFinishedLoading;



- (id)initWithTitle:(NSDictionary *)dictionary;

@end
