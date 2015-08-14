//
//  JCSocailStreamController.h
//  masterbranch
//
//  Created by james cash on 28/06/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eventObject.h"
#import "JCHttpFacade.h"


@protocol JCSocailStreamControllerDelegate;
@class JCSocailStreamControllerDelegate;


@interface JCSocailStreamController : UITableViewController <JCHttpFacadedelegate>;
@property (nonatomic) eventObject *currentevent;
@property (nonatomic, weak) id <JCSocailStreamControllerDelegate> JCSocailStreamControllerDelegate;
- (IBAction)NavBarBackButton:(id)sender;
@end


@protocol JCSocailStreamControllerDelegate <NSObject>
- (void)SocialStreamViewControllerDidSelectDone:(JCSocailStreamController *)controller;
@end

