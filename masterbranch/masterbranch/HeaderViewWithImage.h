//
//  HeaderViewWithImage.h
//  Example
//
//  Created by Marek Serafin on 13/10/14.
//  Copyright (c) 2014 Marek Serafin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderViewWithImage : UIView

+ (instancetype)instantiateFromNib;
@property (weak, nonatomic) IBOutlet UIImageView *HeaderImageView;
@property (weak, nonatomic) IBOutlet UILabel *ArtistName;

@end
