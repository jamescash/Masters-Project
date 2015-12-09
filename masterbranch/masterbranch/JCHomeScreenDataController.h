//
//  JCHomeScreenDataController.h
//  PreAmp
//
//  Created by james cash on 15/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/////////Class summery
/**
 1. This class is built to deal with external calls to BandsIntown/Echo nest 
 2. Build with the same principals as JCPaseQuerys
 
 */

@interface JCHomeScreenDataController : NSObject

#pragma - Get - BandsInTown
//get gigs around the users current location on a certain date
-(void)getEventsforDate:(NSDate*)date usingLocation: (NSString*) latitude Longditude:(NSString*)longditude competionBlock:(void(^)(NSError* error,NSArray* response))finishedGettingMyAtrits;

//get upoming gig for a specific artist
-(void)getUpcomingGigsForArtist:(NSString*)artist competionBlock:(void(^)(NSError* error,NSArray* response))finishedGettingMyAtrits;

//Get upcoming gigs for artist seach - Return dic notifying other classes of 1.No upcoming gigs, Unkown Atist, Irish gigs,Gigs near Irealnd, Other gigs
-(void)getArtistUpComingEventsForArtistSearch:(NSString*)artistname andMbidNumber:(NSString*)mbidNumber competionBlock:(void(^)(NSError* error,NSDictionary* results))finishedGettingMbid;

//get more info about an artist
-(void)getArtistImage:(NSString*)artistname andMbidNumber:(NSString*)mbidNumber competionBlock:(void(^)(NSError* error,NSDictionary *artistInfo))finishedGettingArtistImage;

#pragma - Get - Echo Nets

-(void)getmbidNumberfor:(NSString*)artistname competionBlock:(void(^)(NSError* error,NSString* mbid))finishedGettingSearchResults;

//go to echo nest and get a list of suggested artust names for a search query
-(void)getArtistSuggestionsForSearchQuery:(NSString*)searchQuery competionBlock:(void(^)(NSError* error,NSArray* artistSuggestions))finishedGettingArtistSuggestionsForSearchQuery;

@end
