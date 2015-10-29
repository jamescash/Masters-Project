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


@end

@implementation JCTimeDateLocationTableViewCell

-(void)formatCellwithParseEventObject:(PFObject*)currentEvent{
    self.timeDate.text = [self formatNSdateTostring:[currentEvent objectForKey:JCUserEventUsersTheEventDate]];
    NSString *venueInfo = [NSString stringWithFormat:@"%@ - %@",[currentEvent objectForKey:@"eventVenue"],[currentEvent objectForKey:@"city"]];
    self.VenueName.text = venueInfo;
}


-(void)formatCell:(eventObject *)currentEvent{
    
    self.timeDate.text = [self formatDateString:currentEvent.eventDate];
    NSString *venueInfo = [NSString stringWithFormat:@"%@ - %@",currentEvent.venueName,currentEvent.county];
    self.VenueName.text = venueInfo;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(NSString*)formatNSdateTostring: (NSDate*)date{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //[dateFormat setDateFormat:@"yyy-MM-dd'T'HH:mm:ss"];
    // NSDate *eventDateTime = [dateFormat dateFromString:date];
    
    dateFormat.dateStyle = NSDateFormatterFullStyle;
    
    NSString *dayMonthString = [dateFormat stringFromDate:date];
    [dateFormat setDateFormat:@"' at 'HH:mm"];
    NSString *timeString = [dateFormat stringFromDate:date];
    
    return [NSString stringWithFormat:@"%@%@",dayMonthString,timeString];
}

-(NSString*)formatDateString: (NSString*)date{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyy-MM-dd'T'HH:mm:ss"];
    NSDate *eventDateTime = [dateFormat dateFromString:date];

    dateFormat.dateStyle = NSDateFormatterFullStyle;

    NSString *dayMonthString = [dateFormat stringFromDate:eventDateTime];
    [dateFormat setDateFormat:@"' at 'HH:mm"];
    NSString *timeString = [dateFormat stringFromDate:eventDateTime];

    return [NSString stringWithFormat:@"%@%@",dayMonthString,timeString];
}

@end
