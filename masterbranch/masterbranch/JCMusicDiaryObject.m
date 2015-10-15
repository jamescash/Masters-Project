//
//  JCMusicDiaryObject.m
//  PreAmp
//
//  Created by james cash on 13/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCMusicDiaryObject.h"

@implementation JCMusicDiaryObject

- (id)initWithEvent:(NSDate*)UpcomingGigDate andDateComponents:(NSDateComponents*)dateComponents andGigObject:(PFObject*)GigObject{
    
    
    self = [super init];
    if (self) {
        self.UpcomingGigDate = UpcomingGigDate;
        self.UpcomingGigObject = GigObject;
        self.dateComponents = dateComponents;
    }

    return self;
}



@end
