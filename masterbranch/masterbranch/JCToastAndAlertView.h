//
//  JCToastAndAlertView.h
//  PreAmp
//
//  Created by james cash on 24/11/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JCToastAndAlertView : NSObject
-(void)showUserUpDateToastWithMessage:(NSString*)message;
-(void)showLoadingAlertViewWithMessage:(NSString*)message andTitle:(NSString*)title inUIViewController:(UIViewController*)UIViewController;
@end
