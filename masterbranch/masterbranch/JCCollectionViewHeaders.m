//
//  JCCollectionViewHeaders.m
//  masterbranch
//
//  Created by james cash on 22/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "JCCollectionViewHeaders.h"

@interface JCCollectionViewHeaders ()
@property(weak) IBOutlet UILabel *searchLabel;
@end

@implementation JCCollectionViewHeaders


-(void)setHeaderText:(NSString *)text {
   self.searchLabel.text = text;
   self.searchLabel.textColor = [UIColor colorWithRed:234.0f/255.0f green:65.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
   self.backgroundColor = [UIColor whiteColor];
   //self.layer.borderColor = [[UIColor colorWithRed:234.0f/255.0f green:65.0f/255.0f blue:150.0f/255.0f alpha:1.0f]CGColor] ;
   //self.layer.borderWidth = 1.0f;


}

@end
