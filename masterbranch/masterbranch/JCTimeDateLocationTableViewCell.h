//
//  JCTimeDateLocationTableViewCell.h
//  PreAmp
//
//  Created by james cash on 16/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eventObject.h"
#import <Parse/Parse.h>


@protocol JCTimeDateLocationTableViewCell;


@interface JCTimeDateLocationTableViewCell : UITableViewCell
-(void)formatCell:(eventObject*)currentEvent;
-(void)formatCellwithParseEventObject:(PFObject*)currentEvent;
-(void)formatCellwithParseEventObjectForSingleEvent:(PFObject*)currentEvent;
-(void)formatAreYouGoingButtonTitleWithMyStatus:(NSString*)myStatus;
@property (nonatomic, weak) id <JCTimeDateLocationTableViewCell> JCTimeDateLocationTableViewCellDelagate;
@end


@protocol JCTimeDateLocationTableViewCell <NSObject>
- (void)didTapShowGigMoreInfo;
@end