//
//  JCSearchResultsHeaderView.h
//  PreAmp
//
//  Created by james cash on 02/12/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface JCSearchResultsHeaderView : UIView
+ (instancetype)instantiateFromNib;
@property (weak, nonatomic) IBOutlet PFImageView *HeaderImageView;
@property (weak, nonatomic) IBOutlet UILabel *ArtistName;
@property (weak, nonatomic) IBOutlet UIImageView *UIImageViewFollwIcon;
@property (weak, nonatomic) IBOutlet UILabel *UILableFollowLable;
@end
