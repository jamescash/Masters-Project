//
//  JCURLRetriever.h
//  masterbranch
//
//  Created by james cash on 21/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCPhotoDownLoadRecord.h"

@protocol JCURLRetrieverDelegate;


@interface JCURLRetriever : NSOperation


@property (nonatomic, weak) id <JCURLRetrieverDelegate> delegate;
@property (nonatomic, readonly, strong) NSIndexPath *indexPathInTableView;
@property (nonatomic, readonly, strong) JCPhotoDownLoadRecord *photoRecord;

- (id)initWithPhotoRecord:(JCPhotoDownLoadRecord *)record atIndexPath:(NSIndexPath *)indexPath delegate:(id<JCURLRetrieverDelegate>) theDelegate;

@end

@protocol JCURLRetrieverDelegate <NSObject>
- (void)JCURLRetrieverDidFinish:(JCURLRetriever *)downloader;
@end