//
//  JCPhotoFiltering.h
//  masterbranch
//
//  Created by james cash on 21/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreImage/CoreImage.h>
#import "JCPhotoDownLoadRecord.h"


@protocol ImageFiltrationDelegate;


@interface JCPhotoFiltering : NSOperation


@property (nonatomic, weak) id <ImageFiltrationDelegate> delegate;
@property (nonatomic, readonly, strong) NSIndexPath *indexPathInTableView;
@property (nonatomic, readonly, strong) JCPhotoDownLoadRecord *photoRecord;

- (id)initWithPhotoRecord:(JCPhotoDownLoadRecord *)record atIndexPath:(NSIndexPath *)indexPath delegate:(id<ImageFiltrationDelegate>)theDelegate;


@end

@protocol ImageFiltrationDelegate <NSObject>
- (void)imageFiltrationDidFinish:(JCPhotoFiltering *)filtration;
@end