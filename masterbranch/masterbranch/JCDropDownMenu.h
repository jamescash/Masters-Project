//
//  JCDropDownMenu.h
//  PreAmp
//
//  Created by james cash on 28/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JCDropDownMenuDelagte;

@interface JCDropDownMenu : UIView <UIGestureRecognizerDelegate>



@property (strong ,nonatomic) UIView *contextMenuButtonCover;
@property (strong, nonatomic) id<JCDropDownMenuDelagte>JCDropDownMenuDelagte;

-(void)animatContextMenu;
@end


//Deligation CallBacks 
@protocol JCDropDownMenuDelagte <NSObject>
- (void)contextMenuButtonCoverClicked;
- (void)contextMenuButtonFirstClicked;
- (void)contextMenuButtonSecondClicked;
- (void)contextMenuButtonThirdClicked;
-(void)didTapAnywhere;
@end