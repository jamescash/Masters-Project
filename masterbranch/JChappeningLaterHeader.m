//
//  JChappeningLaterHeader.m
//  masterbranch
//
//  Created by james cash on 29/06/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "JChappeningLaterHeader.h"

@implementation JChappeningLaterHeader

-(void)viewWillAppear:(BOOL)animated{
    
    self.ArtistName.text = self.currentevent.eventTitle;
    self.venueName.text = self.currentevent.venueName;
    self.ArtistImage = self.currentevent.coverpic;
    
    

};

@end
