//
//  JCPendingOperations.m
//  masterbranch
//
//  Created by james cash on 21/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "JCPendingOperations.h"

@implementation JCPendingOperations


-(NSMutableDictionary *)URLRetrieversInProgress {
    if (!_URLRetrieversInProgress) {
        _URLRetrieversInProgress = [[NSMutableDictionary alloc] init];
    }
    return _URLRetrieversInProgress;
    
    
}

- (NSOperationQueue *)URLRetriever {
    if (!_URLRetriever) {
        _URLRetriever = [[NSOperationQueue alloc] init];
        _URLRetriever.name = @"Download Queue";
        _URLRetriever.maxConcurrentOperationCount = 2;
    }
    return _URLRetriever;
}



- (NSMutableDictionary *)downloadsInProgress {
    if (!_downloadsInProgress) {
        _downloadsInProgress = [[NSMutableDictionary alloc] init];
    }
    return _downloadsInProgress;
}

- (NSOperationQueue *)downloadQueue {
    if (!_downloadQueue) {
        _downloadQueue = [[NSOperationQueue alloc] init];
        _downloadQueue.name = @"Download Queue";
        _downloadQueue.maxConcurrentOperationCount = 2;
    }
    return _downloadQueue;
}

- (NSMutableDictionary *)filtrationsInProgress {
    if (!_filtrationsInProgress) {
        _filtrationsInProgress = [[NSMutableDictionary alloc] init];
    }
    return _filtrationsInProgress;
}

- (NSOperationQueue *)filtrationQueue {
    if (!_filtrationQueue) {
        _filtrationQueue = [[NSOperationQueue alloc] init];
        _filtrationQueue.name = @"Image Filtration Queue";
        _filtrationQueue.maxConcurrentOperationCount = 2;
    }
    return _filtrationQueue;
}

@end
