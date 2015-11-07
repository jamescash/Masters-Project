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
    
            if ([myStauts isEqualToString:JCUserEventUserGoing]) {
                NSLog(@"user going");
                [self.buttonTitle setTitle:@"I'm Going!" forState:UIControlStateNormal];
    
            }else if ([myStauts isEqualToString:JCUserEventUserGotTickets]){
                NSLog(@"user got tickets");
                [self.buttonTitle setTitle:@"I'm Going and I have Tickets!!" forState:UIControlStateNormal];
    
    
            }else if ([myStauts isEqualToString:JCUserEventUserMaybeGoing]){
                NSLog(@"user maybe going");
                [self.buttonTitle setTitle:@"I might attend!" forState:UIControlStateNormal];
    
    
            }else if ([myStauts isEqualToString:JCUserEventUserNotGoing]){
                NSLog(@"user not going");
                [self.buttonTitle setTitle:@"I cant make it" forState:UIControlStateNormal];
    
    
            }else if (myStauts == nil){
                NSLog(@"user didnt set status yet ");
                [self.buttonTitle setTitle:@"Are you going?" forState:UIControlStateNormal];
    
    
            }
    
    
}


@end
