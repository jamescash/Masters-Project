//
//  JCTimeDateLocationTableViewCell.m
//  PreAmp
//
//  Created by james cash on 16/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCTimeDateLocationTableViewCell.h"
#import "JCConstants.h"


@interface JCTimeDateLocationTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *timeDate;
@property (weak, nonatomic) IBOutlet UILabel *VenueName;
@property (weak, nonatomic) IBOutlet UIImageView *UIImageViewDateIcon;
@property (weak, nonatomic) IBOutlet UIImageView *UIImageViewLocationIcon;
@property (weak, nonatomic) IBOutlet UIImageView *UIImageViewInvitedYou;
@property (weak, nonatomic) IBOutlet UIButton *UIButtonTitleMyStatus;
@property (weak, nonatomic) IBOutlet UILabel *UILableUserNameInvitedYou;
@property (weak, nonatomic) IBOutlet UIView *UIViewGuesterRecogniserShowMoreInfo;


@end

@implementation JCTimeDateLocationTableViewCell

-(void)formatCellwithParseEventObject:(PFObject*)currentEvent{
    
    self.timeDate.text = [self formatNSdateTostring:[currentEvent objectForKey:JCUserEventUsersTheEventDate]];
    NSString *venueInfo = [NSString stringWithFormat:@"%@ - %@",[currentEvent objectForKey:@"eventVenue"],[currentEvent objectForKey:@"city"]];
    self.VenueName.text = venueInfo;
    
    NSString *informationString;
    
    NSString *eventHostUserName = [currentEvent objectForKey:JCUserEventUsersEventHostNameUserName];
    NSString *eventTitle = [currentEvent objectForKey:JCUserEventUsersEventTitle];
    
    
    
    if ([eventHostUserName isEqualToString:[[PFUser currentUser]username]]) {
        informationString = [NSString stringWithFormat:@"You asked your friends to see %@ with you",eventTitle];
    }else{
        
        NSString *eventHostRealName = [currentEvent objectForKey:JCUserEventUsersEventHostNameRealName];
        
        if (eventHostRealName != nil) {
            informationString = [NSString stringWithFormat:@"%@ asked you to see %@",eventHostRealName,eventTitle];
        }else{
           informationString = [NSString stringWithFormat:@"%@ asked you to see %@",eventHostUserName,eventTitle];
        }
      }
    
    
    self.UILableUserNameInvitedYou.text = informationString;
}


-(void)formatCellwithParseEventObjectForSingleEvent:(PFObject*)currentEvent{
    
    self.timeDate.text = [self formatNSdateTostring:[currentEvent objectForKey:JCUserEventUsersTheEventDate]];
    NSString *venueInfo = [NSString stringWithFormat:@"%@ - %@",[currentEvent objectForKey:@"eventVenue"],[currentEvent objectForKey:@"city"]];
    self.VenueName.text = venueInfo;
    NSString *eventTitle = [currentEvent objectForKey:JCUserEventUsersEventTitle];

    self.UILableUserNameInvitedYou.text = [NSString stringWithFormat:@"Looks like your going to see %@ by yourself, ask some frineds to join you",eventTitle];
}


-(void)formatAreYouGoingButtonTitleWithMyStatus:(NSString *)myStatus{
    if ([myStatus isEqualToString:JCUserEventUserGoing]) {
        //[self.UIButtonTitleMyStatus setTitle:@"I'm Going!" forState:UIControlStateNormal];
        [self.UIButtonTitleMyStatus setBackgroundImage:[UIImage imageNamed:@"buttonImGoing"] forState:UIControlStateNormal];
        
    }else if ([myStatus isEqualToString:JCUserEventUserGotTickets]){
        //[self.UIButtonTitleMyStatus setTitle:@"I'm Going and I have Tickets!!" forState:UIControlStateNormal];
        [self.UIButtonTitleMyStatus setBackgroundImage:[UIImage imageNamed:@"buttonGotTickets"] forState:UIControlStateNormal];

        
    }else if ([myStatus isEqualToString:JCUserEventUserMaybeGoing]){
        //[self.UIButtonTitleMyStatus setTitle:@"I might attend!" forState:UIControlStateNormal];
        [self.UIButtonTitleMyStatus setBackgroundImage:[UIImage imageNamed:@"buttonMaybe"] forState:UIControlStateNormal];

        
    }else if ([myStatus isEqualToString:JCUserEventUserNotGoing]){
        //[self.UIButtonTitleMyStatus setTitle:@"I cant make it" forState:UIControlStateNormal];
        [self.UIButtonTitleMyStatus setBackgroundImage:[UIImage imageNamed:@"buttonCantMakeIt"] forState:UIControlStateNormal];

        
    }else if (myStatus == nil){
        //[self.UIButtonTitleMyStatus setTitle:@"Are you going?" forState:UIControlStateNormal];
        [self.UIButtonTitleMyStatus setBackgroundImage:[UIImage imageNamed:@"buttonAreYouGoing"] forState:UIControlStateNormal];

    }
}

-(void)formatCell:(eventObject *)currentEvent{
    self.timeDate.text = [self formatDateString:currentEvent.eventDate];
    NSString *venueInfo = [NSString stringWithFormat:@"%@ - %@",currentEvent.venueName,currentEvent.county];
    self.VenueName.text = venueInfo;
}

- (void)awakeFromNib {
  
    self.UIImageViewDateIcon.image = [UIImage imageNamed:@"iconDate"];
    self.UIImageViewDateIcon.contentMode = UIViewContentModeScaleAspectFill;
    self.UIImageViewLocationIcon.image = [UIImage imageNamed:@"iconLocation"];
    self.UIImageViewLocationIcon.contentMode = UIViewContentModeScaleAspectFill;
    self.UIImageViewInvitedYou.image = [UIImage imageNamed:@"iconFriendsInvite"];
    self.UIImageViewLocationIcon.contentMode = UIViewContentModeScaleAspectFill;
    
    UITapGestureRecognizer *showMoreInfo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapShowGigMoreInfo)];
    [self.UIViewGuesterRecogniserShowMoreInfo addGestureRecognizer:showMoreInfo];
    
}

-(void)didTapShowGigMoreInfo{
    if (self.JCTimeDateLocationTableViewCellDelagate && [self.JCTimeDateLocationTableViewCellDelagate respondsToSelector:@selector(didTapShowGigMoreInfo)]) {
    
        [self.JCTimeDateLocationTableViewCellDelagate didTapShowGigMoreInfo];
    
    
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(NSString*)formatNSdateTostring: (NSDate*)date{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //[dateFormat setDateFormat:@"yyy-MM-dd'T'HH:mm:ss"];
    // NSDate *eventDateTime = [dateFormat dateFromString:date];
    
    dateFormat.dateStyle = NSDateFormatterMediumStyle;
    
    NSString *dayMonthString = [dateFormat stringFromDate:date];
    [dateFormat setDateFormat:@"' at 'HH:mm"];
    NSString *timeString = [dateFormat stringFromDate:date];
    
    return [NSString stringWithFormat:@"%@%@",dayMonthString,timeString];
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

@end
