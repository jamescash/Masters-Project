//
//  JCEventBuilder.h
//  masterbranch
//
//  Created by james cash on 05/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventObjectParser.h"
#import "eventObject.h"

@protocol JCEventBuildereDlegate;

@interface JCEventBuilder : NSObject
@property (nonatomic,weak) id<JCEventBuildereDlegate> delegate;
+(JCEventBuilder*)sharedInstance;
-(NSDictionary*)getEvent;
@end


@protocol JCEventBuildereDlegate <NSObject>
-(void)LoadMapView;
@end