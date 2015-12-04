//
//  JCUserProfileHeaderView.m
//  PreAmp
//
//  Created by james cash on 26/11/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCUserProfileHeaderView.h"

@implementation JCUserProfileHeaderView


+ (instancetype)instantiateFromNib
{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:[NSString stringWithFormat:@"%@", [self class]] owner:nil options:nil];
    return [views firstObject];
}


@end
