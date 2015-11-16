//
//  JCSortButtonsCell.m
//  PreAmp
//
//  Created by james cash on 15/11/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCSortButtonsCell.h"

@interface JCSortButtonsCell ()

@property (weak, nonatomic) IBOutlet UIButton *buttonSortDistance;
@property (weak, nonatomic) IBOutlet UIButton *buttonSortDate;


@end

@implementation JCSortButtonsCell


-(void)buttonSortByDateClicked{
    
        NSLog(@"clicked");
         //self.buttonSortDistance = [[UIButton alloc]init];
         //[self.buttonSortDate setTitle:@"clicked" forState:UIControlStateNormal];
        self.buttonSortDate.backgroundColor = [UIColor whiteColor];
    
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
