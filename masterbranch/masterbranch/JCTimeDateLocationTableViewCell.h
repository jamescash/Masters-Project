//
//  JCTimeDateLocationTableViewCell.h
//  PreAmp
//
//  Created by james cash on 16/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eventObject.h"


@interface JCTimeDateLocationTableViewCell : UITableViewCell
-(void)formatCell:(eventObject*)currentEvent;
@end
