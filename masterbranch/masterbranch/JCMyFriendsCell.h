//
//  JCMyFriendsCell.h
//  PreAmp
//
//  Created by james cash on 21/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface JCMyFriendsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
-(void)formateCell:(PFUser*)user;

@end