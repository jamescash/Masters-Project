//
//  JCSearchResultsHeaderView.m
//  PreAmp
//
//  Created by james cash on 02/12/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCSearchResultsHeaderView.h"

@implementation JCSearchResultsHeaderView

+ (instancetype)instantiateFromNib
{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:[NSString stringWithFormat:@"%@", [self class]] owner:nil options:nil];
    return [views firstObject];
}

@end
