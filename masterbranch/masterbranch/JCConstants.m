//
//  JCConstants.m
//  PreAmp
//
//  Created by james cash on 26/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCConstants.h"

@implementation JCConstants

#pragma - Parse ClassNames
NSString * const JCParseClassUserEvents        = @"UserEvent";
NSString * const JCParseClassActivity          = @"Activity";


//UserEvents Keys
#pragma - UserEvents  - User Status - Keys
NSString * const JCUserEventUserGoing          = @"going";
NSString * const JCUserEventUserNotGoing       = @"notGoing";
NSString * const JCUserEventUserMaybeGoing     = @"maybe";
NSString * const JCUserEventUserGotTickets     = @"gotTickets";
//Backend UserEvents Class - Keys
NSString * const JCUserEventUsersInvited       = @"invited";
NSString * const JCUserEventUsersTheEventDate  = @"eventDate";
NSString * const JCUserEventUsersEventPhoto    = @"eventPhoto";
NSString * const JCUserEventUsersEventTitle    = @"eventTitle";
NSString * const JCUserEventUsersEventVenue    = @"eventVenue";
NSString * const JCUserEventUsersEventHostId   = @"eventHostId";
NSString * const JCUserEventUsersEventCity     = @"city";
NSString * const JCUserEventUsersEventInvited  = @"invited";
NSString * const JCUserEventUsersSubscribedForNotifications = @"userSubscribedForNotifications";




NSString * const JCUserEventUsersEventHostNameUserName = @"eventHostName";
//Backend UserEvents Class Local - Keys
NSString * const JCUserEventUsersTypeUpcoming  = @"upcoming";
NSString * const JCUserEventUsersTypePast      = @"past";
NSString * const JCUserEventUsersTypeSent      = @"sent";

#pragma - BandsInTownKeys
NSString * const BITJSONDateUnformatted        = @"yyy-MM-dd'T'HH:mm:ss";


//Backend Activitys Class - Keys
#pragma - Activitys
NSString * const JCUserActivityFromUser        = @"fromUser";
NSString * const JCUserActivityType            = @"type";
NSString * const JCUActivityTypeUserComment    = @"userComment";
NSString * const JCUserActivityCommentOwner    = @"commentOwner";
NSString * const JCUserActivityContent         = @"content";
NSString * const JCUserActivityRelatedObjectId = @"relatedObjectId";



#pragma - AddmyFriendsMyArtist page type
NSString * const JCAddMyFriendsMyArtistTypeArtist         = @"artist";
NSString * const JCAddMyFriendsMyArtistTypeFriends        = @"friends";
NSString * const JCAddMyFriendsMyArtistTypeFriendsInvited = @"firendsInvitied";

#pragma - ParseClasses
NSString * const JCParseGeneralKeyCreatedAt    = @"createdAt";

@end
