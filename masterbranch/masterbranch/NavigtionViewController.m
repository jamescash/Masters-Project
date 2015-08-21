//
//  NavigtionViewController.m
//  masterbranch
//
//  Created by james cash on 09/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "NavigtionViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"


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




- (instancetype)init
{
    self = [super init];
    if (self) {
        // create the magnifying glass button
       
    }
    return self;
}








//-(void)viewDidLoad:(BOOL)animated{
    
//    
//    NSLog(@"nAV BAR DID LOAD");
//    
//    UIColor * barColor = [UIColor
//                          colorWithRed:247.0/255.0
//                          green:249.0/255.0
//                          blue:250.0/255.0
//                          alpha:1.0];
//    self.navigationBar.barTintColor = barColor;
//    //[self.navigationBar setBarTintColor:barColor];
//    [self.view.layer setCornerRadius:10.0f];
//    self.title = @"PreAmp";
//    
//    [self setupLeftMenuButton];



//};

//-(void)setupLeftMenuButton{
//    
//    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self.navigationBar action:@selector(leftDrawerButtonPress:)];
//    
//    //MMDrawerBarButtonItem *left = [self]
//    
//    self.navigationItem.leftBarButtonItem = leftDrawerButton;
//    
//    
//    //[self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
//}
//
//
//
//-(void)leftDrawerButtonPress:(id)sender{
//    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
//    
//}

@end
