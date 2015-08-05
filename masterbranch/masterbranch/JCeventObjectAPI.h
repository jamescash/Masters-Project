//
//  JCeventObjectAPI.h
//  masterbranch
//
//  Created by james cash on 05/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCEventBuilder.h"


@interface JCeventObjectAPI : NSObject

+ (JCeventObjectAPI*)sharedInstance;

- (NSArray*)getEvent;


@end
