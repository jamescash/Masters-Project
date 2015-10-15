//
//  JCMusicDiaryObject.h
//  PreAmp
//
//  Created by james cash on 13/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface JCMusicDiaryObject : NSObject

@property(nonatomic,strong) NSDate            *UpcomingGigDate;
@property(nonatomic,strong) PFObject          *UpcomingGigObject;
@property(nonatomic,strong) NSDateComponents  *dateComponents;
@property(nonatomic,strong) UIImage           *artistImage;

- (id)initWithEvent:(NSDate*)UpcomingGigDate andDateComponents:(NSDateComponents*)dateComponents andGigObject:(PFObject*)GigObject;


@end
