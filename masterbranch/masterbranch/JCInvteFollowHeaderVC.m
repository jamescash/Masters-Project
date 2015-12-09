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
@property (nonatomic,strong) JCParseQuerys    *JCParseQuerys;
@property (weak, nonatomic) IBOutlet UILabel  *UILableFollowArtist;
@property (weak, nonatomic) IBOutlet UILabel  *UILableJustMe;
@property (weak, nonatomic) IBOutlet UILabel  *UILableInviteFriends;

@property (weak, nonatomic) IBOutlet UIButton *UIButtonImIntrested;



@property (weak, nonatomic) IBOutlet UIButton *UIButtonIntiveFriends;

@property (weak, nonatomic) IBOutlet UIView *UIViewHitTargetJustMe;
@property (weak, nonatomic) IBOutlet UIView *UIViewHitTargetFollowArtist;
@property (weak, nonatomic) IBOutlet UIView *UIViewHitTargetAddFriends;

@property (nonatomic,strong)UIActivityIndicatorView *justMeSpinner;
@property (nonatomic,strong)UIActivityIndicatorView *addFriendsSppiner;
@property (nonatomic,strong)UIActivityIndicatorView *followArtistSpinner;



@end

@implementation JCInvteFollowHeaderVC



- (void)awakeFromNib {
    
    //Add invisible tap guester reconisers over all the buttons on the cell so the user has a big hit target
    
    UITapGestureRecognizer *UIViewHitTargetFollowArtist =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(UIButtonFollowAristAction)];
    [self.UIViewHitTargetFollowArtist addGestureRecognizer:UIViewHitTargetFollowArtist];
    
    
    
    UITapGestureRecognizer *UIViewHitTargetJustMe =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(UIButtonImIntresedAction)];
    [self.UIViewHitTargetJustMe addGestureRecognizer:UIViewHitTargetJustMe];
    
    
    UITapGestureRecognizer *UIViewHitTargetAddFriends =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(UIButtonAddFriendsAction)];
    [self.UIViewHitTargetAddFriends addGestureRecognizer:UIViewHitTargetAddFriends];
   
}

-(void)formatCellButtons:(BOOL)userIsFollowingArtist and:(BOOL)userIsInterested isLoading:(BOOL)isLoading{
    
    self.userIsFollowingArtist = userIsFollowingArtist;
    self.userIsInTerestedInGoing = userIsInterested;
    
    if (isLoading) {
        [self setLoadingStateFor:self.followartist andLable:self.UILableFollowArtist andUIView:self.UIViewHitTargetFollowArtist];
        [self setLoadingStateFor:self.UIButtonImIntrested andLable:self.UILableJustMe andUIView:self.UIViewHitTargetJustMe];
        [self setLoadingStateFor:self.UIButtonIntiveFriends andLable:self.UILableInviteFriends andUIView:self.UIViewHitTargetAddFriends];
        
        [self initSppiner:self.justMeSpinner andAddToView:self.UIViewHitTargetJustMe];
        [self initSppiner:self.followArtistSpinner andAddToView:self.UIViewHitTargetFollowArtist];
        [self initSppiner:self.addFriendsSppiner andAddToView:self.UIViewHitTargetAddFriends];

        
    }else{
    
        self.UIViewHitTargetAddFriends.userInteractionEnabled = YES;
        self.UIViewHitTargetFollowArtist.userInteractionEnabled = YES;
        self.UIViewHitTargetJustMe.userInteractionEnabled = YES;
        self.UIButtonImIntrested.userInteractionEnabled = YES;
        self.UIButtonIntiveFriends.userInteractionEnabled = YES;
        self.followartist.userInteractionEnabled = YES;
    if (userIsFollowingArtist) {
        [self.followartist setBackgroundImage:[UIImage imageNamed:@"iconUnfollowArtist"] forState:UIControlStateNormal];
        self.UILableFollowArtist.text = @"Unfollow";
    }else{
        [self.followartist setBackgroundImage:[UIImage imageNamed:@"iconFollowArtist"] forState:UIControlStateNormal];
        self.UILableFollowArtist.text = @"follow artist";
        
    }
    
    
    if (userIsInterested) {
        [self.UIButtonImIntrested setBackgroundImage:[UIImage imageNamed:@"iconJustMeGoing"] forState:UIControlStateNormal];
        self.UILableJustMe.text = @"You're Going!";
        
        [self.UIButtonIntiveFriends setBackgroundImage:[UIImage imageNamed:@"iconIntiveFriends"] forState:UIControlStateNormal];
        self.UILableInviteFriends.text = @"Add Friends";
        
    }else{
        
        [self setImageForButton:self.UIButtonIntiveFriends imageName:@"iconCreateEvent" andUpdateButtonLable:self.UILableInviteFriends lableText:@"Me and Friends"];
    
       
        [self.UIButtonImIntrested setBackgroundImage:[UIImage imageNamed:@"iconJustMe"] forState:UIControlStateNormal];
        self.UILableJustMe.text = @"Just me";
    }
        
    }
    
}



