//
//  JCMyFiriendsMyArtistVC.h
//  PreAmp
//
//  Created by james cash on 20/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "JCMyArtistCell.h"
#import "UIScrollView+EmptyDataSet.h"


@interface JCMyFiriendsMyArtistVC : UIViewController <JCMyArtistCellDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (nonatomic,strong) NSString *tableViewType;
@property (nonatomic,strong) PFObject *currentUserEvent;
@property (nonatomic,strong) NSMutableArray *myFriends;
@end
