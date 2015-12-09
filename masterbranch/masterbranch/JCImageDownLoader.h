//
//  JCImageDownLoader.h
//  masterbranch
//
//  Created by james cash on 21/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JCPhotoDownLoadRecord.h"

//Stright forawrd image downloader
//Download image and notfiy the delage class and return image
//passed with intitated URL comes from JCURLRetivers

@protocol ImageDownloaderDelegate;

@interface JCImageDownLoader : NSOperation

@property (nonatomic, weak) id <ImageDownloaderDelegate> delegate;

@property (nonatomic, readonly, strong) NSIndexPath *indexPathInTableView;
@property (nonatomic, readonly, strong) JCPhotoDownLoadRecord *photoRecord;

- (id)initWithPhotoRecord:(JCPhotoDownLoadRecord *)record atIndexPath:(NSIndexPath *)indexPath delegate:(id<ImageDownloaderDelegate>) theDelegate;

@end


@protocol ImageDownloaderDelegate <NSObject>
- (void)imageDownloaderDidFinish:(JCImageDownLoader *)downloader;
@end