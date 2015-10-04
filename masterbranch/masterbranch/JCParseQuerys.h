//
//  JCParseQuerys.h
//  PreAmp
//
//  Created by james cash on 03/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCParseQuerys : NSObject


+(JCParseQuerys*)sharedInstance;

-(void)getMyAtrits:(void(^)(NSError* error,NSArray* response))finishedGettingMyAtrits;
-(void)getMyAtritsUpComingGigs:(void(^)(NSError* error,NSMutableArray*response))finishedGettingMyAtritsUpcomingGigs;

-(void)getMyFriends:(void(^)(NSError* error,NSArray* response))finishedGettingMyFriends;
-(void)getMyInvites:(void(^)(NSError* error,NSArray* response))finishedGettingMyInvites;

@property (nonatomic,strong) NSArray* MyArtist;
@property (nonatomic,strong) NSArray* MyFriends;
@property (nonatomic,strong) NSArray* MyInvties;
@property (nonatomic,strong) NSMutableArray* MyArtistUpcomingGigs;




@end
