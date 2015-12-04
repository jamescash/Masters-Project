//
//  JCGigsComingUpInThisMonthVC.h
//  PreAmp
//
//  Created by james cash on 23/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "UIScrollView+VGParallaxHeader.h"
#import "JCMusicDiaryArtistObject.h"
#import <MGSwipeTableCell/MGSwipeTableCell.h>
#import "JCUpcomingGigTableViewCell.h"





@interface JCGigsComingUpInThisMonthVC : UIViewController <MGSwipeTableCellDelegate,JCUpcomingGigTableViewCellDelegate,UIActionSheetDelegate>
@property (nonatomic,strong)JCMusicDiaryArtistObject *diaryObject;
@property (nonatomic) BOOL IsIrishQuery;
@end
