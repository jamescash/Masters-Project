//
//  JCInvteFollowHeaderVC.m
//  PreAmp
//
//  Created by james cash on 16/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCInvteFollowHeaderVC.h"

#import "JCParseQuerys.h"


@interface JCInvteFollowHeaderVC ()
@property (weak, nonatomic) IBOutlet UIButton *followartist;
@property (weak, nonatomic) IBOutlet UIButton *UIButtonImIntrested;
@property (nonatomic,strong) JCParseQuerys *JCParseQuerys;
@property (weak, nonatomic) IBOutlet UILabel *UILableFollowArtist;
@property (weak, nonatomic) IBOutlet UILabel *UILableJustMe;

@property (weak, nonatomic) IBOutlet UILabel *UILableInviteFriends;

@property (weak, nonatomic) IBOutlet UIButton *UIButtonIntiveFriends;

@end

@implementation JCInvteFollowHeaderVC



- (void)awakeFromNib {
    
   
}

-(void)formatCellButtons:(BOOL)userIsFollowingArtist and: (BOOL)userIsInterested{
    
    self.userIsFollowingArtist = userIsFollowingArtist;
    self.userIsInTerestedInGoing = userIsInterested;
    
    
    if (userIsFollowingArtist) {
        [self.followartist setBackgroundImage:[UIImage imageNamed:@"iconUnfollowArtist"] forState:UIControlStateNormal];
        self.UILableFollowArtist.text = @"Unfollow";
    }else{
        [self.followartist setBackgroundImage:[UIImage imageNamed:@"iconFollowArtist"] forState:UIControlStateNormal];
        self.UILableFollowArtist.text = @"follow artist";
        
    }
    
    
    if (userIsInterested) {
        [self.UIButtonImIntrested setBackgroundImage:[UIImage imageNamed:@"iconJustMeGoing"] forState:UIControlStateNormal];
        self.UILableJustMe.text = @"Your Going!";
        
        [self.UIButtonIntiveFriends setBackgroundImage:[UIImage imageNamed:@"iconIntiveFriends"] forState:UIControlStateNormal];
        self.UILableInviteFriends.text = @"Add Friends";
        
   }else{
       [self.UIButtonIntiveFriends setBackgroundImage:[UIImage imageNamed:@"iconCreateEvent"] forState:UIControlStateNormal];
       self.UILableInviteFriends.text = @"Me and Friends";
       
        [self.UIButtonImIntrested setBackgroundImage:[UIImage imageNamed:@"iconJustMe"] forState:UIControlStateNormal];
        self.UILableJustMe.text = @"Just me";
    }
    
}



- (IBAction)UIButtonImIntrested:(id)sender {
    
    if (self.JCInvteFollowHeaderDelegate && [self.JCInvteFollowHeaderDelegate respondsToSelector:@selector(didClickImIntrested:)]) {
        
        
        if (self.userIsInTerestedInGoing) {
            
            self.userIsInTerestedInGoing = NO;
            [self.JCInvteFollowHeaderDelegate didClickImIntrested:self.userIsInTerestedInGoing];
            
            [self.UIButtonImIntrested setBackgroundImage:[UIImage imageNamed:@"iconJustMe"] forState:UIControlStateNormal];
            self.UILableJustMe.text = @"Just me";
            [self.UIButtonIntiveFriends setBackgroundImage:[UIImage imageNamed:@"iconCreateEvent"] forState:UIControlStateNormal];
            self.UILableInviteFriends.text = @"Me and Friends";
            
            
        }else{
            self.userIsInTerestedInGoing = YES;
            [self.JCInvteFollowHeaderDelegate didClickImIntrested:self.userIsInTerestedInGoing];
            [self.UIButtonImIntrested setBackgroundImage:[UIImage imageNamed:@"iconJustMeGoing"] forState:UIControlStateNormal];
            self.UILableJustMe.text = @"Your Going!";
            [self.UIButtonIntiveFriends setBackgroundImage:[UIImage imageNamed:@"iconIntiveFriends"] forState:UIControlStateNormal];
            self.UILableInviteFriends.text = @"Add Friends";
        
        }
    }
}

    
- (IBAction)buttonFollowArtist:(id)sender {
    
    
    if (self.JCInvteFollowHeaderDelegate && [self.JCInvteFollowHeaderDelegate respondsToSelector:@selector(didClickFollowArtistButton:)]) {
        
        if (self.userIsFollowingArtist) {
            
            self.userIsFollowingArtist = NO;
            [self.JCInvteFollowHeaderDelegate didClickFollowArtistButton:self.userIsFollowingArtist];
            [self.followartist setBackgroundImage:[UIImage imageNamed:@"iconFollowArtist"] forState:UIControlStateNormal];
            self.UILableFollowArtist.text = @"follow";
        }else{
            self.userIsFollowingArtist = YES;
            [self.JCInvteFollowHeaderDelegate didClickFollowArtistButton:self.userIsFollowingArtist];
            [self.followartist setBackgroundImage:[UIImage imageNamed:@"iconUnfollowArtist"] forState:UIControlStateNormal];
            self.UILableFollowArtist.text = @"Unfollow";
        }
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
