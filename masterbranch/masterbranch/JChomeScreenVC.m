//
//  JChomeScreenVC.m
//  masterbranch
//
//  Created by james cash on 09/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "JChomeScreenVC.h"
//framworks for the hamburgermenu
#import "MMDrawerController.h"

//#import "MMExampleCenterTableViewController.h"
//#import "MMExampleLeftSideDrawerViewController.h"

#import "MMDrawerVisualState.h"
//#import "MMExampleDrawerVisualStateManager.h"

//Navigation Controller
#import "NavigtionViewController.h"


//#import <QuartzCore/QuartzCore.h>
#import "MapView.h"

//loging screen
#import "JCloginVC.h"

@interface JChomeScreenVC ()
@property (nonatomic,strong) MMDrawerController * drawerController;

@end

@implementation JChomeScreenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //Setting Up the RootViewControler
    
    //Initiating centerVC
    MapView *center = [[MapView alloc]init];
    
    //Iinit left side menue
    JCSocailStreamController *left = [[JCSocailStreamController alloc]init];
    
    //creat the top nav bars and add them to the super VC'S
    UINavigationController * centerVC = [[NavigtionViewController alloc] initWithRootViewController:center];
    UINavigationController * leftVC = [[NavigtionViewController alloc] initWithRootViewController:left];
    
    //init drawer ontroler class with my ViewControllers
    self.drawerController = [[MMDrawerController alloc]initWithCenterViewController:centerVC leftDrawerViewController:leftVC];
    
    [self.drawerController setShowsShadow:YES];
    //[self.drawerController setRestorationIdentifier:@"MMDrawer"];
    [self.drawerController setMaximumLeftDrawerWidth:200.0];
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
   
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    [self.window setRootViewController:self.drawerController];
    
    [self.window makeKeyAndVisible];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
