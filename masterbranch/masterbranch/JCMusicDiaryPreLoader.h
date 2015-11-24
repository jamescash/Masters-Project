//
//  JCMusicDiaryPreLoader.h
//  PreAmp
//
//  Created by james cash on 23/11/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCMusicDiaryPreLoader : UIView
+ (instancetype)instantiateFromNib;

@property (weak, nonatomic) IBOutlet UILabel *UILableTextString;
@end
