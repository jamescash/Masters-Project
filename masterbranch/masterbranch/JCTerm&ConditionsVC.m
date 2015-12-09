//
//  JCTerm&ConditionsVC.m
//  PreAmp
//
//  Created by james cash on 03/12/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCTerm&ConditionsVC.h"

@interface JCTerm_ConditionsVC ()
@property (weak, nonatomic) IBOutlet UIWebView *UIWebView;

@end

@implementation JCTerm_ConditionsVC

-(void)LoadWebViewWithaddress:(NSString*)webAddress{
    
    NSString *urlString = webAddress;
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.UIWebView loadRequest:urlRequest];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self LoadWebViewWithaddress:self.url];
    [self addCustomButtonOnNavBar];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addCustomButtonOnNavBar
{
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [menuButton setImage:[UIImage imageNamed:@"iconDown.png"] forState:UIControlStateNormal];
    //[menuButton setImage:[UIImage imageNamed:@"iconMenu.png"] forState:UIControlStateHighlighted];
    menuButton.adjustsImageWhenDisabled = NO;
    //set the frame of the button to the size of the image (see note below)
    menuButton.frame = CGRectMake(0, 0, 40, 40);
    menuButton.opaque = YES;
    
    [menuButton addTarget:self action:@selector(menuButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    //create a UIBarButtonItem with the button as a custom view
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    self.navigationItem.leftBarButtonItem = customBarItem;
  
    
}

-(void)menuButtonPressed{
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
