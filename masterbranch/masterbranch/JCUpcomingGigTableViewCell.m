//
//  JCUpcomingGigTableViewCell.m
//  PreAmp
//
//  Created by james cash on 16/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCUpcomingGigTableViewCell.h"

@interface JCUpcomingGigTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *dataTime;
@property (weak, nonatomic) IBOutlet UILabel *venueAdress;
@property (weak, nonatomic) IBOutlet UILabel *venueName;


@end


@implementation JCUpcomingGigTableViewCell


-(void)formatCell:(eventObject *)currentEvent{
   
    self.venueName.text = currentEvent.venueName;
    self.dataTime.text = currentEvent.formattedDateTime;
//    self.dataTime.layer.borderColor = [[UIColor colorWithRed:234.0f/255.0f green:65.0f/255.0f blue:150.0f/255.0f alpha:1.0f]CGColor] ;
//    self.dataTime.layer.borderWidth = 1.0;
    self.dataTime.textColor = [UIColor colorWithRed:234.0f/255.0f green:65.0f/255.0f blue:150.0f/255.0f alpha:.6f];
    self.venueAdress.text = currentEvent.county;

    
}
-(void)formatCellwith:(PFObject*)upcomingGig{
    self.venueName.text = [upcomingGig objectForKey:@"venueName"];
    self.dataTime.text = [upcomingGig objectForKey:@"formatted_datetime"];
    self.dataTime.textColor = [UIColor colorWithRed:234.0f/255.0f green:65.0f/255.0f blue:150.0f/255.0f alpha:.6f];
    self.venueAdress.text = [upcomingGig objectForKey:@"city"];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
