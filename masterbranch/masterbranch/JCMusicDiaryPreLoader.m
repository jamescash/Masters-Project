//
//  JCMusicDiaryPreLoader.m
//  PreAmp
//
//  Created by james cash on 23/11/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCMusicDiaryPreLoader.h"
#import "DGActivityIndicatorView.h"

@implementation JCMusicDiaryPreLoader

+ (instancetype)instantiateFromNib
{
    
  NSArray *views = [[NSBundle mainBundle] loadNibNamed:[NSString stringWithFormat:@"%@", [self class]] owner:nil options:nil];
      
    JCMusicDiaryPreLoader *returnView = [views firstObject];
    
    
    
    return returnView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
