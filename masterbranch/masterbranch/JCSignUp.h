//
//  JCSignUp.h
//  PreAmp
//
//  Created by james cash on 25/09/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JCSignUpVCDelegat;


@interface JCSignUp : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>//,//UITextFieldDelegate>
@property (strong,nonatomic) id <JCSignUpVCDelegat>JCSignUpVCDelegat;

@end

@protocol JCSignUpVCDelegat <NSObject>
-(void)UserSignedUp;
@end