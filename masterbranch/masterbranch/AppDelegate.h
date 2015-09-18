//
//  AppDelegate.h
//  masterbranch
//
//  Created by james cash on 02/06/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import <UIKit/UIKit.h>
//API facade for building array for bandsintown event objects
#import "JCEventBuilder.h"

@protocol AppDelegateDelegat;


@interface AppDelegate : UIResponder <UIApplicationDelegate,JCEventBuildereDlegate>
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSDictionary *allEevent;
@property (strong,nonatomic) id <AppDelegateDelegat>AppDelegateDelegat;
@end

@protocol AppDelegateDelegat <NSObject>
-(void)AllEventsLoaded;
@end