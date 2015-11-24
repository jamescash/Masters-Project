//
//  JCToastAndAlertView.m
//  PreAmp
//
//  Created by james cash on 24/11/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCToastAndAlertView.h"
#import "CRToast.h"


@interface JCToastAndAlertView ()
@property (nonatomic,strong) NSDictionary *userUpDateToast;

@end

@implementation JCToastAndAlertView


//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        [self creatUserUpDateToast];
//    }
//    return self;
//}




-(void)showUserUpDateToastWithMessage:(NSString*)message{
    
    UIFont *font = [UIFont fontWithName:@"helvetica-Light" size:15];
    
    NSDictionary *toast = @{
                             kCRToastTextKey : message,
                             kCRToastFontKey: font,
                             kCRToastTextColorKey :[UIColor colorWithRed:234.0f/255.0f green:65.0f/255.0f blue:150.0f/255.0f alpha:1.0f],
                             kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                             kCRToastBackgroundColorKey : [UIColor colorWithRed:234.0f/255.0f green:234.0f/255.0f blue:234.0f/255.0f alpha:.9f],
                             kCRToastAnimationInTypeKey : @(CRToastAnimationTypeLinear),
                             kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeLinear),
                             kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
                             kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionTop),
                             kCRToastNotificationTypeKey: @(CRToastTypeNavigationBar),
                             kCRToastUnderStatusBarKey: @(YES),
                             kCRToastCaptureDefaultWindowKey:@(NO),
                             kCRToastAnimationOutTimeIntervalKey: @(.3),
                             kCRToastAnimationInTimeIntervalKey:@(.3),
                             kCRToastTimeIntervalKey:@(4),
                             };
    
    
    [CRToastManager setDefaultOptions:toast];
    
    
    [CRToastManager showNotificationWithOptions:toast
                                completionBlock:^{
                                    NSLog(@"Completed");
                                }];
    
}


@end
