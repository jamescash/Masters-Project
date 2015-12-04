//
//  JCSearchResultsObject.m
//  PreAmp
//
//  Created by james cash on 30/11/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCSearchResultsObject.h"
#import "JCImageDownLoader.h"

@implementation JCSearchResultsObject

- (id)initWithJsonRsult:(NSDictionary *)object {
    
    
    self = [super init];
    
    if (self) {
        self.photoDownload = [[JCPhotoDownLoadRecord alloc]init];

        self.artistName = [object objectForKey:@"name"];
        self.echoNestId = [object objectForKey:@"id"];
        
        NSString *searchQueryEncoded = [[object objectForKey:@"name"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
        
        self.photoDownload.name = searchQueryEncoded;
        self.photoDownload.artistMbid = @"error";
    
    
    }

    return self;
}


@end
