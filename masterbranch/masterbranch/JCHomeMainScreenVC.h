//
//  JCHomeMainScreenVC.h
//  masterbranch
//
//  Created by james cash on 20/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import <UIKit/UIKit.h>
//API facade for building array for bandsintown event objects
#import "JCEventBuilder.h"
//This is the superclass viewcontroler for any views that are part of the slideout side menu
#import "VCbaseSildeMenu.h"


//operation Q for downloadning images
#import "JCImageDownLoader.h"

//operation Q for filtering the images
#import "JCPhotoFiltering.h"

#import "JCURLRetriever.h"

#import "JCSearchPage.h"

#import "JCSocailStreamController.h"

#import "JCHappeningTonightVC.h"




@protocol MainScreenCollectionViewDelegate;


@interface JCHomeMainScreenVC : VCbaseSildeMenu  <UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,JCEventBuildereDlegate,ImageDownloaderDelegate,ImageFiltrationDelegate,JCURLRetrieverDelegate,JCSearchPageDelegate,JCSocailStreamControllerDelegate,JCHappeningTonightVCDelegate>

@property (strong, nonatomic) id<MainScreenCollectionViewDelegate>MainScreenCollectionViewDelegate;


@end


@protocol MainScreenCollectionViewDelegate <NSObject>
-(void)userDidSelectAnnotation:(eventObject*) currentevent;
-(void)userDidSelectSearchIcon;
@end
