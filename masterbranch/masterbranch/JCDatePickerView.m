//
//  JCDatePickerView.m
//  PreAmp
//
//  Created by james cash on 28/09/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCDatePickerView.h"
#import "JCDatePickerDaysOfWeekView.h"
#import "JCDatePickerDayCell.h"



@implementation JCDatePickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(Class)daysOfWeekViewClass{
    [super daysOfWeekViewClass];
    return [JCDatePickerDaysOfWeekView class];
}


-(Class)dayCellClass{
    [super dayCellClass];
    return [JCDatePickerDayCell class];
}


@end
