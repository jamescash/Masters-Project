//
//  JCCustomCollectionCell.h
//  masterbranch
//
//  Created by james cash on 21/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCCustomCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *MainImageView;
@property (weak, nonatomic) IBOutlet UILabel *CellTitle;
@property (weak, nonatomic) IBOutlet UILabel *venue;
-(void)setImage:(UIImage*)image andArtistNamr:(NSString*)artistName andVenueName:(NSString*)venueName;
@end
