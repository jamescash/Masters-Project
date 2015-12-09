//
//  JCTutorialRootVC.h
//  PreAmp
//
//  Created by james cash on 03/12/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCTutorialPageViewController.h"


@interface JCTutorialRootVC : UIViewController <UIPageViewControllerDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *UIImageBG;

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;
@property (strong, nonatomic) NSArray *textDiscription;


@end
