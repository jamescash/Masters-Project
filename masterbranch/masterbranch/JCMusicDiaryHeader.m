//
//  JCMusicDiaryHeader.m
//  PreAmp
//
//  Created by james cash on 11/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCMusicDiaryHeader.h"

@implementation JCMusicDiaryHeader





-(void)setHeaderText:(NSString *)text {
    
    //in the middle of stlying header
    
    self.month.text = text;
    self.month.textColor = [UIColor colorWithRed:234.0f/255.0f green:65.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    self.backgroundColor = [UIColor whiteColor];
    //self.layer.borderWidth = 5.0f;
    //self.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor colorWithRed:234.0f green:65.0f blue:150.0f alpha:1]);
    //self.layer.borderColor = [[UIColor colorWithRed:23.0f green:6.0f blue:140.0f alpha:1] CGColor];
    
    
}

@end
