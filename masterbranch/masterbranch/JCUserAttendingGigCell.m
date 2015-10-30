//
//  JCUserAttendingGigCell.m
//  PreAmp
//
//  Created by james cash on 26/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCUserAttendingGigCell.h"
#import "JCConstants.h"


@interface JCUserAttendingGigCell ()
@property (weak, nonatomic) IBOutlet UILabel *labelNumberInvited;
@property (weak, nonatomic) IBOutlet UILabel *lableNumberGotTickets;
@property (weak, nonatomic) IBOutlet UILabel *lableNumberGoing;

@end

@implementation JCUserAttendingGigCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
 
    // Configure the view for the selected state
}

-(void)formatCell:(NSDictionary*)userattending andMyStatus:(NSString*) myStauts{
    
    NSString *userGoingCount      = [NSString stringWithFormat:@"%d",[[userattending objectForKey:JCUserEventUserGoing]count]];
    NSString *userGotTicketsCount = [NSString stringWithFormat:@"%d",[[userattending objectForKey:JCUserEventUserGotTickets]count]];
    NSString *userInvitedCount    = [NSString stringWithFormat:@"%d",[[userattending objectForKey:JCUserEventUsersInvited]count]];

    self.lableNumberGoing.text      = userGoingCount;
    self.lableNumberGotTickets.text = userGotTicketsCount;
    self.labelNumberInvited.text    = userInvitedCount;
    
}


@end
