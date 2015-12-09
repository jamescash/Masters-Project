//
//  JCMusicDiaryVC.h
//  PreAmp
//
//  Created by james cash on 11/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+EmptyDataSet.h"
#import "GAITrackedViewController.h"
/////////Class summery
/**
 1. This class is the ViewController is built to deal disply the user there discovery screen
 2. It hits the our backend to get the users artist upcoming gigs that are in Ireland/Uk
 3. then sorts them into an upcoming events calender 
 */
@interface JCMusicDiaryVC : GAITrackedViewController <DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>

@end
