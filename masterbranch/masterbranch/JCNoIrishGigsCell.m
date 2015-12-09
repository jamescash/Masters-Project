//
//  JCNoIrishGigsCell.m
//  PreAmp
//
//  Created by james cash on 01/12/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCNoIrishGigsCell.h"

@interface JCNoIrishGigsCell ()
@property (weak, nonatomic) IBOutlet UIImageView *UIImageIconView;
@property (weak, nonatomic) IBOutlet UILabel *UILableMainText;


@end

@implementation JCNoIrishGigsCell


-(void)formateCellWithText:(NSString*)cellText{
    self.UILableMainText.text = cellText;
}

- (void)awakeFromNib {
    self.UIImageIconView.image = [UIImage imageNamed:@"iconSadFace"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
