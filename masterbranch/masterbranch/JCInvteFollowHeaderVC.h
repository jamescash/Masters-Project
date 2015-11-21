//
//  JCInvteFollowHeaderVC.h
//  PreAmp
//
//  Created by james cash on 16/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eventObject.h"

@protocol JCInvteFollowHeaderDelegate;

@interface JCInvteFollowHeaderVC : UITableViewCell
@property (weak, nonatomic) id<JCInvteFollowHeaderDelegate>JCInvteFollowHeaderDelegate;
@property (nonatomic)BOOL userIsFollowingArtist;
@property (nonatomic)BOOL userIsInTerestedInGoing;

-(void)formatCellButtons:(BOOL)userIsFollowingArtist and: (BOOL)userIsInterested;
@end


@protocol JCInvteFollowHeaderDelegate <NSObject>
- (void)didClickFollowArtistButton:(BOOL)userIsFollowingArtist;
- (void)didClickImIntrested:(BOOL)userIsInterested;
@end