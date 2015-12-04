//
//  JCSearchPageResultsVCViewController.h
//  PreAmp
//
//  Created by james cash on 30/11/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCPendingOperations.h"
#import "JCPhotoDownLoadRecord.h"
#import "JCImageDownLoader.h"
#import "JCPhotoFiltering.h"
#import "JCURLRetriever.h"
#import "UIScrollView+EmptyDataSet.h"

@interface JCSearchPageResultsVCViewController : UIViewController <UISearchBarDelegate, UISearchDisplayDelegate,ImageDownloaderDelegate,ImageFiltrationDelegate,JCURLRetrieverDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource>

@end
