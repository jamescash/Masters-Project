//
//  JCCommentCell.h
//  PreAmp
//
//  Created by james cash on 07/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCCommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *commentText;

-(float )getCommentHeight :(NSString *)text Width :(float)textWidth;


@end
