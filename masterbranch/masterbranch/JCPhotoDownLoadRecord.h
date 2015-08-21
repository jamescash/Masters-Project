//
//  JCPhotoDownLoadRecord.h
//  masterbranch
//
//  Created by james cash on 21/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//give photo record a referance to current event so it know what artist image to download


@interface JCPhotoDownLoadRecord : NSObject

@property (nonatomic, strong) NSString *name;  // To store the name of image
@property (nonatomic, strong) UIImage *image; // To store the actual image
@property (nonatomic, strong) NSString *artistMbid; //MBID used for serching for image
@property (nonatomic, strong) NSURL *URL; // To store the URL of the image
@property (nonatomic, readonly) BOOL hasURL; // Return YES if URL is Downloaded.
@property (nonatomic, readonly) BOOL hasImage; // Return YES if image is downloaded.
@property (nonatomic, getter = isFiltered) BOOL filtered; // Return YES if image is sepia-filtered
@property (nonatomic, getter = isFailed) BOOL failed; // Return Yes if image failed to be downloaded

@end
