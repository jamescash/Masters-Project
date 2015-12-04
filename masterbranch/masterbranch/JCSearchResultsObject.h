//
//  JCSearchResultsObject.h
//  PreAmp
//
//  Created by james cash on 30/11/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JCPhotoDownLoadRecord.h"

@interface JCSearchResultsObject : NSObject
@property (nonatomic,strong)NSString *artistName;
@property (nonatomic,strong)NSString *echoNestId;
@property (nonatomic,strong)UIImage *artistImage;
@property (nonatomic) JCPhotoDownLoadRecord *photoDownload;

- (id)initWithJsonRsult:(NSDictionary *)object;
@end
