//
//  JCHappeningTonightHeaderVC.h
//  masterbranch
//
//  Created by james cash on 23/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "eventObject.h"
#import "JCAnnotation.h"
@interface JCHappeningTonightHeaderVC : UIViewController <MKMapViewDelegate>

@property (nonatomic,strong) eventObject *currentEvent;

@end