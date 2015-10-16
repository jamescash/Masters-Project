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



@interface JCUpcomingGigTableViewCell : MGSwipeTableCell
-(void)formatCell:(eventObject*)currentEvent;
@end
