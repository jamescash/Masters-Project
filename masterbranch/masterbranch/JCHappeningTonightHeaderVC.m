//
//  JCHappeningTonightHeaderVC.m
//  masterbranch
//
//  Created by james cash on 23/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "JCHappeningTonightHeaderVC.h"


@interface JCHappeningTonightHeaderVC ()
@property (weak, nonatomic) IBOutlet UIView *test;
@property (weak, nonatomic) IBOutlet UILabel *testlable;
@property (weak, nonatomic) IBOutlet UITextView *AristINformationTextFiled;
@property (weak, nonatomic) IBOutlet MKMapView *EventLocation;

//@property (weak, nonatomic) IBOutlet UILabel *testlable;

@end

@implementation JCHappeningTonightHeaderVC

- (void)viewDidLoad {
    [super viewDidLoad];
   // self.TestView = [[self.TestView all]]
    // Do any additional setup after loading the view.
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
