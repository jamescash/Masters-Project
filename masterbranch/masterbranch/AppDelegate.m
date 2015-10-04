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





@interface AppDelegate ()
@property (nonatomic,strong) JCEventBuilder *eventbuilder;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // connecting to pasre our backend aand leetting parse know what app we are
    
    
    [Parse setApplicationId:@"e4CcwucLU3XKRPK93IeXLwzTsnKeT7Zoe7j5bJ0K" clientKey:@"akXPOHN6GDWrUD9EVwbTQ9jF7HfmZ5wsmFIXBYA9"];
    
    
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
    
    self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"JCMainViewController"];
    
    
    _eventbuilder  = [JCEventBuilder sharedInstance];
    _eventbuilder.delegate = self;
    
    
    
  
    
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
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[ @"global" ];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}


-(void)LoadMapView{
    
    //NSLog(@"AllEvnts array created in app delegate");
    self.allEevent = [self.eventbuilder getEvent];
    [self.AppDelegateDelegat AllEventsLoaded];
}


@end
