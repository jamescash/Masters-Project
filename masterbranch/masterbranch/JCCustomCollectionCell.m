//
//  JCCustomCollectionCell.m
//  masterbranch
//
//  Created by james cash on 21/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "JCCustomCollectionCell.h"

@interface JCCustomCollectionCell()

@end

@implementation JCCustomCollectionCell

-(void)setImage:(UIImage*)image andArtistNamr:(NSString*)artistName andVenueName:(NSString*)venueName{
    
    self.MainImageView.image = image;
    self.MainImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.MainImageView = [self addLayerMaskToImageView:self.MainImageView];
    self.CellTitle.text = artistName;
    self.venue.text = venueName;
}

-(void)startLoadingAnimation{
    
    if (!self.activityIndicatorView) {
//        self.activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallScaleMultiple tintColor:[UIColor colorWithRed:234.0f/255.0f green:65.0f/255.0f blue:150.0f/255.0f alpha:1.0f] size:50.0f];
        
    self.activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallScaleMultiple tintColor:[UIColor whiteColor] size:50.0f];
      self.activityIndicatorView.frame = CGRectMake((self.frame.size.width/2)-25, (self.frame.size.height/2)-25, 50.0f, 50.0f);
      [self addSubview:self.activityIndicatorView];
    }else{
        [self addSubview:self.activityIndicatorView];
    }
    
    [self.activityIndicatorView startAnimating];
}
-(void)stopLoadingAnimation{
    [self.activityIndicatorView stopAnimating];
    //[self.activityIndicatorView removeFromSuperview];
}

-(void)addVinettLayer{
    
    if (!self.vignetteLayer) {
        self.vignetteLayer = [CAGradientLayer layer];
        [self.vignetteLayer setBounds:[self bounds]];
        [self.vignetteLayer setPosition:CGPointMake([self bounds].size.width/2.0f, [self bounds].size.height/2.0f)];
        UIColor *lighterBlack = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.6];
        [self.vignetteLayer setColors:@[(id)[[UIColor clearColor] CGColor], (id)[lighterBlack CGColor]]];
        [self.vignetteLayer setLocations:@[@(.40), @(1.0)]];
    }
    [[self.MainImageView layer] addSublayer:self.vignetteLayer];

    
}
-(void)removeVinettLayer{
    
    [self.vignetteLayer removeFromSuperlayer];
    
}
-(UIImageView*)addLayerMaskToImageView:(UIImageView*)imageView{
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(0,0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    maskLayer.path = maskPath.CGPath;
    imageView.layer.mask = maskLayer;
    return imageView;
}

@end
