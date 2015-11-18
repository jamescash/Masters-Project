//
//  JCMyArtistCell.m
//  PreAmp
//
//  Created by james cash on 21/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCMyArtistCell.h"
#import <Parse/Parse.h>


@interface JCMyArtistCell();
@property (weak, nonatomic) IBOutlet UILabel *artistName;


@end

@implementation JCMyArtistCell


-(void)formatCell:(PFObject *)artist{
   self.artistName.text = [artist objectForKey:@"artistName"];
   
    
}
- (IBAction)ButtonUnfollow:(id)sender {
    if (self.JCMyArtistCellDelegate && [self.JCMyArtistCellDelegate respondsToSelector:@selector(didClickUnFollowArtistButton:)])
    {
        [self.JCMyArtistCellDelegate didClickUnFollowArtistButton:self.cellIndex];
        
    }
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
