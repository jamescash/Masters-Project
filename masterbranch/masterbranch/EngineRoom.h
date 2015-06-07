//
//  EngineRoom.h
//  masterbranch
//
//  Created by james cash on 06/06/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "eventObject.h"
#import "MapView.h"
@interface EngineRoom : NSObject

@property (nonatomic) NSMutableArray *upcomingDublinGigs;
@property (nonatomic) NSMutableArray *corkGigs;
@property (nonatomic) NSMutableArray *galwayGigs;
@property (nonatomic) NSMutableArray *eventObjects;
@property (nonatomic) NSMutableArray *todaysObjects;
@property (nonatomic) NSMutableArray *masterArray;
@property (nonatomic) int i;
@property (nonatomic) NSArray *countysInIreland;




-(void) buildEventObjectArray;
-(void) songKickApiCall:(void(^)(void))testblock;
-(void) buildmasterarray:(void(^)(void))completionBlock;

@end
