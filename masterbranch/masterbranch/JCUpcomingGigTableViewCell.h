//
//  JCUpcomingGigTableViewCell.h
//  PreAmp
//
//  Created by james cash on 16/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eventObject.h"
#import <MGSwipeTableCell/MGSwipeTableCell.h>
#import <Parse/Parse.h>


@protocol JCUpcomingGigTableViewCellDelegate;


@interface JCUpcomingGigTableViewCell : MGSwipeTableCell
-(void)formatCell:(eventObject *)currentEvent userIsInterested:(BOOL)userIsInterested;
-(void)formatCellwith:(PFObject*)upcomingGig userIsInterested:(BOOL)userIsInterested;
@property (assign, nonatomic) NSInteger cellIndex;
@property (strong, nonatomic) NSIndexPath *cellIndexNSIndexPath;
@property (weak, nonatomic) id <JCUpcomingGigTableViewCellDelegate>JCUpcomingGigTableViewCellDelegate;
@end


@protocol JCUpcomingGigTableViewCellDelegate <NSObject>
@optional
- (void)didClickInviteFriendsOnUpcomingGigAt:(NSInteger)cellIndex;
@optional
- (void)didClickInviteFriendsOnUpcomingGigAtNSIndexPath:(NSIndexPath*)cellIndex;
@end