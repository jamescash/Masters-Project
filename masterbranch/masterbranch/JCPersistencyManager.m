//
//  JCPersistencyManager.m
//  masterbranch
//
//  Created by james cash on 01/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "JCPersistencyManager.h"

@interface JCPersistencyManager () {

    NSMutableArray *SocailStreamData;
}

@end

@implementation JCPersistencyManager

- (id)init
{
    self = [super init];
    if (self) {
        // a dummy list of albums
        SocailStreamData = [NSMutableArray arrayWithArray:
                  @[   ]];
    }
    return self;
}



@end
