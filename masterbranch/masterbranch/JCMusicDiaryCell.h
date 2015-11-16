//
//  JCMusicDiaryCell.h
//  PreAmp
//
//  Created by james cash on 11/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCMusicDiaryCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *artistName;
@property (weak, nonatomic) IBOutlet UIImageView *backRoundImage;

-(void)formatcellWithArtistName:(NSString*)artistName;

@end
