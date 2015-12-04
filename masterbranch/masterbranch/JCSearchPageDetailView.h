//
//  JCSearchPageDetailView.h
//  PreAmp
//
//  Created by james cash on 01/12/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+EmptyDataSet.h"
#import "JCUpcomingGigTableViewCell.h"



@interface JCSearchPageDetailView : UIViewController <DZNEmptyDataSetDelegate,DZNEmptyDataSetSource,JCUpcomingGigTableViewCellDelegate,UIActionSheetDelegate>
@property (nonatomic,strong)NSString *artistName;
@property (nonatomic,strong)UIImage *artistImage;

@end
