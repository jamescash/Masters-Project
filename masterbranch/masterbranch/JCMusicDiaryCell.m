//
//  JCMusicDiaryCell.m
//  PreAmp
//
//  Created by james cash on 11/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCMusicDiaryCell.h"

@interface JCMusicDiaryCell ()
@property (strong,nonatomic ) CAGradientLayer *vignetteLayer;

@end

@implementation JCMusicDiaryCell

-(void)formatcellWithArtistName:(NSString *)artistName{
    
    self.backRoundImage = [self addLayerMaskToImageView:self.backRoundImage];
    [self addVinettLayer];
    self.artistName.text = artistName;
    
}

-(void)addVinettLayer{
    
    if (!self.vignetteLayer) {
        self.vignetteLayer = [CAGradientLayer layer];
        [self.vignetteLayer setBounds:[self bounds]];
        [self.vignetteLayer setPosition:CGPointMake([self bounds].size.width/2.0f, [self bounds].size.height/2.0f)];
        UIColor *lighterBlack = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.6];
        [self.vignetteLayer setColors:@[(id)[[UIColor clearColor] CGColor], (id)[lighterBlack CGColor]]];
        [self.vignetteLayer setLocations:@[@(.40), @(1.0)]];
        [[self.backRoundImage layer] addSublayer:self.vignetteLayer];
    }
}

-(UIImageView*)addLayerMaskToImageView:(UIImageView*)imageView{
    UIBezierPath *maskPath;
    
    //make the mask the size of the cell rather than the image view this was causing probllem took ages to solve bug
    maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(0,0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    maskLayer.path = maskPath.CGPath;
    imageView.layer.mask = maskLayer;
    return imageView;
}

@end
