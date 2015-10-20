//
//  JCEventInviteCell.m
//  PreAmp
//
//  Created by james cash on 10/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCEventInviteCell.h"

@interface JCEventInviteCell()
@property (weak, nonatomic) IBOutlet UILabel *hostedBy;
@property (weak, nonatomic) IBOutlet UILabel *eventTitle;
@property (weak, nonatomic) IBOutlet UILabel *dateTime;


@end

@implementation JCEventInviteCell


-(void)formatCell:(PFObject *)currentEvent{
    
    NSString *hostedbyFormatted = [NSString stringWithFormat:@"Invited by %@",[currentEvent objectForKey:@"eventHostName"]];
    self.hostedBy.text = hostedbyFormatted;

    self.eventTitle.text = [currentEvent objectForKey:@"eventTitle"];
    
    NSString *formattedDataTime = [self formatDate:[currentEvent objectForKey:@"eventDate"]];
    
    self.dateTime.text = formattedDataTime;
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(NSString*)formatDate: (NSString*)date{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyy-MM-dd'T'HH:mm:ss"];
    //NSString *dateformatted = [date stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    NSDate *eventDateTime = [dateFormat dateFromString:date];
    
    //dateFormat.dateStyle = NSDateFormatterFullStyle;
    dateFormat.dateStyle = NSDateFormatterMediumStyle;

    
    NSString *dayMonthString = [dateFormat stringFromDate:eventDateTime];
    //[dateFormat setDateFormat:@"' at 'HH:mm"];
    //NSString *timeString = [dateFormat stringFromDate:eventDateTime];
    
    return [NSString stringWithFormat:@"%@",dayMonthString];
}
@end
