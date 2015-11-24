//
//  JCUserAttendingGigCell.h
//  PreAmp
//
//  Created by james cash on 26/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>


@protocol JCUserAttendingGigCellDelegate;
@interface JCUserAttendingGigCell : UITableViewCell
-(void)formatCell:(NSDictionary*)userattending andMyStatus:(NSString*) myStauts;
-(void)formatUserGoingImage:(PFObject*)userEvent;


@property (strong,nonatomic) id <JCUserAttendingGigCellDelegate>JCUserAttendingGigCellDelegate;
@property (weak, nonatomic) IBOutlet PFImageView *UIImageUser1;
@property (weak, nonatomic) IBOutlet PFImageView *UIImageUser2;
@property (weak, nonatomic) IBOutlet PFImageView *UIImageUser3;
@property (weak, nonatomic) IBOutlet PFImageView *UIImageUser4;
@property (weak, nonatomic) IBOutlet PFImageView *UIImageUser5;




@end

@protocol JCUserAttendingGigCellDelegate <NSObject>
-(void)userSelectedPeopleAttedningGig;
@end