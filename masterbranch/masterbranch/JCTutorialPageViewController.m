//
//  JCTutorialPageViewController.m
//  PreAmp
//
//  Created by james cash on 03/12/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCTutorialPageViewController.h"

@interface JCTutorialPageViewController ()

@end

@implementation JCTutorialPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.UILablePageTitle.text = self.titleText;
    self.UIImageTutorialImage.image = [UIImage imageNamed:self.imageFile];
    self.UIImageTutorialImage.contentMode = UIViewContentModeScaleAspectFit;
    self.UILabledesciption.text = self.LableDescription;
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
