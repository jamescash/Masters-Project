//
//  NavigtionViewController.m
//  masterbranch
//
//  Created by james cash on 09/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "NavigtionViewController.h"
#import "UIViewController+MMDrawerController.h"


@interface NavigtionViewController ()

@end

@implementation NavigtionViewController


-(UIStatusBarStyle)preferredStatusBarStyle{
    if(self.mm_drawerController.showsStatusBarBackgroundView){
        return UIStatusBarStyleLightContent;
    }
    else {
        return UIStatusBarStyleDefault;
    }
}

@end
