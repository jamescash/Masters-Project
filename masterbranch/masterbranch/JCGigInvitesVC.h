//
//  JCGigInvitesVC.h
//  PreAmp
//
//  Created by james cash on 05/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCDropDownMenu.h"
#import <MGSwipeTableCell/MGSwipeTableCell.h>
#import "UIScrollView+EmptyDataSet.h"
#import "GAITrackedViewController.h"



@interface JCGigInvitesVC : GAITrackedViewController <UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,JCDropDownMenuDelagte,MGSwipeTableCellDelegate,UIAlertViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>

@end


