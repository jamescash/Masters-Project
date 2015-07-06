//
//  JCssHeadObject.m
//  masterbranch
//
//  Created by james cash on 30/06/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "JCssHeadObject.h"

#define CORNER_RATIO 0.015


@implementation JCssHeadObject


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       [self setupView];
    }
    return self;
}


-(id)initWithFrame:(CGRect)frame andCurrentEvent:(eventObject *)eventOjbect
{
    self = [super initWithFrame:frame];
    if (self) {
        
       // self.ArtistName = [[UILabel alloc]init];

        
        
        
       // NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"MyView"
         //                                                    owner:self
                                                           //options:nil];
    //    UIView *_myView = [nibContents objectAtIndex:0];
       // [self addSubview: _myView];
       // [self localizeLabels];

       // self.ArtistName.text = eventOjbect.eventTitle;
        [self addSubview:self.test];
        self.test.text = @"hi";
        NSLog(@"%@ test",self.test.text);
       // NSLog(@"%@",self.ArtistName.text);
       // NSLog(@"%@",eventOjbect.eventTitle);
        
        //_Location.text = eventOjbect.venueName;
        //self.dateAndTime.text = self.currentEvent.eventDate;
       // _profilePic.image = eventOjbect.coverpic.image;
        //_coverPic.image = eventOjbect.coverpic.image;
       // [self addSubview:self.ArtistName];
       // [self addSubview:self.dateAndTime];
        
        
        [self setupView];

            
            
        }
    return self;


}




-(void) setupView
{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = self.frame.size.width * CORNER_RATIO;
    self.layer.shadowRadius = 3;
    self.layer.shadowOpacity = 0;
    self.layer.shadowOffset = CGSizeMake(1, 1);
    [self setupPhotos];

}


-(void)setupPhotos
{
    
    //self.ArtistName.text = self.currentEvent.eventTitle;
    //self.Location.text = self.currentEvent.venueName;
    //self.dateAndTime.text = self.currentEvent.eventDate;
    //self.profilePic.image = self.currentEvent.coverpic.image;
    //self.coverPic.image = self.currentEvent.coverpic.image;
}


@end
