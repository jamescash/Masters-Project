//
//  JCSocailStreamController.h
//  masterbranch
//
//  Created by james cash on 28/06/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eventObject.h"
#import "JCHttpFacade.h"
#import "JCEndpointConstructor.h"

@interface JCSocailStreamController : UITableViewController <JCHttpFacadedelegate>;
@property (nonatomic,strong) JCEndpointConstructor *JCEndpointdelegate;
@property (nonatomic) eventObject *currentevent;
- (instancetype)initWithTitle:(eventObject*)currentevet;
@end



