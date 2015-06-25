//
//  EventObjectParser.h
//  masterbranch
//
//  Created by james cash on 25/06/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventObjectParser : NSObject


-(NSString*)formatDateForAPIcall:(NSDate*)date;

-(NSDictionary*)GetEventJSON: (NSString*)countyName dateObject:(NSString*)date;

-(NSString*)makeInstagramSearch: (NSString*) eventTitle;

-(NSString*)makeTitterSearch: (NSString*)eventTitle venueName:(NSString*)venueName;

-(NSString*)GetEventStatus: (NSString*) currentEventDate;




@end
