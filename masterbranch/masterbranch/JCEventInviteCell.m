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
@property (strong,nonatomic ) CAGradientLayer *vignetteLayer;


@end

@implementation JCEventInviteCell


-(void)formatCell:(PFObject *)currentEvent{
    
    NSString *hostedbyFormatted = [NSString stringWithFormat:@"Created by %@",[currentEvent objectForKey:@"eventHostName"]];
    self.hostedBy.text = hostedbyFormatted;

    self.eventTitle.text = [currentEvent objectForKey:@"eventTitle"];
    
    NSString *formattedDataTime = [self formatDate:[currentEvent objectForKey:@"eventDate"]];
    
    self.dateTime.text = formattedDataTime;
    ///self.dateTime.textColor = [UIColor colorWithRed:234.0f/255.0f green:65.0f/255.0f blue:150.0f/255.0f alpha:1.0f];

    
    [self addVinettLayer];
    

}

-(void)addVinettLayer{
    if (!self.vignetteLayer) {
        self.vignetteLayer = [CAGradientLayer layer];
        [self.vignetteLayer setBounds:[self.BackRoundImage bounds]];
        [self.vignetteLayer setPosition:CGPointMake([self.BackRoundImage bounds].size.width/2.0f, [self.BackRoundImage bounds].size.height/2.0f)];
        UIColor *lighterBlack = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.85];
        [self.vignetteLayer setColors:@[(id)[[UIColor clearColor] CGColor], (id)[lighterBlack CGColor]]];
        [self.vignetteLayer setLocations:@[@(.30), @(1.0)]];
        [[self.BackRoundImage layer] addSublayer:self.vignetteLayer];
    }
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(NSString*)formatDate: (NSDate*)date{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.dateStyle = NSDateFormatterMediumStyle;
    NSString *dayMonthString = [dateFormat stringFromDate:date];
    return [NSString stringWithFormat:@"%@",dayMonthString];
}
@end
