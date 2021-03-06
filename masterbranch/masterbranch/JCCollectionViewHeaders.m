//
//  JCCollectionViewHeaders.m
//  masterbranch
//
//  Created by james cash on 22/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "JCCollectionViewHeaders.h"
#import "UIColor+JCColor.h"

@interface JCCollectionViewHeaders ()
@property(weak) IBOutlet UILabel *searchLabel;
@end

@implementation JCCollectionViewHeaders

-(void)formateHeaderwithString:(NSString*)headerTitle{
    
    self.searchLabel.text = headerTitle;
    self.searchLabel.textColor = [UIColor JCPink];
}

-(void)formateHeaderwithEventObject:(eventObject *)eventObject{
    
    self.searchLabel.text = [self formatDateString:eventObject.eventDate];
    self.searchLabel.textColor = [UIColor JCPink];

    
}

-(NSString*)formatDateString: (NSString*)date{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyy-MM-dd'T'HH:mm:ss"];
    NSDate *eventDateTime = [dateFormat dateFromString:date];
    
    [dateFormat setDateFormat:@"EEEE"];
    NSString *dayString = [dateFormat stringFromDate:eventDateTime];
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:eventDateTime];
    int day = [components day];
     NSString *dayNumberWithSuffix = [self addSuffixToNumber:day];
    //dateFormat.dateStyle = NSDateFormatterFullStyle ;
    
    //NSString *dayMonthString = [dateFormat stringFromDate:eventDateTime];
    //[dateFormat setDateFormat:@"' at 'HH:mm"];
    //NSString *timeString = [dateFormat stringFromDate:eventDateTime];
    
    return [NSString stringWithFormat:@"%@ - %@ ",dayString,dayNumberWithSuffix];
}

-(NSString *) addSuffixToNumber:(int) number
{
    NSString *suffix;
    int ones = number % 10;
    int tens = (number/10) % 10;
    
    if (tens ==1) {
        suffix = @"th";
    } else if (ones ==1){
        suffix = @"st";
    } else if (ones ==2){
        suffix = @"nd";
    } else if (ones ==3){
        suffix = @"rd";
    } else {
        suffix = @"th";
    }
    
    NSString *completeAsString = [NSString stringWithFormat:@"%d%@",number,suffix];
    return completeAsString;
    
}

@end
