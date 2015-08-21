//
//  JChomeScreenVC.h
//  masterbranch
//
//  Created by james cash on 09/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigtionViewController.h"
#import "MMDrawerController.h"
#import "MapView.h"
#import "JCSearchPage.h"

// ViewController For center screnn in homeview 
#import "JCHomeMainScreenVC.h"


//social stream for already happened and happening later
#import "JCSocailStreamController.h"






@interface JChomeScreenVC : UIViewController <JCSearchPageDelegate, MainScreenCollectionViewDelegate,JCSocailStreamControllerDelegate>



@end
