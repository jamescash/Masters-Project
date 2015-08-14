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


#import "JCSocailStreamController.h"


@interface JChomeScreenVC ()

@property (nonatomic,strong) MMDrawerController * drawerController;
//@property (nonatomic,strong) NavigtionViewController *centerVC;


@end

@implementation JChomeScreenVC



-(void)viewWillAppear:(BOOL)animated{
    
     if (!self.drawerController) {
        
        MapView *center = [[MapView alloc]init];
        center.MapViewDelegate = self;
    
        //Iinit left side menue
        UIViewController *left = [[UIViewController alloc]init];
        
        //creat the top nav bars and add them to the super VC'S
        UINavigationController *centerVC = [[NavigtionViewController alloc] initWithRootViewController:center];
        UINavigationController * leftVC = [[NavigtionViewController alloc] initWithRootViewController:left];
        
        //init drawer ontroler class with my ViewControllers
        self.drawerController = [[MMDrawerController alloc]initWithCenterViewController:centerVC leftDrawerViewController:leftVC];
        [self.drawerController setShowsShadow:YES];
    
        //[self.drawerController setRestorationIdentifier:@"MMDrawer"];
        [self.drawerController setMaximumLeftDrawerWidth:200.0];
        [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
        [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
        [self.view addSubview:self.drawerController.view];
    }
    
    [self.view addSubview:self.drawerController.view];

}

-(void)userDidSelectAnnotation:(eventObject *)currentevent{
    
     //NSLog(@"performSuge");
    
    [self performSegueWithIdentifier:@"socialStream" sender:currentevent];
    
    //JCSocailStreamController *socialStream = [[JCSocailStreamController alloc]initWithTitle:currentevent];
    //[self.centerVC pushViewController:socialStream animated:YES];
//    
//    
//    [self.centerVC presentViewController:socialStream animated:YES completion:nil];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"socialStream"])
    {
        
        UINavigationController *navController = (UINavigationController*)[segue destinationViewController];
       
        JCSocailStreamController *jc = [navController viewControllers][0];
        jc.JCSocailStreamControllerDelegate = self;
        jc.currentevent = sender;
 
    }
}

-(void)SocialStreamViewControllerDidSelectDone:(JCSocailStreamController *)controller{
    
    
    [self dismissViewControllerAnimated:YES completion:nil];

};

- (void)viewDidLoad {
    [super viewDidLoad];
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
