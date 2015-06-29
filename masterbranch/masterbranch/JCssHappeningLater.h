//
//  JCssHappeningLater.h
//  masterbranch
//
//  Created by james cash on 29/06/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "eventObject.h"
#import "JCSocailStreamController.h"
#import "JChappeningLaterHeader.h"



@interface JCssHappeningLater : UIViewController

@property (nonatomic) eventObject *currentevent;
@property (weak, nonatomic) IBOutlet UIView *tableViewBox;
@property (weak, nonatomic) IBOutlet UIView *TopViewBox;


@end
