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


@interface JCEventInviteCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PFImageView *BackRoundImage;
//@property (strong, nonatomic) IBOutlet PFImageView *BackRoundImage;

-(void)formatCell:(PFObject*)currentEvent;

@end
