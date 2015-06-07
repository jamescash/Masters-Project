//
//  MapView.h
//  masterbranch
//
//  Created by james cash on 06/06/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eventObject.h"
#import "EngineRoom.h"
#import "Annotation.h"
#import "SocialStream.h"

@interface MapView : UIViewController <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *MkMapViewOutLet;
@property (nonatomic) NSMutableArray *todaysGigs;
@property (nonatomic) NSMutableArray *annotations;


-(void)buildannotations;

@end
