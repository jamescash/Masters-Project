//
//  AppDelegate.m
//  masterbranch
//
//  Created by james cash on 02/06/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "AppDelegate.h"


//FBSDKiOS loggin
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

//Pares is the framwork for our database
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
//#import "ParseFacebookUtilsV4.h"

#import "JCLocationManager.h"

#import <ParseFacebookUtilsV4/PFFacebookUtils.h>

#include "JDStatusBarNotification.h"
#import <ParseCrashReporting/ParseCrashReporting.h>

#import <Google/Analytics.h>
#import "GAI.h"


@interface AppDelegate ()
@property (nonatomic,strong) JCEventBuilder *eventbuilder;
@property (nonatomic,strong) JDStatusBarNotification *notificationView;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //enable local data storage
    [Parse enableLocalDatastore];
    [ParseCrashReporting enable];

     //connecting to pasre our backend aand leetting parse know what app we are
    [Parse setApplicationId:@"e4CcwucLU3XKRPK93IeXLwzTsnKeT7Zoe7j5bJ0K" clientKey:@"akXPOHN6GDWrUD9EVwbTQ9jF7HfmZ5wsmFIXBYA9"];
    [PFImageView class];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];
    
    // Configure tracker from GoogleService-Info.plist.
    NSError *configureError;
    [[GGLContext sharedInstance] configureWithError:&configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    // Optional: configure GAI options.
    GAI *gai = [GAI sharedInstance];
    gai.trackUncaughtExceptions = YES;  // report uncaught exceptions
    [GAI sharedInstance].dispatchInterval = 0;

    //gai.logger.logLevel = kGAILogLevelVerbose;  // remove before app release
    
    
    
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes  categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
    
    self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"JCMainViewController"];
    [self customiseUi];
    
    [JDStatusBarNotification addStyleNamed:@"JCnotification"
                                   prepare:^JDStatusBarStyle *(JDStatusBarStyle *style) {
                                       style.barColor = [UIColor colorWithRed:234.0f/255.0f green:65.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
                                       style.textColor = [UIColor whiteColor];
                                       style.animationType = JDStatusBarAnimationTypeBounce;
                                       style.progressBarColor = style.textColor;
                                       style.progressBarHeight = 7.0;
                                       style.progressBarPosition = JDStatusBarProgressBarPositionTop;
                                       
                                       style.font = [UIFont fontWithName:@"HelveticaNeue-light" size:17.0];
                                       return style;
                                   }];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    [FBSDKAppEvents activateApp];

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    //[PFFacebookUtils initializeFacebook];
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError %@",error);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"did regiaster for remote notifications");
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
     currentInstallation.channels = @[ @"global" ];
    [currentInstallation saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error) {
            NSLog(@"error with device token %@",error);
        }
        
    }];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
   
    NSDictionary *aps = [userInfo objectForKey:@"aps"];
    NSString *alert = [aps objectForKey:@"alert"];
    

    
    
    [JDStatusBarNotification showWithStatus:alert dismissAfter:5.0
                                  styleName:@"JCnotification"];
    
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    

    //NSLog(@"%@",userInfo);
    
    //[PFPush handlePush:userInfo];
}

-(void)customiseUi{
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    [[UINavigationBar appearance] setTranslucent:YES];
    
    
}


//-(void)LoadMapView{
//    
//    //NSLog(@"AllEvnts array created in app delegate");
//    self.allEevent = [self.eventbuilder getEvent];
//    [self.AppDelegateDelegat AllEventsLoaded];
//}


@end
