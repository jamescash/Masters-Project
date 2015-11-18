//
//  JCInvteFollowHeaderVC.m
//  PreAmp
//
//  Created by james cash on 16/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCInvteFollowHeaderVC.h"

@interface JCInvteFollowHeaderVC ()
@property (weak, nonatomic) IBOutlet UIButton *followartist;

@end

@implementation JCInvteFollowHeaderVC

- (void)awakeFromNib {
}

-(void)formatCellButtons:(BOOL)userIsFollowingArtist{
    self.userIsFollowingArtist = userIsFollowingArtist;
    if (userIsFollowingArtist) {
        [self.followartist setTitle:@"Following" forState:UIControlStateNormal];
        
    }else{
        [self.followartist setTitle:@"Follow" forState:UIControlStateNormal];
    }
    
}

- (IBAction)buttonFollowArtist:(id)sender {
    if (self.JCInvteFollowHeaderDelegate && [self.JCInvteFollowHeaderDelegate respondsToSelector:@selector(didClickFollowArtistButton:)]) {
        
        if (self.userIsFollowingArtist) {
            
            self.userIsFollowingArtist = NO;
            [self.JCInvteFollowHeaderDelegate didClickFollowArtistButton:self.userIsFollowingArtist];
            [self.followartist setTitle:@"Follow" forState:UIControlStateNormal];
            
        }else{
            self.userIsFollowingArtist = YES;
            [self.JCInvteFollowHeaderDelegate didClickFollowArtistButton:self.userIsFollowingArtist];
            [self.followartist setTitle:@"Following" forState:UIControlStateNormal];
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
