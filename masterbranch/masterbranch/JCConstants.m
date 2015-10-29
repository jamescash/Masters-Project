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


//UserEvents Keys
#pragma - UserEvents  - User Status - Keys
NSString * const JCUserEventUserGoing          = @"going";
NSString * const JCUserEventUserNotGoing       = @"notGoing";
NSString * const JCUserEventUserMaybeGoing     = @"maybe";
NSString * const JCUserEventUserGotTickets     = @"gotTickets";
#pragma - UserEvents  - Parse - Keys
NSString * const JCUserEventUsersInvited       = @"invited";
NSString * const JCUserEventUsersTheEventDate  = @"eventDate";
NSString * const JCUserEventUsersEventHostNameUserName = @"eventHostName";
#pragma - UserEvents  - Local - Keys
NSString * const JCUserEventUsersTypeUpcoming  = @"upcoming";
NSString * const JCUserEventUsersTypePast      = @"past";
NSString * const JCUserEventUsersTypeSent      = @"sent";

#pragma - BandsInTownKeys
NSString * const BITJSONDateUnformatted        = @"yyy-MM-dd'T'HH:mm:ss";

#pragma - ParseClasses
NSString * const JCParseGeneralKeyCreatedAt    = @"createdAt";

@end
