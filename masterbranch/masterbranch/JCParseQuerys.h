//
//  JCParseQuerys.h
//  PreAmp
//
//  Created by james cash on 03/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>//Backend
#import "eventObject.h"//event objects modeled on bandisintown gig objects

/////////Class summery
/**
 1. This class was built as an interface between the backend and client 
 2. Methods in the class mostly User Objective-C blocks, which means I can makes querys such as; Is user following artist? and await a response while the class asynchronously finds out for me
  */

@interface JCParseQuerys : NSObject

//Make class a shared Instace so only one persist for the whole lifetime of the app
+(JCParseQuerys*)sharedInstance;


//Querys to the backend
-(void)getEventComments:(PFObject *)event complectionBlock:(void(^)(NSError* error,NSMutableArray* response))finishedgettingEventComments;


-(void)getMyAtrits:(void(^)(NSError* error,NSArray* response))finishedGettingMyAtrits;

-(void)getMyAtritsUpComingGigs:(BOOL)onlyIrishGigs comletionblock: (void(^)(NSError* error,NSMutableArray*response))finishedGettingMyAtritsUpcomingGigs;

-(void)getMyFriends:(void(^)(NSError* error,NSArray* response))finishedGettingMyFriends;

-(void)getMyInvitesforType:(NSString*)userEventsType completionblock:(void(^)(NSError* error,NSArray* response))finishedGettingMyInvites;

-(void)getUpcomingGigsforAartis:(PFObject*) artist onMonthIndex: (int)monthIndex isIrishQuery: (BOOL) isIrishQuery complectionblock: (void(^)(NSError* error,NSArray* response))getUpcomingGigsforAartis;

-(void)getPreAmpUsersThatMatchTheseFBids:(NSMutableArray*)FBIds completionblock:(void(^)(NSError* error,NSArray* response))finishedGettingPreAmpUser;

-(void)getPFUserObjectsForParseUserIds:(NSArray*)userIds completionblock:(void(^)(NSError* error,NSArray* response))finishedGettingPreAmpUsers;

-(void)getPeopleThatRecentlyAddedMe:(void(^)(NSError* error,NSArray* response))finishedGettingPeopleThatRecentlyAddedMe;

//Saving to the backend
-(void)UserFollowedArtist:(eventObject*)currentEvent complectionBlock:(void(^)(NSError* error))finishedSavingArtist;

-(void)UserUnfollowedArtist:(eventObject*)currentEvent complectionBlock:(void(^)(NSError* error))finishedUnfollowingArtist;

-(void)UserUnfollowedArtistWithArtistObject:(PFObject*)artist complectionBlock:(void(^)(NSError* error))finishedUnfollowingArtist;

-(void)saveCommentToBackend:(NSDictionary*)userInfo complectionBlock:(void(^)(NSError* error))finishedsavingComment;

-(void)creatUserEvent:(eventObject*)eventObject invitedUsers: (NSArray*)recipientIds complectionBlock:(void(^)(NSError* error))finishedCreatingUserEvent;

-(void)creatUserEventForParseEventObjct:(PFObject*)eventObjct witheventImage:(UIImage*)eventImage invitedUsers: (NSArray*)recipientIds complectionBlock:(void(^)(NSError* error))finishedCreatingUserEvent;

-(void)addUsersToExistingParseUserEvent:(PFObject*)userEvent UsersToadd:(NSArray*)users completionBlock:(void(^)(NSError* error))finishedAddingUsers;

-(void)DownloadImageForArtist:(NSString*)artistName completionBlock:(void(^)(NSError*error,UIImage* image))finishedDownloadingImage;

-(void)getUserEventStatus:(PFObject*) eventobject completionBlock:(void(^)(NSError* error,PFObject* userEventStatusActivity))finishedgetActivtyForUser;

-(void)postActivtyForUserActionEventStatus:(NSString*)usersStauts eventobject:(PFObject*) eventobject completionBlock: (void(^)(NSError* error))finishedpostActivtyForUser;

-(void)updateUserEventStatus:(NSString*)usersStauts eventobject:(PFObject*) eventobject completionBlock: (void(^)(NSError* error))finishedpostActivtyForUser;

-(void)getUsersAttendingUserEvent:(PFObject*) eventobjec completionBlock: (void(^)(NSError* error,NSMutableDictionary *usersAttending))finishedgettingUsersAttendingUserEvent;

-(void)postActivtyForUserActionAddFriend:(PFUser*)UserAdded completionBlock: (void(^)(NSError* error))finishedpostActivtyForAddFriends;

-(void)getUserGoingToEvent:(PFObject*)currentEvent forEventStatus:(NSString*) UserEventStatus completionBlock:(void(^)(NSError* error,NSArray *userGoing))finishedgettingUsersGoingToEvent;


-(void)isUserFollowingArtist:(eventObject*)eventObject completionBlock:(void(^)(NSError* error,BOOL userIsFollowingArtist))finishedisUserFollowingArtist;

-(void)isUserInterestedInEvent:(eventObject*)eventObject completionBlock:(void(^)(NSError* error,BOOL userIsInterestedInGoingToEvent,PFObject* JCParseuserEvent))finishedisUserInterestedInEvent;

-(void)isUserInterestedInParseEvent:(PFObject*)eventObject completionBlock:(void(^)(NSError* error,BOOL userIsInterestedInGoingToEvent,PFObject* JCParseUserEvent))finishedisUserInterestedInEvent;

#pragma - Delete

@property (nonatomic,strong) NSMutableArray* MyArtist;
@property (nonatomic,strong) NSArray* MyFriends;
@property (nonatomic,strong) NSArray* MyInvties;
@property (nonatomic,strong) NSArray* EventComments;
@property (nonatomic,strong) NSMutableArray* MyArtistUpcomingGigs;

@end
