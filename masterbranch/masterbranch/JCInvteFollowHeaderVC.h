//
//  JCInvteFollowHeaderVC.h
//  PreAmp
//
//  Created by james cash on 16/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JCInvteFollowHeaderDelegate;

@interface JCInvteFollowHeaderVC : UITableViewCell
@property (weak, nonatomic) id<JCInvteFollowHeaderDelegate>JCInvteFollowHeaderDelegate;
@property (nonatomic)BOOL userIsFollowingArtist;
-(void)formatCellButtons:(BOOL)userIsFollowingArtist;
@end


@protocol JCInvteFollowHeaderDelegate <NSObject>
- (void)didClickFollowArtistButton:(BOOL)userIsFollowingArtist;
@end