//
//  JCCustomCollectionCell.h
//  masterbranch
//
//  Created by james cash on 21/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DGActivityIndicatorView.h"
#import "JCMusicDiaryArtistObject.h"


@interface JCCustomCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *MainImageView;
@property (weak, nonatomic) IBOutlet UILabel *CellTitle;
@property (weak, nonatomic) IBOutlet UILabel *venue;
@property (strong,nonatomic ) CAGradientLayer *vignetteLayer;
@property (weak, nonatomic) IBOutlet UIImageView *UIImageMusicDiaryBG;
//@property (weak, nonatomic) IBOutlet UILabel *UILableNumberOfGigsThisMonth;

-(void)startLoadingAnimation;
-(void)stopLoadingAnimation;
-(void)removeVinettLayer;
-(void)addVinettLayer;

-(void)setImageForMusicDiary:(UIImage*)image andArtistNamr:(NSString*)artistName andVenueName:(NSString*)venueName;
-(void)formatCellWithDiryObject:(JCMusicDiaryArtistObject*)diaryObject andArtist:(PFObject*)artist;
-(void)setImage:(UIImage*)image andArtistNamr:(NSString*)artistName andVenueName:(NSString*)venueName;
@property (strong,nonatomic ) DGActivityIndicatorView *activityIndicatorView;

@end