- (IBAction)UIButtonImIntrested:(id)sender {
    [self UIButtonImIntresedAction];
    
}
- (IBAction)buttonFollowArtist:(id)sender {
    [self UIButtonFollowAristAction];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


-(void)UIButtonImIntresedAction{
    NSLog(@"UIButtonImIntresedAction");
    if (self.JCInvteFollowHeaderDelegate && [self.JCInvteFollowHeaderDelegate respondsToSelector:@selector(didClickImIntrested:)]) {
        
        
        if (self.userIsInTerestedInGoing) {
             self.userIsInTerestedInGoing = NO;
            [self.JCInvteFollowHeaderDelegate didClickImIntrested:self.userIsInTerestedInGoing];
            [self setLoadingStateFor:self.UIButtonImIntrested andLable:self.UILableJustMe andUIView:self.UIViewHitTargetJustMe];
            [self initSppiner:self.justMeSpinner andAddToView:self.UIViewHitTargetJustMe];
        }else{
            self.userIsInTerestedInGoing = YES;
            [self.JCInvteFollowHeaderDelegate didClickImIntrested:self.userIsInTerestedInGoing];
            [self setLoadingStateFor:self.UIButtonImIntrested andLable:self.UILableJustMe andUIView:self.UIViewHitTargetJustMe];
            [self initSppiner:self.justMeSpinner andAddToView:self.UIViewHitTargetJustMe];
           }
       }
}

-(void)UIButtonFollowAristAction{
    NSLog(@"UIButtonFollowAristAction");

    if (self.JCInvteFollowHeaderDelegate && [self.JCInvteFollowHeaderDelegate respondsToSelector:@selector(didClickFollowArtistButton:)]) {
        
        if (self.userIsFollowingArtist) {
            self.userIsFollowingArtist = NO;
            [self.JCInvteFollowHeaderDelegate didClickFollowArtistButton:self.userIsFollowingArtist];
            [self setLoadingStateFor:self.followartist andLable:self.UILableFollowArtist andUIView:self.UIViewHitTargetFollowArtist];
            [self initSppiner:self.followArtistSpinner andAddToView:self.UIViewHitTargetFollowArtist];
          }else{
            self.userIsFollowingArtist = YES;
            [self.JCInvteFollowHeaderDelegate didClickFollowArtistButton:self.userIsFollowingArtist];
            [self setLoadingStateFor:self.followartist andLable:self.UILableFollowArtist andUIView:self.UIViewHitTargetFollowArtist];
            [self initSppiner:self.followArtistSpinner andAddToView:self.UIViewHitTargetFollowArtist];
        }
        
    }
}

-(void)UIButtonAddFriendsAction{
    
    NSLog(@"addfriends");
    
      if (self.JCInvteFollowHeaderDelegate && [self.JCInvteFollowHeaderDelegate respondsToSelector:@selector(didClickAddFriendsAction)]) {
          
          [self.JCInvteFollowHeaderDelegate didClickAddFriendsAction];
          
          
      }
}

-(void)setLoadingStateFor:(UIButton*)button andLable:(UILabel*)lable andUIView:(UIView*)view{
    [button setBackgroundImage:nil forState:UIControlStateNormal];
    button.userInteractionEnabled = NO;
    lable.text = @"loading";
    view.userInteractionEnabled = NO;
}

-(void)setImageForButton:(UIButton*)button imageName:(NSString*)imageName andUpdateButtonLable:(UILabel*)lableUnderButton lableText:(NSString*)lableText {
    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    self.UILableInviteFriends.text = lableText;
}



-(void)initSppiner:(UIActivityIndicatorView*)loadingSpinner andAddToView:(UIView*)UIView{
    
        loadingSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        loadingSpinner.color = [UIColor colorWithRed:234.0f/255.0f green:65.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
        loadingSpinner.frame = CGRectMake((UIView.frame.size.width/2) -10, (UIView.frame.size.height/2) -10,20,20);
        [loadingSpinner startAnimating];
        [UIView addSubview:loadingSpinner];
 
}















@end
