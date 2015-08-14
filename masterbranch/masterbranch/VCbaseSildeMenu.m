//
//  VCbaseSildeMenu.m
//  masterbranch
//
//  Created by james cash on 09/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "VCbaseSildeMenu.h"

@interface VCbaseSildeMenu ()

@end

@implementation VCbaseSildeMenu

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(contentSizeDidChangeNotification:)
     name:UIContentSizeCategoryDidChangeNotification
     object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]
     removeObserver:self];
}

-(void)contentSizeDidChangeNotification:(NSNotification*)notification{
    [self contentSizeDidChange:notification.userInfo[UIContentSizeCategoryNewValueKey]];
}

-(void)contentSizeDidChange:(NSString *)size{
    
    //Implement in subclass
}

@end
