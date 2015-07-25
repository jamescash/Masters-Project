//
//  JCFeedObject.h
//  masterbranch
//
//  Created by james cash on 28/06/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface JCFeedObject : NSObject


//custom init method that parses our JSON
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;


//These are the properties we want to parse our JSON into,
//If you notice these properties are the same as the JCsocilStreamCell class.
//This is becuse the JCFeedObject in the model for the the JCsocilStreamCell.

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) UIImage *imageName;

@end
