//
//  JCAnnotation.h
//  masterbranch
//
//  Created by james cash on 28/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface JCAnnotation : NSObject <MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;

- initWithpostion: (CLLocationCoordinate2D)coords;


@end
