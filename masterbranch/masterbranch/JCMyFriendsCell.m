//
//  JCMyFriendsCell.m
//  PreAmp
//
//  Created by james cash on 21/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCMyFriendsCell.h"

@interface JCMyFriendsCell ()
@property (weak, nonatomic) IBOutlet UILabel *userName;
@end

@implementation JCMyFriendsCell

-(void)formateCell:(PFUser *)user{
    self.userName.text = user.username;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
