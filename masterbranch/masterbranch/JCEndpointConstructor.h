//
//  JCEndpointConstructor.h
//  masterbranch
//
//  Created by james cash on 25/07/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "eventObject.h"



@protocol JCEndpointConstructordelegate;


@interface JCEndpointConstructor : NSObject

@property (strong, nonatomic) id<JCEndpointConstructordelegate> JCEndpointConstructordelegate;


-(void)buildHappeningLaterEndPointsForEvent:(eventObject*)currentevent;

@property (nonatomic,strong)NSMutableArray *endpoints;

@end


@protocol JCEndpointConstructordelegate

-(void)reloadTabeView;

@end