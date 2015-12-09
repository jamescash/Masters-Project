//
//  JCMusicDiaryArtistObject.h
//  PreAmp
//
//  Created by james cash on 23/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

//MusicDiary object to parse data coing from our backend intp usable objects used as the data model to build our discovery page 

@interface JCMusicDiaryArtistObject : NSObject
@property (nonatomic,strong) PFObject          *artist;
@property (nonatomic,strong) NSDateComponents  *dateComponents;
@property (nonatomic,strong) NSString          *month;
@property (nonatomic,strong) NSString          *year;
@property (nonatomic,strong) UIImage           *artistImage;
//@property (nonatomic,assign) NSInteger         *numberOfGigsThisMonth;

- (id)initWithArtits:(PFObject*)artits andupComingGig:(PFObject*)upcomingGig;

@end
