//
//  JCCommentCell.h
//  PreAmp
//
//  Created by james cash on 07/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>


@interface JCCommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *commentText;
@property (weak, nonatomic) IBOutlet PFImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *lableDateTime;

-(float )getCommentHeight :(NSString *)text Width :(float)textWidth;
-(void)formatcell:(PFObject*)commentActivity;

@end
