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
@property (nonatomic) NSMutableArray *eventObjects;
@property (nonatomic) NSMutableArray *todaysObjects;
@property (nonatomic) int i;


-(void) buildEventObjectArray;
-(void) songKickApiCall:(void(^)(void))testblock;

@end
