//
//  JCPendingOperations.h
//  masterbranch
//
//  Created by james cash on 21/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCPendingOperations : NSObject

@property (nonatomic, strong) NSMutableDictionary *URLRetrieversInProgress;
@property (nonatomic, strong) NSOperationQueue *URLRetriever;



@property (nonatomic, strong) NSMutableDictionary *downloadsInProgress;
@property (nonatomic, strong) NSOperationQueue *downloadQueue;

@property (nonatomic, strong) NSMutableDictionary *filtrationsInProgress;
@property (nonatomic, strong) NSOperationQueue *filtrationQueue;



@end
