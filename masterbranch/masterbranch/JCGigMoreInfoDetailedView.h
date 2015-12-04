//
//  JCGigMoreInfoDetailedView.h
//  PreAmp
//
//  Created by james cash on 30/11/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eventObject.h"
#import "JCAnnotation.h"

@interface JCGigMoreInfoDetailedView : UIViewController <MKMapViewDelegate>
@property (nonatomic,strong)NSString *formatViewControlerWithEventObjectOfType;
@property (nonatomic,strong)eventObject *currentEventEventObject;
@end
