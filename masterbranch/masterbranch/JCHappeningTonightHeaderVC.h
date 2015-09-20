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




@protocol JCHappeningTonightHearderVCDelegate;


@interface JCHappeningTonightHeaderVC : UIViewController <MKMapViewDelegate>
@property (nonatomic,strong) eventObject *currentEvent;
@property (nonatomic, weak) id <JCHappeningTonightHearderVCDelegate> JCHappeningTonightHearderVCDelegate;
@end

@protocol JCHappeningTonightHearderVCDelegate <NSObject>
- (void)DidSelectInviteFriend;
@end