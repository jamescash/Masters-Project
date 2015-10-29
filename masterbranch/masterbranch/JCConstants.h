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

//UserEvents
#pragma - UserEvents  - User Status
extern NSString * const JCUserEventUserGoing;
extern NSString * const JCUserEventUserNotGoing;
extern NSString * const JCUserEventUserMaybeGoing;
extern NSString * const JCUserEventUserGotTickets;
#pragma - UserEvents  - Parse - Keys
extern NSString * const JCUserEventUsersInvited;
extern NSString * const JCUserEventUsersEventHostNameUserName;
extern NSString * const JCUserEventUsersTheEventDate;
#pragma - UserEvents  - Local - Keys
extern NSString * const JCUserEventUsersTypeUpcoming;
extern NSString * const JCUserEventUsersTypePast;
extern NSString * const JCUserEventUsersTypeSent;



#pragma - BandsInTownKeys
extern NSString * const BITJSONDateUnformatted;

#pragma - ParseClasses
extern NSString * const JCParseGeneralKeyCreatedAt;



@end

