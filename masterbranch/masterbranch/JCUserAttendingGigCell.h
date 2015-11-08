//
//  JCUserAttendingGigCell.h
//  PreAmp
//
//  Created by james cash on 26/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol JCUserAttendingGigCellDelegate;
@interface JCUserAttendingGigCell : UITableViewCell
-(void)formatCell:(NSDictionary*)userattending andMyStatus:(NSString*) myStauts;
@property (strong,nonatomic) id <JCUserAttendingGigCellDelegate>JCUserAttendingGigCellDelegate;
@end

@protocol JCUserAttendingGigCellDelegate <NSObject>
-(void)userSelectedPeopleAttedningGig;
@end