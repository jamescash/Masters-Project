//
//  JCDatePickerDayCell.m
//  PreAmp
//
//  Created by james cash on 28/09/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCDatePickerDayCell.h"

@implementation JCDatePickerDayCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (UIFont *)dayLabelFont{
    [super dayLabelFont];
    
    return [UIFont fontWithName:@"Helvetica-Bold" size:20];
}

@end
