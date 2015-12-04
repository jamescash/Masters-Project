//
//  JCTutorialPageViewController.h
//  PreAmp
//
//  Created by james cash on 03/12/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCTutorialPageViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *UILablePageTitle;
@property NSUInteger pageIndex;
@property NSString *titleText;
@property NSString *imageFile;

@end
