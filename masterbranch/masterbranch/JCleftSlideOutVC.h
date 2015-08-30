//
//  JCleftSlideOutVC.h
//  masterbranch
//
//  Created by james cash on 17/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import <Parse/Parse.h>


@protocol JCleftSlideOutVCDelegat;

@interface JCleftSlideOutVC : UIViewController<UITableViewDataSource, UITableViewDelegate, RESideMenuDelegate>
@property (strong,nonatomic) id <JCleftSlideOutVCDelegat>JCleftSlideOutVCDelegat;
@end

@protocol JCleftSlideOutVCDelegat <NSObject>
-(void)UserSelectedLogOut;
@end