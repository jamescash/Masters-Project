//
//  JCHTTPClient.h
//  masterbranch
//
//  Created by james cash on 30/07/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCHttpFacade.h"
#import "eventObject.h"



//@protocol JCHTTPClientdelegate;


@interface JCHTTPClient : NSObject

@property (nonatomic,strong) NSArray *ParseTwitterResults;
@property (nonatomic,strong) NSArray *InstaHashTagResults;
@property (nonatomic,strong) NSArray *InstaPlacesResults;
- (id)initWithEvent:(eventObject*)curentEvent;

@end

