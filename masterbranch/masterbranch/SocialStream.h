//
//  SocialStream.h
//  Second_Prototype
//
//  Created by james cash on 01/06/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eventObject.h"

@interface SocialStream : UITableViewController
@property (nonatomic) eventObject *currentevent;
@property (strong, nonatomic) NSArray *twitterResult;
@property (strong, nonatomic) NSDictionary *tweet;
@property (nonatomic) NSArray *instaResults;
@property (nonatomic) NSDictionary *instagramobject;


@end
