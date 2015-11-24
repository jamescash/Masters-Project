//
//  JCUserAttendingGigCell.m
//  PreAmp
//
//  Created by james cash on 26/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCUserAttendingGigCell.h"
#import "JCConstants.h"
#import <Parse/Parse.h>
#import "JCParseQuerys.h"


@interface JCUserAttendingGigCell ()
@property (weak, nonatomic) IBOutlet UILabel *labelNumberInvited;
@property (weak, nonatomic) IBOutlet UILabel *lableNumberGotTickets;
@property (weak, nonatomic) IBOutlet UILabel *lableNumberGoing;
@property (nonatomic,strong) JCParseQuerys *JCParseQuerys;
@property (weak, nonatomic) IBOutlet UIView *UIViewHitTargetUserSelecdPeopleAttendingGIg;

@end

@implementation JCUserAttendingGigCell

- (void)awakeFromNib {
      UITapGestureRecognizer *userSelectedusersAttendingGig =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userSelectedPeopleAttedningGig)];
    [self.UIViewHitTargetUserSelecdPeopleAttendingGIg addGestureRecognizer:userSelectedusersAttendingGig];
}

-(void)formatUserGoingImage:(PFObject *)userEvent{
    
      //TODO finish adding in pictures of people attending event.
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)formatCell:(NSDictionary*)userattending andMyStatus:(NSString*) myStauts{
    
    NSString *userGoingCount      = [NSString stringWithFormat:@"%u",[[userattending objectForKey:JCUserEventUserGoing]count]];
    NSString *userGotTicketsCount = [NSString stringWithFormat:@"%u",[[userattending objectForKey:JCUserEventUserGotTickets]count]];
    NSString *userInvitedCount    = [NSString stringWithFormat:@"%u",[[userattending objectForKey:JCUserEventUsersInvited]count]];

    self.lableNumberGoing.text      = userGoingCount;
    self.lableNumberGotTickets.text = userGotTicketsCount;
    self.labelNumberInvited.text    = userInvitedCount;
}

-(void)userSelectedPeopleAttedningGig{
[self.JCUserAttendingGigCellDelegate userSelectedPeopleAttedningGig];
}


@end
