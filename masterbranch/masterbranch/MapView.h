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




@interface MapView : UIViewController <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *MkMapViewOutLet;
@property (nonatomic) NSMutableArray *annotations;
@property (nonatomic) NSString *url;
@property (nonatomic) NSMutableArray *allGigs;





-(void)buildannotations:(NSArray*)arrayofgigs;

@end
