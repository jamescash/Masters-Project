//
//  JCCustomCollectionCell.m
//  masterbranch
//
//  Created by james cash on 21/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "JCCustomCollectionCell.h"

@implementation JCCustomCollectionCell

-(void)setImage:(UIImage*)image andArtistNamr:(NSString*)artistName andVenueName:(NSString*)venueName{
    
    dispatch_async(dispatch_get_main_queue(), ^{

    self.MainImageView.image = image;
    self.MainImageView.contentMode = UIViewContentModeScaleToFill;
    self.CellTitle.text = artistName;
    self.venue.text = venueName;
    });
}


@end
