//
//  JCleftSlideOutVC.h
//  masterbranch
//
//  Created by james cash on 17/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import <Parse/Parse.h>


//Hamberger Menu - https://github.com/romaonthego/RESideMenu
//Git hub project modifyed to suite our needs 

@protocol JCleftSlideOutVCDelegat;

@interface JCleftSlideOutVC : UIViewController<UITableViewDataSource, UITableViewDelegate, RESideMenuDelegate>
@property (strong,nonatomic) id <JCleftSlideOutVCDelegat>JCleftSlideOutVCDelegat;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;

@property (weak, nonatomic) IBOutlet UILabel *numberOfArtistFollowing;

@property (weak, nonatomic) IBOutlet UILabel *numberOfFriends;


@property (weak, nonatomic) IBOutlet UILabel *userName;



@end

@protocol JCleftSlideOutVCDelegat <NSObject>
-(void)UserSelectedLogOut;
@end