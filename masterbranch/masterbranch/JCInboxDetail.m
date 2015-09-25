//
//  JCInboxDetail.m
//  PreAmp
//
//  Created by james cash on 20/09/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCInboxDetail.h"

@interface JCInboxDetail ()
@property (weak, nonatomic) IBOutlet UIImageView *ImageView;
@end

@implementation JCInboxDetail

- (void)viewDidLoad {
    [super viewDidLoad];

    PFFile *imageFile = [self.message objectForKey:@"file"];
    NSURL *imageFileURL = [[NSURL alloc]initWithString:imageFile.url];
    NSData *imageData = [NSData dataWithContentsOfURL:imageFileURL];
    self.ImageView.image = [UIImage imageWithData:imageData];
    self.ImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    NSString *senderName = [self.message objectForKey:@"senderName"];
    NSString *title = [NSString stringWithFormat:@"sent from: %@",senderName];
    self.navigationItem.title = title;
    

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
