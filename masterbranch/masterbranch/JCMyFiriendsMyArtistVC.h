//
//  JCMyFiriendsMyArtistVC.h
//  PreAmp
//
//  Created by james cash on 20/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "JCMyArtistCell.h" //cell for displying artist 
#import "UIScrollView+EmptyDataSet.h" //https://github.com/dzenbot/DZNEmptyDataSet -- empty data set
#import "GAITrackedViewController.h"

/////////Class summery
/**
 1. This class is a ViewController Used to disply mulitpe diffrent screens, generaly if theres a list view contaning users or artist it uses this view controller to disply itself. 
 
 Screens that are diplyed from this view controller are - MyArtist,MyFirend///User - Intived,going,maybe,gottickets,notgoing,//MyFriends on Facebook/preamp/Recently added me.  
 
 */

@interface JCMyFiriendsMyArtistVC : GAITrackedViewController <JCMyArtistCellDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>
@property (nonatomic,strong) NSString *tableViewType;
@property (nonatomic,strong) PFObject *currentUserEvent;
@property (nonatomic,strong) NSMutableArray *myFriends;
@end
