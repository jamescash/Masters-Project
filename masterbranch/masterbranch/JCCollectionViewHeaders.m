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
   self.backgroundColor = [UIColor lightGrayColor];
}

@end
