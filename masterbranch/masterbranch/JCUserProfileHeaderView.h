//
//  JCUserProfileHeaderView.h
//  PreAmp
//
//  Created by james cash on 26/11/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface JCUserProfileHeaderView : UIView
@property (weak, nonatomic) IBOutlet PFImageView *BGImage;
@property (weak, nonatomic) IBOutlet PFImageView *ProfileImage;
+(instancetype)instantiateFromNib;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *blurView;
@property (weak, nonatomic) IBOutlet UILabel *UILableUserName;
@property (weak, nonatomic) IBOutlet UILabel *UILableUserParseName;

@end

