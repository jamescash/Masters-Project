//
//  JCInvtivedDetail.m
//  PreAmp
//
//  Created by james cash on 08/11/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCInvtivedDetail.h"

@interface JCInvtivedDetail ()

@end

@implementation JCInvtivedDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavBarForPeopleAttendingGig];
    //[self setNeedsStatusBarAppearanceUpdate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (UIStatusBarStyle) preferredStatusBarStyle {
//    return UIStatusBarStyleDefault;
//}


- (void)addNavBarForPeopleAttendingGig
{
    
    
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage im];
    //imageView.alpha = 0.5; //Alpha runs from 0.0 to 1.0
    
    [backButton setImage:[UIImage imageNamed:@"iconCancle.png"] forState:UIControlStateNormal];
    backButton.adjustsImageWhenDisabled = NO;
    //set the frame of the button to the size of the image (see note below)
    backButton.frame = CGRectMake(0, 0, 40, 40);
    //backButton.opaque = YES;
    
    [backButton addTarget:self action:@selector(BackButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    //create a UIBarButtonItem with the button as a custom view
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    //pageController.navigationController.navigationBar.topItem.titleView = navigationView;
    
    
    self.navigationItem.leftBarButtonItem = customBarItem;
    
    
}

-(void)BackButtonPressed{
    [self dismissViewControllerAnimated:YES completion:nil];
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
