//
//  JCInvitationCell.m
//  PreAmp
//
//  Created by james cash on 09/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCInvitationCell.h"

@implementation JCInvitationCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"CELL initiation");
        self.ArtistName.text = @"test";
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
