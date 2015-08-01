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



@interface JCHttpFacade : NSObject
@property (strong, nonatomic) id<JCHttpFacadedelegate>JCHttpFacadedelegate;
- (id)initWithEvent:(eventObject*)currentevent;
@end


@protocol JCHttpFacadedelegate <NSObject>
- (void)reloadTableViewithArray:(NSArray*) instaresults;
@end