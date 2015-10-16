//
//  JCAnnotation.m
//  masterbranch
//
//  Created by james cash on 28/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "JCAnnotation.h"

@implementation JCAnnotation

- (id)initWithpostion:(CLLocationCoordinate2D)coords
{
    self = [super init];
    if (self) {
        self.coordinate = coords;
    }
    return self;
}


@end
