//
//  JCHttpFacade.h
//  masterbranch
//
//  Created by james cash on 30/07/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "eventObject.h"
#import "JCHTTPClient.h"




@protocol JCHttpFacadedelegate;



@interface JCHttpFacade : NSObject// <JCHTTPClientdelegate>;


@property (nonatomic,strong) NSMutableArray *socialStreamData;

@property (strong, nonatomic) id<JCHttpFacadedelegate>JCHttpFacadedelegate;


- (id)initWithEvent:(eventObject*)currentevent;


//- (id)initWithcurrentEvent:(eventObject*) currentEvent delegate:(id<JCHttpFacadedelegate>) theDelegate;




@end


@protocol JCHttpFacadedelegate <NSObject>
- (void)APIreqestDidFinish:(NSArray*)paresedData;
@end