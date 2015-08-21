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
#import "MMDrawerVisualState.h"
//#import "MMExampleDrawerVisualStateManager.h"

//Navigation Controller
#import "NavigtionViewController.h"


//#import <QuartzCore/QuartzCore.h>

//loging screen
#import "JCloginVC.h"


//left slide out VC for hambugermenu
#import "JCleftSlideOutVC.h"


#import "JCHappeningTonightVC.h"

@interface JChomeScreenVC ()

@property (nonatomic,strong) MMDrawerController * drawerController;
@property (nonatomic,strong) UINavigationController *centerVC;

@end

@implementation JChomeScreenVC



-(void)viewWillAppear:(BOOL)animated{
    
     if (!self.drawerController) {
        
        JCHomeMainScreenVC *center = [[JCHomeMainScreenVC alloc]init];
        center.MainScreenCollectionViewDelegate = self;
    
        //Iinit left side menue
        JCleftSlideOutVC *left = [[JCleftSlideOutVC alloc]init];
        
        //creat the top nav bars and add them to the super VC'S
         _centerVC = [[NavigtionViewController alloc] initWithRootViewController:center];
        
       
         

        UINavigationController * leftVC = [[NavigtionViewController alloc] initWithRootViewController:left];
        
        //init drawer ontroler class with my ViewControllers
        self.drawerController = [[MMDrawerController alloc]initWithCenterViewController:self.centerVC leftDrawerViewController:leftVC];
        [self.drawerController setShowsShadow:YES];
    
        //[self.drawerController setRestorationIdentifier:@"MMDrawer"];
        [self.drawerController setMaximumLeftDrawerWidth:200.0];
        [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
        [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
        [self.view addSubview:self.drawerController.view];
    }
    
    [self.view addSubview:self.drawerController.view];

}




#pragma DelegateMethods


-(void)userDidSelectAnnotation:(eventObject *)currentevent{
    
    
    if ([currentevent.status isEqualToString:@"alreadyHappened"]) {
        [self performSegueWithIdentifier:@"socialStream" sender:currentevent];
    }
    
    if ([currentevent.status isEqualToString:@"happeningLater"]) {
       
        [self performSegueWithIdentifier:@"ShowSocialStreamHappiningLater" sender:currentevent];

    }
    
}


-(void)userDidSelectSearchIcon{
    
    [self performSegueWithIdentifier:@"ShowSearchPage" sender:nil];
    
};





-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"socialStream"])
    {
        
        UINavigationController *navController = (UINavigationController*)[segue destinationViewController];
       
        JCSocailStreamController *jc = [navController viewControllers][0];
        jc.JCSocailStreamControllerDelegate = self;
        jc.currentevent = sender;
 
    }
    
    if ([segue.identifier isEqualToString:@"ShowSearchPage"]) {
        
       UINavigationController *navController = (UINavigationController*)[segue destinationViewController];
        
        JCSearchPage *jc = [navController viewControllers][0];
        jc.JCSearchPageDelegate = self;
    
    }
    
    if ([segue.identifier isEqualToString:@"ShowSocialStreamHappiningLater"]) {
        
        UINavigationController *navController = (UINavigationController*)[segue destinationViewController];
        
        JCHappeningTonightVC *jc = [navController viewControllers][0];
       
        jc.currentEvent = sender;
        
        // jc.JCSearchPageDelegate = self;
    }
    
    
}

-(void)JCSearchPageDidSelectDone:(JCSearchPage *)controller{
    
    [self dismissViewControllerAnimated:YES completion:nil];
};


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
