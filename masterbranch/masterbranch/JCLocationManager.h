//
//  JCLocationManager.h
//  PreAmp
//
//  Created by james cash on 15/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

//Get the user loacation - Used on homescreen 

@interface JCLocationManager : NSObject

+(JCLocationManager*)sharedInstance;
-(void)getlocation;
@end
