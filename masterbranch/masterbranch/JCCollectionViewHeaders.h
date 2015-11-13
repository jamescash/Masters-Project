//
//  JCCollectionViewHeaders.h
//  masterbranch
//
//  Created by james cash on 22/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eventObject.h"


@interface JCCollectionViewHeaders : UICollectionReusableView
//-(void)setHeaderText:(NSString *)text;
-(void)formateHeaderwithEventObject:(eventObject*)eventObject;
-(void)formateHeaderwithString:(NSString*)headerTitle;
@end
