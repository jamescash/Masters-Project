//
//  JCHappeningTonightVC.h
//  masterbranch
//
//  Created by james cash on 18/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eventObject.h"

@interface JCHappeningTonightVC : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (nonatomic,strong)eventObject *currentEvent;
@end
