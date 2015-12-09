//
//  JCUpcomingGigTableViewCell.m
//  PreAmp
//
//  Created by james cash on 16/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCUpcomingGigTableViewCell.h"
#import "JCConstants.h"

@interface JCUpcomingGigTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *dataTime;
@property (weak, nonatomic) IBOutlet UILabel *venueAdress;
@property (weak, nonatomic) IBOutlet UILabel *venueName;
@property (weak, nonatomic) IBOutlet UIButton *UIButtonIntiveFriends;
@property (weak, nonatomic) IBOutlet UIImageView *UIImageViewImGoingIcon;
@property (weak, nonatomic) IBOutlet UILabel *UILableUserInterested;
@property (weak, nonatomic) IBOutlet UIView *UIViewhitTargetMoreInfo;


@end


@implementation JCUpcomingGigTableViewCell


-(void)formatCell:(eventObject *)currentEvent userIsInterested:(BOOL)userIsInterested {
   
    
    if (userIsInterested) {
        self.UILableUserInterested.text = @"You're going!";
        self.UIImageViewImGoingIcon.image = [UIImage imageNamed:@"iconJustMeGoing"];
        
    }else{
        self.UILableUserInterested.text = nil;
        self.UIImageViewImGoingIcon.image = nil;
    }
    
    
    self.venueName.text = currentEvent.venueName;
    self.dataTime.text = [self formatDateString:currentEvent.eventDate];
    self.dataTime.textColor = [UIColor colorWithRed:234.0f/255.0f green:65.0f/255.0f blue:150.0f/255.0f alpha:.6f];
    self.venueAdress.text = currentEvent.county;

}

-(void)formatCellwith:(PFObject*)upcomingGig userIsInterested:(BOOL)userIsInterested {
    
    if (userIsInterested) {
        self.UILableUserInterested.text = @"You're going!";
        self.UIImageViewImGoingIcon.image = [UIImage imageNamed:@"iconJustMeGoing"];

    }else{
        self.UILableUserInterested.text = nil;
        self.UIImageViewImGoingIcon.image = nil;
    }
    
    //self.UIImageViewImGoingIcon.contentMode = UIViewContentModeScaleAspectFill;
    self.venueName.text = [upcomingGig objectForKey:@"venueName"];
    NSString *dateTime = [upcomingGig objectForKey:JCUpcomingEventDateTimeString];
    self.dataTime.text = [self formatDateString:dateTime];
    self.dataTime.textColor = [UIColor colorWithRed:234.0f/255.0f green:65.0f/255.0f blue:150.0f/255.0f alpha:.6f];
    self.venueAdress.text = [upcomingGig objectForKey:@"city"];
    
}



- (void)awakeFromNib {
    

    UITapGestureRecognizer *moreInFoButtonHit = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moreInfoButtonHit)];
    
    [self.UIViewhitTargetMoreInfo addGestureRecognizer:moreInFoButtonHit];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(NSString*)formatDateString: (NSString*)date{
    
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyy-MM-dd'T'HH:mm:ss"];
    NSDate *eventDateTime = [dateFormat dateFromString:date];
    
    
    dateFormat.dateStyle = NSDateFormatterMediumStyle;
    NSString *dayMonthString = [dateFormat stringFromDate:eventDateTime];
    [dateFormat setDateFormat:@"' at 'HH:mm"];
    NSString *timeString = [dateFormat stringFromDate:eventDateTime];
    
    
    [dateFormat setDateFormat:@"EEE"];
    NSString *dayString = [dateFormat stringFromDate:eventDateTime];
    
    [dateFormat setDateFormat:@"MM-dd"];
    
    
    return [NSString stringWithFormat:@"%@ %@%@",dayString,dayMonthString,timeString];
}

- (IBAction)UIbuttonIntiveFriendsToUpcomingGig:(id)sender {
    
    
    [self moreInfoButtonHit];
    
}


-(void)moreInfoButtonHit{
    
    if (self.JCUpcomingGigTableViewCellDelegate && [self.JCUpcomingGigTableViewCellDelegate respondsToSelector:@selector(didClickInviteFriendsOnUpcomingGigAt:)])
    {
    [self.JCUpcomingGigTableViewCellDelegate didClickInviteFriendsOnUpcomingGigAt:self.cellIndex];
        
    }
    
    
    if (self.JCUpcomingGigTableViewCellDelegate && [self.JCUpcomingGigTableViewCellDelegate respondsToSelector:@selector(didClickInviteFriendsOnUpcomingGigAtNSIndexPath:)])
    {
        
    [self.JCUpcomingGigTableViewCellDelegate didClickInviteFriendsOnUpcomingGigAtNSIndexPath:self.cellIndexNSIndexPath];
        
    }
}

@end
