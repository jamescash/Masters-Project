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
#import "SocialStream.h"
#import "JCSocailStreamController.h"
#import "JCssHappeningLater.h"
#import "JCEventBuilder.h"





@interface MapView : UIViewController <MKMapViewDelegate,JCEventBuildereDlegate>

@property (weak, nonatomic) IBOutlet MKMapView *MkMapViewOutLet;

@property (nonatomic) NSString *url;


@end
