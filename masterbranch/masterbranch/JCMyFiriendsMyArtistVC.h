//
//  JCMyFiriendsMyArtistVC.h
//  PreAmp
//
//  Created by james cash on 20/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@interface JCMyFiriendsMyArtistVC : UIViewController
@property (nonatomic,strong) NSString *tableViewType;
@property (nonatomic,strong) PFObject *currentUserEvent;
@end
