//
//  LogginScreenOne.h
//  PreAmp
//
//  Created by james cash on 13/11/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <Parse/Parse.h>
#import "GAITrackedViewController.h"
#import "JCTutorialPageViewController.h"

@interface LogginScreenOne : GAITrackedViewController //<UIPageViewControllerDataSource>//<GHWalkThroughViewDataSource,GHWalkThroughViewDelegate>

//@property (strong, nonatomic) UIPageViewController *pageViewController;
//@property (strong, nonatomic) NSArray *pageTitles;
@property NSUInteger pageIndex;
@end
