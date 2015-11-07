//
//  JCCommentCell.m
//  PreAmp
//
//  Created by james cash on 07/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCCommentCell.h"
#import "NSDate+TimeAgo.h"

@interface JCCommentCell ()
@property (weak, nonatomic) IBOutlet UIView *uiViewCommentBorder;


@end

@implementation JCCommentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
    // Configure the view for the selected state
}

-(void)formatcell:(PFObject *)commentActivity{
   
    self.uiViewCommentBorder.layer.cornerRadius = 5.0f;
    //self.uiViewCommentBorder.layer.borderWidth = 1.0f;
    //self.uiViewCommentBorder.layer.borderColor = [[UIColor colorWithRed:234.0f/255.0f green:65.0f/255.0f blue:150.0f/255.0f alpha:1.0f]CGColor];
    NSDate *createdAt = [commentActivity createdAt];
    NSString *ago = [createdAt timeAgo];

    
    self.lableDateTime.text = ago;
    
    NSString *comment = [commentActivity objectForKey:@"content"];
    self.commentText.text = comment;
    PFUser *commentOwner = [commentActivity objectForKey:@"commentOwner"];
    
    //NSString *realName = [commentOwner objectForKey:@"realName"];
    //if (realName) {
        self.userName.text = [commentOwner objectForKey:@"realName"];
    //}
    
    PFFile *userImage = [commentOwner objectForKey:@"thumbnailProfilePicture"];
     self.userImage.file = userImage;
    [self.userImage loadInBackground];
    CGRect  rect=self.frame;
    rect.size.height = [self getCommentHeight:comment Width:(self.bounds.size.width-70)];
    self.frame=rect;
    
    
}

//-(NSString*)formatDate: (NSString*)date{
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    [dateFormat setDateFormat:@"yyy-MM-dd'T'HH:mm:ss"];
//   
//    NSDate *eventDateTime = [dateFormat dateFromString:date];
//    //time_t unixTime = (time_t) [eventDateTime timeIntervalSince1970];
//    //NSTimeInterval timeInMiliseconds = [eventDateTime timeIntervalSince1970];
//
//    //NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:timeInMiliseconds];
//
//
//    NSString *ago = [eventDateTime timeAgo];
//   
//    return ago;
//    
//}

//mathod to calculates that hight of the text so we later set dynamic hights for the table view
-(float )getCommentHeight :(NSString *)text Width :(float)textWidth
{
    
    NSAttributedString *attributedText =
    [[NSAttributedString alloc]
     initWithString:text
     attributes:@
     {
         
     NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Light" size:15.0]
     }];
    
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){textWidth, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    CGSize finalSize = rect.size;
    return finalSize.height;  }
@end
