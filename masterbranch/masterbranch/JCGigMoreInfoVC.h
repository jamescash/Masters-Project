//
//  JCGigMoreInfoVC.h
//  PreAmp
//
//  Created by james cash on 16/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eventObject.h"
#import "UIScrollView+VGParallaxHeader.h"
#import <MGSwipeTableCell/MGSwipeTableCell.h>
#import "JCInvteFollowHeaderVC.h"
#import "JCUpcomingGigTableViewCell.h"
#import "GAITrackedViewController.h"
#import "JCTimeDateLocationTableViewCell.h"
#import "JCUpcomingGigTableViewCell.h"
#import "JCToastAndAlertView.h"


@protocol JCGigMoreInfoVC;


@interface JCGigMoreInfoVC : GAITrackedViewController <UITableViewDataSource,UITableViewDelegate,MGSwipeTableCellDelegate,JCInvteFollowHeaderDelegate,JCUpcomingGigTableViewCellDelegate,UIActionSheetDelegate,JCTimeDateLocationTableViewCell,JCUpcomingGigTableViewCellDelegate>
@property (nonatomic,strong)eventObject *currentEvent;
@property (nonatomic, weak) id <JCGigMoreInfoVC> JCGigMoreInfoVCDelegate;
@end

@protocol JCGigMoreInfoVC <NSObject>
- (void)JCGigMoreInfoVCDidSelectDone:(JCGigMoreInfoVC *)controller;
@end