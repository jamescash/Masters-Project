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


//Not all the artist images were coming back when we were just using bandsintown so we had add I few diffrent place that we could look for matching artist images.
//This URL retever search BandsinTown and Echo Nest with and with out MBID numbers and then uses the first (best) possible match 

@interface JCURLRetriever : NSOperation


@property (nonatomic, weak) id <JCURLRetrieverDelegate> delegate;
@property (nonatomic, readonly, strong) NSIndexPath *indexPathInTableView;
@property (nonatomic, readonly, strong) JCPhotoDownLoadRecord *photoRecord;

- (id)initWithPhotoRecord:(JCPhotoDownLoadRecord *)record atIndexPath:(NSIndexPath *)indexPath delegate:(id<JCURLRetrieverDelegate>) theDelegate;

@end

@protocol JCURLRetrieverDelegate <NSObject>
- (void)JCURLRetrieverDidFinish:(JCURLRetriever *)downloader;
@end