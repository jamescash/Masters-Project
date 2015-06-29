//
//  JChappeningLaterHeader.h
//  masterbranch
//
//  Created by james cash on 29/06/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eventObject.h"


@interface JChappeningLaterHeader : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *ArtistName;
@property (weak, nonatomic) IBOutlet UILabel *venueName;
@property (nonatomic) eventObject *currentevent;
@property (weak, nonatomic) IBOutlet UIImageView *ArtistImage;

@end
