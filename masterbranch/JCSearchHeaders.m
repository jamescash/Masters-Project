//
//  JCSearchHeaders.m
//  PreAmp
//
//  Created by james cash on 14/11/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCSearchHeaders.h"

@interface JCSearchHeaders()
    @property (weak, nonatomic) IBOutlet UILabel *lableTitle;
@end

@implementation JCSearchHeaders

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)formatHeaderWithTitle:(NSString *)title{
    
    self.lableTitle.text = title;
    self.lableTitle.textColor = [UIColor colorWithRed:234.0f/255.0f green:65.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    
}

@end
