//
//  JChappeningLaterSS.m
//  masterbranch
//
//  Created by james cash on 29/06/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "JChappeningLaterSS.h"
#import "JChappeningLaterHeader.h"



#define BUFFERX 10 //distance from side to the card (higher makes thinner card)
#define BUFFERY 20 //distance from top to the card (higher makes shorter card)

@interface JChappeningLaterSS ()

@end

@implementation JChappeningLaterSS

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
    JChappeningLaterHeader* cardView= [[JChappeningLaterHeader alloc]initWithFrame:CGRectMake(BUFFERX, BUFFERY, self.view.frame.size.width-2*BUFFERX, self.view.frame.size.height-2*BUFFERY)];
    
    cardView.coverImageView.image = self.currentenven.coverpic.image;
    cardView.profileImageView.image = self.currentenven.coverpic.image;
    cardView.titleLabel.text = self.currentenven.eventTitle;
    cardView.delegate = self;
    //[cardView addBlur];
    //[cardView addShadow];
    [self.view addSubview:cardView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// Optional RKCardViewDelegate methods

-(void)nameTap {
    NSLog(@"Taped on name");
}

-(void)coverPhotoTap {
    NSLog(@"Taped on cover photo");
}

-(void)profilePhotoTap {
    NSLog(@"Taped on profile photo");
}
@end
