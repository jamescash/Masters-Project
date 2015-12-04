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
    //self.MainImageView = [self addLayerMaskToImageView:self.MainImageView withConorRadious:0];
    
    self.MainImageView = [self addLayerMaskToImageView:self.MainImageView withConorRadious:0 width:self.frame.size.width height:self.frame.size.height frameinsetX:0 frameInsetY:0];
    self.CellTitle.text = artistName;
    self.venue.text = venueName;
}

-(void)setImageForMusicDiary:(UIImage*)image andArtistNamr:(NSString*)artistName andVenueName:(NSString*)venueName{
    
    //self.backgroundColor = [UIColor colorWithRed:239.0f/255.0f green:239.0f/255.0f blue:244.0f/255.0f alpha:.6f];

    //[self prefix_addUpperBorder];
    self.MainImageView.image = image;
    self.MainImageView.contentMode = UIViewContentModeScaleAspectFill;
    //self.MainImageView = [self addLayerMaskToImageView:self.MainImageView withConorRadious:150];
    
    self.MainImageView = [self addLayerMaskToImageView:self.MainImageView withConorRadious:self.MainImageView.frame.size.width/2 width:90 height:90 frameinsetX:4 frameInsetY:10];
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

//- (void)prefix_addUpperBorder
//{
//    CALayer *upperBorder = [CALayer layer];
//    upperBorder.backgroundColor = [[UIColor lightGrayColor] CGColor];
//    upperBorder.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 2.0f);
//    [self.layer addSublayer:upperBorder];
//}


-(UIImageView*)addLayerMaskToImageView:(UIImageView*)imageView withConorRadious: (int)conorRadious width:(int)width height:(int)height frameinsetX:(int)insetX frameInsetY:(int)insetY {
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, width, height) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(conorRadious,conorRadious)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(insetY, insetX, width, height);
    maskLayer.path = maskPath.CGPath;
    imageView.layer.mask = maskLayer;
    return imageView;
}

@end
