//
//  JCCustomCollectionCell.m
//  masterbranch
//
//  Created by james cash on 21/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "JCCustomCollectionCell.h"
@interface JCCustomCollectionCell()
@property (strong,nonatomic ) CAGradientLayer *vignetteLayer;

@end

@implementation JCCustomCollectionCell

-(void)setImage:(UIImage*)image andArtistNamr:(NSString*)artistName andVenueName:(NSString*)venueName{
    

    self.MainImageView.image = image;
    self.MainImageView.contentMode = UIViewContentModeScaleToFill;
    self.CellTitle.text = artistName;
    self.venue.text = venueName;
        [self addVinettLayer];
}


-(void)addVinettLayer{
    if (!self.vignetteLayer) {
        self.vignetteLayer = [CAGradientLayer layer];
        [self.vignetteLayer setBounds:[self.MainImageView bounds]];
        [self.vignetteLayer setPosition:CGPointMake([self.MainImageView bounds].size.width/2.0f, [self.MainImageView bounds].size.height/2.0f)];
        UIColor *lighterBlack = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.9];
        [self.vignetteLayer setColors:@[(id)[[UIColor clearColor] CGColor], (id)[lighterBlack CGColor]]];
        [self.vignetteLayer setLocations:@[@(.30), @(1.0)]];
        [[self.MainImageView layer] addSublayer:self.vignetteLayer];
    }
    
}

@end
