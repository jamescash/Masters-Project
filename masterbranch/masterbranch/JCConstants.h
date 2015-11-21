//
//  JCConstants.h
//  PreAmp
//
//  Created by james cash on 26/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCConstants : NSObject


#pragma - Parse ClassNames
extern NSString * const JCParseClassUserEvents;
extern NSString * const JCParseClassActivity;
extern NSString * const JCParseClassUser;
extern NSString * const JCParseClassArtist;


//Backend UserEvents Class - Keys
#pragma - UserEvents  - Keys
extern NSString * const JCUserEventUserGoing;
extern NSString * const JCUserEventUserNotGoing;
extern NSString * const JCUserEventUserMaybeGoing;
extern NSString * const JCUserEventUserGotTickets;
//Backend UserEvents Class - Keys
extern NSString * const JCUserEventUsersInvited;
extern NSString * const JCUserEventUsersEventHostNameUserName;
extern NSString * const JCUserEventUsersTheEventDate;
extern NSString * const JCUserEventUsersEventPhoto;
extern NSString * const JCUserEventUsersEventTitle;
extern NSString * const JCUserEventUsersEventVenue;
extern NSString * const JCUserEventUsersEventHostId;
extern NSString * const JCUserEventUsersEventCity;
extern NSString * const JCUserEventUsersEventInvited;
extern NSString * const JCUserEventUsersEventDate;
extern NSString * const JCUserEventUsersEventIsBeingUpDated;


extern NSString * const JCUserEventUsersSubscribedForNotifications;
//Backend UserEvents Class Local - Keys
extern NSString * const JCUserEventUsersTypeUpcoming;
extern NSString * const JCUserEventUsersTypePast;
extern NSString * const JCUserEventUsersTypeSent;


//Backend Activitys Class - Keys
#pragma - Activitys
extern NSString * const JCUserActivityType;
extern NSString * const JCUActivityTypeUserComment;
extern NSString * const JCUserActivityTypeAddFriend;
extern NSString * const JCUserActivityTypeEventStatus;
extern NSString * const JCUserActivityTypeInvitedFriendsToUserEvent;

extern NSString * const JCUserActivityToEvent;
extern NSString * const JCUserActivityToUser;
extern NSString * const JCUserActivityFromUser;
extern NSString * const JCUserActivityCommentOwner;
extern NSString * const JCUserActivityContent;
extern NSString * const JCUserActivityRelatedObjectId;
extern NSString * const JCUserActivityInvitedUsers;


#pragma - Artist
extern NSString * const JCArtistArtistName;
extern NSString * const JCArtistArtistMbidNumber;
extern NSString * const JCArtistArtistThumbNailImage;


#pragma - Users
extern NSString * const JCUserUserName;
extern NSString * const JCUserthumbNailProfilePicture;
extern NSString * const JCUserArtistRelation;



#pragma - AddmyFriendsMyArtist page type
extern NSString * const JCAddMyFriendsMyArtistTypeArtist;
extern NSString * const JCAddMyFriendsMyArtistTypeFriends;
extern NSString * const JCAddMyFriendsMyArtistTypeFriendsInvited;
extern NSString * const JCAddMyFriendsMyArtistTypeFacebookFriends;
extern NSString * const JCAddMyFriendsMyArtistTypePreAmpFriends;
extern NSString * const JCAddMyFriendsMyArtistTypeJustAddedFriends;
extern NSString * const JCAddMyFriendsMyArtistTypeJustRecentlyAdded;




#pragma - BandsInTownKeys
extern NSString * const BITJSONDateUnformatted;

#pragma - ParseClasses
extern NSString * const JCParseGeneralKeyCreatedAt;

#pragma - Seach Page
//keys for results Dictionary
extern NSString * const JCSeachPageResultsDicNoUpcomingGigs;
extern NSString * const JCSeachPageResultsDicResults;
extern NSString * const JCSeachPageResultsDicResultsArtistUnknown;
extern NSString * const JCSeachPageResultsDicResultsSortedDistanceFromIreland;
extern NSString * const JCSeachPageResultsDicResultsSortedOrderOfUpcmoingDate;

#pragma - Send Intives Page
extern NSString * const JCSendEventIntivesPageCreateAndSendEventInvite;
extern NSString * const JCSendEventIntivesPageAddUserToExistingEvent;




@end

