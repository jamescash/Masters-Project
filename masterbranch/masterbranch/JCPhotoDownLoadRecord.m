//
//  JCPhotoDownLoadRecord.m
//  masterbranch
//
//  Created by james cash on 21/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "JCPhotoDownLoadRecord.h"

@implementation JCPhotoDownLoadRecord



- (BOOL)hasURL {
    return _URL != nil;
}

- (BOOL)hasImage {
    return _image != nil;
}


- (BOOL)isFailed {
    return _failed;
}


- (BOOL)isFiltered {
    return _filtered;
}

@end
