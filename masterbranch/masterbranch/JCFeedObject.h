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

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
//@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) UIImage *imageName;

@end
