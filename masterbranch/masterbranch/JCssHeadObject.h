//
//  JCssHeadObject.h
//  masterbranch
//
//  Created by james cash on 30/06/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "eventObject.h"


@interface JCssHeadObject : UIView


//- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

-(id)initWithFrame:(CGRect)frame andCurrentEvent:(eventObject*) eventOjbect;

//@property (strong, nonatomic) UILabel *dateAndTime;
//@property (strong, nonatomic) UIImageView *coverPic;
//@property (strong, nonatomic) UIImageView *profilePic;
//@property (strong, nonatomic) UILabel *ArtistName;
//@property (strong, nonatomic) UILabel *Location;
@property (strong, nonatomic) UILabel *test;


@property (nonatomic) eventObject *currentEvent;

@end
