//
//  JCSearchPageHTTPClient.h
//  masterbranch
//
//  Created by james cash on 16/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol JCSearchPageHTTPClientdelegate;


@interface JCSearchPageHTTPClient : NSObject

- (id)initWithArtistName:(NSString*)artistName;

@property (strong, nonatomic) id<JCSearchPageHTTPClientdelegate>JCSearchPageHTTPClientdelegate;

@end

@protocol JCSearchPageHTTPClientdelegate <NSObject>

-(void)searchResultsGathered:(NSMutableArray*)searchResults;

@end