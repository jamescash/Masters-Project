//
//  JCEventInviteCell.h
//  PreAmp
//
//  Created by james cash on 10/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <MGSwipeTableCell/MGSwipeTableCell.h>


@interface JCEventInviteCell : MGSwipeTableCell
@property (weak, nonatomic) IBOutlet PFImageView *BackRoundImage;
@property (nonatomic,strong) NSIndexPath *indexPath;
//@property (strong, nonatomic) IBOutlet PFImageView *BackRoundImage;

-(void)formatCell:(PFObject*)currentEvent;

@end
