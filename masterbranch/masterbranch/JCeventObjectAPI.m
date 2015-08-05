//
//  JCeventObjectAPI.m
//  masterbranch
//
//  Created by james cash on 05/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "JCeventObjectAPI.h"

@interface JCeventObjectAPI () {
    JCEventBuilder *Eventbuilder;
    BOOL isOnline;
}
@end



@implementation JCeventObjectAPI

+ (JCeventObjectAPI*)sharedInstance
{
    // 1
    static JCeventObjectAPI *_sharedInstance = nil;
    
    // 2
    static dispatch_once_t oncePredicate;
    
    //Use Grand Central Dispatch (GCD) to execute a block which initializes an instance of LibraryAPI. This is the essence of the Singleton design pattern: the initializer is never called again once the class has been instantiated.
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[JCeventObjectAPI alloc] init];
    });
    return _sharedInstance;
}




- (id)init
{
    self = [super init];
    if (self) {
        Eventbuilder = [[JCEventBuilder alloc]init];
        isOnline = NO;
        
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadImage:) name:@"BLDownloadImageNotification" object:nil];
    }
    return self;
}



- (NSArray*)getEvent
{
    return [Eventbuilder getEvent];
};


@end
