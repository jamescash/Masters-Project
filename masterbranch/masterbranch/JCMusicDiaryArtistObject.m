//
//  JCMusicDiaryArtistObject.m
//  PreAmp
//
//  Created by james cash on 23/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCMusicDiaryArtistObject.h"

@implementation JCMusicDiaryArtistObject


- (id)initWithArtits:(PFObject*)artits andupComingGig:(PFObject*)upcomingGig{
    self = [super init];
    if (self) {
        
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-LL-dd HH:mm:ss"];
        NSString *objectdate = [upcomingGig objectForKey:@"datetime"];
        NSString *dateformatted = [objectdate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        NSDate *date = [dateFormat dateFromString:dateformatted];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        unsigned unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
        NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:date];
        //NSDate *FormattedDate = [calendar dateFromComponents:dateComponents];
        
        self.artist         = artits;
        self.artistImage    = [artits objectForKey:@"artistImage"];
        self.dateComponents = dateComponents;
   

        
        
    }
    return self;
}


@end
