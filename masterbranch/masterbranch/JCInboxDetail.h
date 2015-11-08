//
//  JCInboxDetail.h
//  PreAmp
//
//  Created by james cash on 20/09/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "UIScrollView+VGParallaxHeader.h"
#import "JCUserAttendingGigCell.h"



@interface JCInboxDetail : UIViewController <UITextFieldDelegate,UITextViewDelegate,UIActionSheetDelegate,JCUserAttendingGigCellDelegate>
@property (nonatomic,strong) PFObject *userEvent;
@property (nonatomic,strong) UIImage *selectedInviteImage;

@end
