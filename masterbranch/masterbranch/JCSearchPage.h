//
//  JCSearchPage.h
//  masterbranch
//
//  Created by james cash on 15/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JCSearchPageDelegate;
@class JCSearchPageDelegate;



@interface JCSearchPage : UITableViewController<UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic,weak) id <JCSearchPageDelegate>JCSearchPageDelegate;
@property (weak, nonatomic) IBOutlet UISearchBar *SearchBar;
- (IBAction)UserSelectedDone:(id)sender;

@end



@protocol JCSearchPageDelegate <NSObject>
-(void)JCSearchPageDidSelectDone:(JCSearchPage*)controller;
@end


