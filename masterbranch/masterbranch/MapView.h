//
//  MapView.h
//  masterbranch
//
//  Created by james cash on 06/06/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eventObject.h"
#import "Annotation.h"
#import "JCSocailStreamController.h"
#import "JCEventBuilder.h"

//This is the superclass viewcontroler for any views that are part of the slideout side menu
#import "VCbaseSildeMenu.h"

@protocol MapViewDelegate;

@interface MapView : VCbaseSildeMenu <MKMapViewDelegate,JCEventBuildereDlegate>
@property (strong, nonatomic) MKMapView *MkMapViewOutLet;
@property (nonatomic) NSString *url;
@property (strong, nonatomic) id<MapViewDelegate>MapViewDelegate;
@end

@protocol MapViewDelegate <NSObject>
-(void)userDidSelectAnnotation:(eventObject*) currentevent;
@end
