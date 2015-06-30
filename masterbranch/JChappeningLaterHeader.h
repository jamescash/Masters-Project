//
//  JChappeningLaterHeader.h
//  masterbranch
//
//  Created by james cash on 29/06/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eventObject.h"


//@interface JChappeningLaterHeader : UIViewController

@protocol RKCardViewDelegate <NSObject>
@optional
- (void)nameTap;
- (void)coverPhotoTap;
- (void)profilePhotoTap;
@end


@interface JChappeningLaterHeader : UIView

@property (nonatomic, weak) IBOutlet id<RKCardViewDelegate> delegate;
@property (nonatomic)UIImageView *profileImageView;
@property (nonatomic)UIImageView *coverImageView;
@property (nonatomic)UILabel *titleLabel;
@property (nonatomic) eventObject *currentevent;

- (void)addBlur;
- (void)removeBlur;
- (void)addShadow;
- (void)removeShadow;

@end