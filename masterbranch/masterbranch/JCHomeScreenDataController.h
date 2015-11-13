//
//  JCHomeScreenDataController.h
//  PreAmp
//
//  Created by james cash on 15/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCHomeScreenDataController : NSObject

#pragma - Get - BandsInTown
-(void)getEventsforDate:(NSDate*)date usingLocation: (NSString*) latitude Longditude:(NSString*)longditude competionBlock:(void(^)(NSError* error,NSArray* response))finishedGettingMyAtrits;
-(void)getUpcomingGigsForArtist:(NSString*)artist competionBlock:(void(^)(NSError* error,NSArray* response))finishedGettingMyAtrits;
-(void)getArtistUpComingEventsForArtistSearch:(NSString*)artistname andMbidNumber:(NSString*)mbidNumber competionBlock:(void(^)(NSError* error,NSDictionary* results))finishedGettingMbid;

#pragma - Get - Echo Nets
//in the middle of refactoring search
-(void)getmbidNumberfor:(NSString*)artistname competionBlock:(void(^)(NSError* error,NSString* mbid))finishedGettingSearchResults;



@end
