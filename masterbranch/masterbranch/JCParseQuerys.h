//
//  JCParseQuerys.h
//  PreAmp
//
//  Created by james cash on 03/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "eventObject.h"

@interface JCParseQuerys : NSObject


+(JCParseQuerys*)sharedInstance;


//Querys to the backend
-(void)getEventComments:(NSString*) eventiD complectionBlock:(void(^)(NSError* error,NSMutableArray* response))finishedgettingEventComments;
-(void)getMyAtrits:(void(^)(NSError* error,NSArray* response))finishedGettingMyAtrits;
-(void)getMyAtritsUpComingGigs:(BOOL)onlyIrishGigs comletionblock: (void(^)(NSError* error,NSMutableArray*response))finishedGettingMyAtritsUpcomingGigs;
-(void)getMyFriends:(void(^)(NSError* error,NSArray* response))finishedGettingMyFriends;
-(void)getMyInvites:(void(^)(NSError* error,NSArray* response))finishedGettingMyInvites;





//Saving to the backend
-(void)UserFollowedArtist:(eventObject*)currentEvent complectionBlock:(void(^)(NSError* error))finishedSavingArtist;
-(void)saveCommentToBackend:(NSDictionary*)userInfo complectionBlock:(void(^)(NSError* error))finishedsavingComment;
-(void)creatUserEvent:(eventObject*)eventObject invitedUsers: (NSArray*)recipientIds complectionBlock:(void(^)(NSError* error))finishedCreatingUserEvent;
//Async Iamge Downloader for tableView

-(void)DownloadImageForArtist:(NSString*)artistName completionBlock:(void(^)(NSError*error,UIImage* image))finishedDownloadingImage;


//local Data Storage



@property (nonatomic,strong) NSMutableArray* MyArtist;
@property (nonatomic,strong) NSArray* MyFriends;
@property (nonatomic,strong) NSArray* MyInvties;
@property (nonatomic,strong) NSArray* EventComments;
@property (nonatomic,strong) NSMutableArray* MyArtistUpcomingGigs;




@end
