//
//  JCHttpFacade.m
//  masterbranch
//
//  Created by james cash on 30/07/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "JCHttpFacade.h"



@interface JCHttpFacade ()
@property (nonatomic, strong) JCHTTPClient *JCHTTPClient;
@property (nonatomic,strong) eventObject *currentEvent;

@end



@implementation JCHttpFacade


- (id)initWithEvent:(eventObject*)currentevent
{
    self = [super init];
    if (self) {
        
        _currentEvent = [[eventObject alloc]init];
        _currentEvent = currentevent;
        self.JCHTTPClient = [[JCHTTPClient alloc]initWithEvent:currentevent];
        
     }
    return self;
}
    
    
    
    






//-(void)APIreqestDidFinish1:(NSArray *)paresedData{
//    
//    [self.socialStreamData addObject:self.JCHTTPClient.instaresults];
//    
//    [self.JCHttpFacadedelegate APIreqestDidFinish:self.socialStreamData];
//    
//};

@end
