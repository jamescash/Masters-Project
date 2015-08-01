//
//  JCHTTPClient.h
//  masterbranch
//
//  Created by james cash on 30/07/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCHttpFacade.h"
#import "eventObject.h"



//@protocol JCHTTPClientdelegate;


@interface JCHTTPClient : NSObject

@property(nonatomic,strong) NSMutableArray* instaresults;
-(void)InstagramFromHashtag: (NSString*)instasearchquery;


- (id)initWithEvent:(eventObject*)curentEvent;



//@property (strong, nonatomic) id<JCHTTPClientdelegate>JCHTTPClientdelegate;

@end


//@protocol JCHTTPClientdelegate <NSObject>

//- (void)APIreqestDidFinish1:(NSArray*)paresedData;

//@end

