//
//  JCMusicDiaryHeader.h
//  PreAmp
//
//  Created by james cash on 11/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCMusicDiaryHeader : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *month;


-(void)setHeaderText:(NSString *)text;

@end
