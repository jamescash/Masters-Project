//
//  JCProfilePage.h
//  PreAmp
//
//  Created by james cash on 15/09/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface JCProfilePage : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) PFRelation *FriendRelations;

@end
