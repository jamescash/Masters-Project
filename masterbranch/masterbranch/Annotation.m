//
//  Annotation.m
//  masterbranch
//
//  Created by james cash on 06/06/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "Annotation.h"

@implementation Annotation


- (id)initWithpostion:(CLLocationCoordinate2D)coords
{
    self = [super init];
    if (self) {
        self.coordinate = coords;
        
        
    }
    return self;
}

@end
