//
//  JCFeedObject.m
//  masterbranch
//
//  Created by james cash on 28/06/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "JCFeedObject.h"

@implementation JCFeedObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = super.init;
    if (self) {
        self.title = @"testing";
        self.content = @"this is some example content";
        self.username = @"username";
        self.time = @"yesterday";
        self.imageName = dictionary[@"imageName"];
        NSDictionary *images = dictionary [@"images"];
        NSDictionary *lowResolution = images [@"low_resolution"];
        NSString *pictureurl = lowResolution [@"url"];
         NSURL *pic = [NSURL URLWithString:pictureurl];
         NSData *data = [NSData dataWithContentsOfURL:pic];
         UIImage *img = [[UIImage alloc] initWithData:data];
        self.imageName = img;
        
    }
    return self;
}

@end
