//
//  JCMyArtistCell.h
//  PreAmp
//
//  Created by james cash on 21/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@protocol JCMyArtistCellDelegate;


@interface JCMyArtistCell : UITableViewCell

@property (weak, nonatomic) IBOutlet PFImageView *artistImage;
@property (weak, nonatomic) id<JCMyArtistCellDelegate>JCMyArtistCellDelegate;
@property (assign, nonatomic) NSInteger cellIndex;
-(void)formatCell:(PFObject*)artist;

@end

@protocol JCMyArtistCellDelegate <NSObject>
- (void)didClickUnFollowArtistButton:(NSInteger)cellIndex;
@end