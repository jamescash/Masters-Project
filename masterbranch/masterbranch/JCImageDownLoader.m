//
//  JCImageDownLoader.m
//  masterbranch
//
//  Created by james cash on 21/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "JCImageDownLoader.h"


@interface JCImageDownLoader ()
@property (nonatomic, readwrite, strong) NSIndexPath *indexPathInTableView;
@property (nonatomic, readwrite, strong) JCPhotoDownLoadRecord *photoRecord;
@property (nonatomic,strong) NSData *imageData;
@end

@implementation JCImageDownLoader

#pragma mark - Life Cycle

- (id)initWithPhotoRecord:(JCPhotoDownLoadRecord *)record atIndexPath:(NSIndexPath *)indexPath delegate:(id<ImageDownloaderDelegate>)theDelegate {
    
    if (self = [super init]) {
        self.delegate = theDelegate;
        self.indexPathInTableView = indexPath;
        self.photoRecord = record;
    }
    return self;
}

#pragma mark - Downloading image

- (void)main {
    
    // 4
    @autoreleasepool {
        
       
        NSLog(@"JCimagedownloader downloading with URL %@",self.photoRecord.URL);
        
        if (self.isCancelled)
            return;
        
       
        if (self.photoRecord.URL == nil) {
            NSLog(@"That was a nil URL inside Photo Downloader");
            self.photoRecord.failed = YES;
        }else{
       
            NSLog(@"%@ contents of the URL",self.photoRecord.URL);
            self.imageData = [[NSData alloc] initWithContentsOfURL:self.photoRecord.URL];

        }
        

        
        if (self.isCancelled) {
            self.imageData = nil;
            return;
        }
        
        if (self.imageData) {
            UIImage *downloadedImage = [UIImage imageWithData:self.imageData];
            self.photoRecord.image = downloadedImage;
        }
        else {
            self.photoRecord.failed = YES;
        }
        
        self.imageData = nil;
        
        if (self.isCancelled)
            return;
        
        [(NSObject *)self.delegate performSelectorOnMainThread:@selector(imageDownloaderDidFinish:) withObject:self waitUntilDone:NO];
        
    }
}


@end
