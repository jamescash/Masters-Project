//
//  JCUserProfile.m
//  PreAmp
//
//  Created by james cash on 20/11/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCUserProfile.h"
#import "RKSwipeBetweenViewControllers.h"
#import "RESideMenu.h"

@interface JCUserProfile ()

@end

@implementation JCUserProfile

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customiseNavBar];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customiseNavBar
{
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage im];
    //imageView.alpha = 0.5; //Alpha runs from 0.0 to 1.0
    
    [menuButton setImage:[UIImage imageNamed:@"iconMenu.png"] forState:UIControlStateNormal];
    //[menuButton setImage:[UIImage imageNamed:@"iconMenu.png"] forState:UIControlStateHighlighted];
    menuButton.adjustsImageWhenDisabled = NO;
    //set the frame of the button to the size of the image (see note below)
    menuButton.frame = CGRectMake(0, 0, 40, 40);
    menuButton.opaque = YES;
    
    [menuButton addTarget:self action:@selector(BackButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    //create a UIBarButtonItem with the button as a custom view
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    
    self.navigationItem.title = @"Profile Page (Under construction)";
    
    self.navigationItem.leftBarButtonItem = customBarItem;
    
    self.navigationItem.hidesBackButton = YES;
    
    
}
-(void)BackButtonPressed{
    [self.sideMenuViewController presentLeftMenuViewController];
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
