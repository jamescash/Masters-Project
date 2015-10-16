//
//  JCHomeScreenDataController.h
//  PreAmp
//
//  Created by james cash on 15/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCHomeScreenDataController : NSObject

-(void)getEventsforDate:(NSDate*)date usingLocation: (NSString*) latitude Longditude:(NSString*)longditude competionBlock:(void(^)(NSError* error,NSArray* response))finishedGettingMyAtrits;


-(void)getUpcomingGigsForArtist:(NSString*)artist competionBlock:(void(^)(NSError* error,NSArray* response))finishedGettingMyAtrits;


@end
