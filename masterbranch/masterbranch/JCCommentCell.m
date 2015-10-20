//
//  JCCommentCell.m
//  PreAmp
//
//  Created by james cash on 07/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCCommentCell.h"

@implementation JCCommentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
    // Configure the view for the selected state
}



//mathod to calculates that hight of the text so we later set dynamic hights for the table view 
-(float )getCommentHeight :(NSString *)text Width :(float)textWidth
{
    
    NSAttributedString *attributedText =
    [[NSAttributedString alloc]
     initWithString:text
     attributes:@
     {
     NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Bold" size:19.0]
     }];
    
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){textWidth, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize finalSize = rect.size;
    return finalSize.height;  }
@end
