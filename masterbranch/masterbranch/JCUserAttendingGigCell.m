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
@property (weak, nonatomic) IBOutlet UIButton *buttonTitle;

@end

@implementation JCUserAttendingGigCell

- (void)awakeFromNib {
    self.labelNumberInvited.userInteractionEnabled = YES;
    self.lableNumberGoing.userInteractionEnabled = YES;
    self.lableNumberGotTickets.userInteractionEnabled = YES;
    UITapGestureRecognizer *GotTickets =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userSelectedPeopleAttedningGig)];
    [self.lableNumberGotTickets addGestureRecognizer:GotTickets];
    UITapGestureRecognizer *Going =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userSelectedPeopleAttedningGig)];
    [self.lableNumberGoing addGestureRecognizer:Going];
    UITapGestureRecognizer *Invited =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userSelectedPeopleAttedningGig)];
    [self.labelNumberInvited addGestureRecognizer:Invited];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)formatCell:(NSDictionary*)userattending andMyStatus:(NSString*) myStauts{
    
    NSString *userGoingCount      = [NSString stringWithFormat:@"%d",[[userattending objectForKey:JCUserEventUserGoing]count]];
    NSString *userGotTicketsCount = [NSString stringWithFormat:@"%d",[[userattending objectForKey:JCUserEventUserGotTickets]count]];
    NSString *userInvitedCount    = [NSString stringWithFormat:@"%d",[[userattending objectForKey:JCUserEventUsersInvited]count]];

    self.lableNumberGoing.text      = userGoingCount;
    self.lableNumberGotTickets.text = userGotTicketsCount;
    self.labelNumberInvited.text    = userInvitedCount;
    
            if ([myStauts isEqualToString:JCUserEventUserGoing]) {
                [self.buttonTitle setTitle:@"I'm Going!" forState:UIControlStateNormal];
    
            }else if ([myStauts isEqualToString:JCUserEventUserGotTickets]){
                [self.buttonTitle setTitle:@"I'm Going and I have Tickets!!" forState:UIControlStateNormal];
    
    
            }else if ([myStauts isEqualToString:JCUserEventUserMaybeGoing]){
                [self.buttonTitle setTitle:@"I might attend!" forState:UIControlStateNormal];
    
    
            }else if ([myStauts isEqualToString:JCUserEventUserNotGoing]){
                [self.buttonTitle setTitle:@"I cant make it" forState:UIControlStateNormal];
    
    
            }else if (myStauts == nil){
                [self.buttonTitle setTitle:@"Are you going?" forState:UIControlStateNormal];
            }
    
    
}

-(void)userSelectedPeopleAttedningGig{
[self.JCUserAttendingGigCellDelegate userSelectedPeopleAttedningGig];
}


@end
