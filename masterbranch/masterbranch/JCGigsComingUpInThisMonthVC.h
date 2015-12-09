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
#import "JCUpcomingGigTableViewCell.h"//Upcoming Cells 

#import <MGSwipeTableCell/MGSwipeTableCell.h>//https://github.com/MortimerGoro/MGSwipeTableCell




@interface JCGigsComingUpInThisMonthVC : UIViewController <MGSwipeTableCellDelegate,JCUpcomingGigTableViewCellDelegate,UIActionSheetDelegate,JCUpcomingGigTableViewCellDelegate>
@property (nonatomic,strong)JCMusicDiaryArtistObject *diaryObject;
@property (nonatomic) BOOL IsIrishQuery;
@end
