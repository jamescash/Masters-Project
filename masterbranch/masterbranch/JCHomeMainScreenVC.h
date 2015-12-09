//
//  JCHomeMainScreenVC.h
//  masterbranch
//
//  Created by james cash on 20/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//



/////////Class summery
/**
1. HomeScreen ViewController, Has one cellection view responsible for displaying gigs around users current location
2. Gets data from bandsintown/enchnest
3. Instactating asyn image donloading/Url searching/filtering for all eventObjects artist Images
4. Displays searchPage and Gig more info page
 */

#import <UIKit/UIKit.h>
//This is the superclass viewcontroler for any views that are part of the slideout side menu
#import "JCImageDownLoader.h"//operation Q for downloadning images
#import "JCPhotoFiltering.h"//operation Q for filtering the images
#import "JCURLRetriever.h"//operation Q for serching and finding an image URL for artist
#import "JCSearchPage.h"// Search VC
#import "AppDelegate.h"//To access the Allevents Array
#import "JCGigMoreInfoVC.h"// Gig more info VC
#import "GAITrackedViewController.h"//Goole tracking

#import "JCSocailStreamController.h"
#import "JCHappeningTonightVC.h"





@protocol MainScreenCollectionViewDelegate;


@interface JCHomeMainScreenVC : GAITrackedViewController  <UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,ImageDownloaderDelegate,ImageFiltrationDelegate,JCURLRetrieverDelegate,JCSocailStreamControllerDelegate,JCGigMoreInfoVC,CLLocationManagerDelegate>
@property (strong, nonatomic) id<MainScreenCollectionViewDelegate>MainScreenCollectionViewDelegate;
@end


@protocol MainScreenCollectionViewDelegate <NSObject>
-(void)userDidSelectAnnotation:(eventObject*) currentevent;
-(void)userDidSelectSearchIcon;
@end
