//
//  JCHomeMainScreenVC.m
//  masterbranch
//
//  Created by james cash on 20/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "JCHomeMainScreenVC.h"
//top buttons in the nav bar
#import "MMDrawerBarButtonItem.h"
//framework for moving leftside viewcontroler
#import "UIViewController+MMDrawerController.h"
//So I can call a segue to this VC
#import "JCSocailStreamController.h"
//#import "MMDrawerController.h"
#import <QuartzCore/QuartzCore.h>
//Customised Cell class for collection view
#import "JCCustomCollectionCell.h"
//Imports for asyn download and filtration of homescreen Images
#import "JCPhotoDownLoadRecord.h"
#import "JCPendingOperations.h"


//AF netwroking
#import "AFNetworking/AFNetworking.h"

//#define kDatasourceURLString @"https://sites.google.com/site/soheilsstudio/tutorials/nsoperationsampleproject/ClassicPhotosDictionary.plist"

@interface JCHomeMainScreenVC ()
@property (nonatomic,strong) JCEventBuilder *eventbuilder;
@property (nonatomic,strong) NSDictionary *allEevent;
@property (nonatomic,strong) NSArray *KeysOfAllEventsDictionary;
@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;
//Keep track of all the image downloads for homescreen
@property (nonatomic, strong) JCPendingOperations *pendingOperations;

//@property (nonatomic, strong) JCPhotoDownLoadRecord *aRecord;



@end

@implementation JCHomeMainScreenVC

#pragma LazyInitations

- (JCPendingOperations *)pendingOperations {
    if (!_pendingOperations) {
        _pendingOperations = [[JCPendingOperations alloc] init];
    }
    return _pendingOperations;
}


#pragma ViewLoadingPoints
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.eventbuilder) {
        
        self.KeysOfAllEventsDictionary = [[NSArray alloc]init];
        self.allEevent = [[NSDictionary alloc]init];
        
        
        //go to bandsintown and build a single array of parsed events
        //this is the entry point to a facade API i designed to deal with the event getting and building
        _eventbuilder  = [JCEventBuilder sharedInstance];
        _eventbuilder.delegate = self;
    }

    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//delegate method thats called when all the events are laoded and parsed into the main array
-(void)LoadMapView{
    
    NSLog(@"Delgation method in homescreen VC should only be called once");
    self.allEevent = [self.eventbuilder getEvent];
    self.KeysOfAllEventsDictionary = [self.allEevent allKeys];
    //make sure the realod is done on the main thred becuse it is a UI change
     dispatch_async(dispatch_get_main_queue(), ^{
         
         [self.collectionView reloadData];
        
   });
    
}


#pragma mark - UICollectionView Datasource


- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    
        NSString *searchTerm = self.KeysOfAllEventsDictionary[section];
    
        return [self.allEevent[searchTerm] count];

}


- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    
     return [self.KeysOfAllEventsDictionary count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   
    JCCustomCollectionCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"EventImageCell" forIndexPath:indexPath];
   
    if (!cell) {
        cell = [[JCCustomCollectionCell alloc] init];
    }
    
    NSString *key = [self.KeysOfAllEventsDictionary objectAtIndex:indexPath.section];

   
    eventObject *event = [self.allEevent[key] objectAtIndex:indexPath.row];
    
   // if ([event isKindOfClass:[eventObject class]]) {
       
        
        JCPhotoDownLoadRecord *aRecord = event.photoDownload;

   // }else {
   //     return cell;
   // }
    
  
    //JCPhotoDownLoadRecord *aRecord = self.aRecord;
    // 3
    
    
    
    if (aRecord.hasImage) {
        
      //  [((UIActivityIndicatorView *)cell.accessoryView) stopAnimating];
        cell.MainImageView.image = aRecord.image;
        //cell.textLabel.text = aRecord.name;
        
    }
    // 4
    else if (aRecord.isFailed) {
      //  [((UIActivityIndicatorView *)cell.accessoryView) stopAnimating];
        cell.MainImageView.image = [UIImage imageNamed:@"Failed.png"];
       // cell.textLabel.text = @"Failed to load";
        
    }
    // 5
    else {
        
       // [((UIActivityIndicatorView *)cell.accessoryView) startAnimating];
        cell.MainImageView.image = [UIImage imageNamed:@"Placeholder.png"];
        // cell.textLabel.text = @"";
        //if (!cv.dragging && !cv.decelerating) {
           
            [self startOperationsForPhotoRecord:aRecord atIndexPath:indexPath];

        //}
        
    }
    return cell;

}

/*- (UICollectionReusableView *)collectionView:
 (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
 {
 return [[UICollectionReusableView alloc] init];
 }*/



#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Select Item
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}


#pragma mark – UICollectionViewDelegateFlowLayout

// 1
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    //NSString *searchTerm = self.KeysOfAllEventsDictionary[indexPath.section];
    
    //eventObject *event = self.allEevent[searchTerm][indexPath.row];
    
    // CGSize retval = photo.thumbnail.size.width > 0 ? photo.thumbnail.size : CGSizeMake(100, 100);
   
    CGFloat cellLeg = (self.collectionView.frame.size.width/2) - 5;
    return CGSizeMake(cellLeg,cellLeg);
}

// 3
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma Aysnc Downlaod Operations











- (void)startOperationsForPhotoRecord:(JCPhotoDownLoadRecord *)record atIndexPath:(NSIndexPath *)indexPath {
    
    // 2
   
    if (!record.hasURL) {
        [self startURLDownloading:record atIndexPath:indexPath];
    }
    
    
    
    if (!record.hasImage) {
        
        [self startImageDownloadingForRecord:record atIndexPath:indexPath];
        
    }
    
    if (!record.isFiltered) {
        [self startImageFiltrationForRecord:record atIndexPath:indexPath];
    }
}


- (void)startURLDownloading:(JCPhotoDownLoadRecord *)record atIndexPath:(NSIndexPath *)indexPath {
    // 1
    if (![self.pendingOperations.URLRetrieversInProgress.allKeys containsObject:indexPath]) {
        
        
        JCURLRetriever *URLGetter = [[JCURLRetriever alloc] initWithPhotoRecord:record atIndexPath:indexPath delegate:self];
        [self.pendingOperations.URLRetrieversInProgress setObject:URLGetter forKey:indexPath];
        [self.pendingOperations.URLRetriever addOperation:URLGetter];
    }
}


- (void)startImageDownloadingForRecord:(JCPhotoDownLoadRecord *)record atIndexPath:(NSIndexPath *)indexPath {
    // 1
    if (![self.pendingOperations.downloadsInProgress.allKeys containsObject:indexPath]) {
        
        // 2
        // Start downloading
        JCImageDownLoader *imageDownloader = [[JCImageDownLoader alloc] initWithPhotoRecord:record atIndexPath:indexPath delegate:self];
        
        JCURLRetriever *dependency = [self.pendingOperations.URLRetrieversInProgress objectForKey:indexPath];
        if (dependency)
            [imageDownloader addDependency:dependency];
        
        
        [self.pendingOperations.downloadsInProgress setObject:imageDownloader forKey:indexPath];
        [self.pendingOperations.downloadQueue addOperation:imageDownloader];
    }
}


- (void)startImageFiltrationForRecord:(JCPhotoDownLoadRecord *)record atIndexPath:(NSIndexPath *)indexPath {
    // 3
    if (![self.pendingOperations.filtrationsInProgress.allKeys containsObject:indexPath]) {
        
        // 4
        // Start filtration
        JCPhotoFiltering *imageFiltration = [[JCPhotoFiltering alloc] initWithPhotoRecord:record atIndexPath:indexPath delegate:self];
        
        // 5
        JCImageDownLoader *dependency = [self.pendingOperations.downloadsInProgress objectForKey:indexPath];
        if (dependency)
            [imageFiltration addDependency:dependency];
        
        [self.pendingOperations.filtrationsInProgress setObject:imageFiltration forKey:indexPath];
        [self.pendingOperations.filtrationQueue addOperation:imageFiltration];
    }
}

//
#pragma mark - ImageDownloader delegate


-(void)JCURLRetrieverDidFinish:(JCURLRetriever *)downloader{
    
    
    
    NSIndexPath *indexPath = downloader.indexPathInTableView;
    
    JCPhotoDownLoadRecord *theRecord = downloader.photoRecord;
    
    NSString *key = [self.KeysOfAllEventsDictionary objectAtIndex:indexPath.section];
    
    eventObject *event = [self.allEevent[key] objectAtIndex:indexPath.row];
    
    event.photoDownload = theRecord;

    [self.allEevent[key] replaceObjectAtIndex:indexPath.row withObject:event];
    
    [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]];
    
    [self.pendingOperations.URLRetrieversInProgress removeObjectForKey:indexPath];
    
}

- (void)imageDownloaderDidFinish:(JCImageDownLoader *)downloader {
    
    NSLog(@"Image downlaoded");
    
    
    
    // 1: Check for the indexPath of the operation, whether it is a download, or filtration.
    
    NSIndexPath *indexPath = downloader.indexPathInTableView;
    
    // 2: Get hold of the PhotoRecord instance.
    JCPhotoDownLoadRecord *theRecord = downloader.photoRecord;
    
    // 3: Replace the updated PhotoRecord in the main data source (Photos array).
   
    //int index = indexPath;
    
    NSString *key = [self.KeysOfAllEventsDictionary objectAtIndex:indexPath.section];
  
    eventObject *event = [self.allEevent[key] objectAtIndex:indexPath.row];
    
    event.photoDownload = theRecord;
    
    [self.allEevent[key] replaceObjectAtIndex:indexPath.row withObject:event];
   
    
    // 4: Update UI.
    
    [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]];
    // 5: Remove the operation from downloadsInProgress (or filtrationsInProgress).
    
    [self.pendingOperations.downloadsInProgress removeObjectForKey:indexPath];
}


#pragma mark - ImageFiltration delegate


- (void)imageFiltrationDidFinish:(JCPhotoFiltering *)filtration {
    NSIndexPath *indexPath = filtration.indexPathInTableView;
   
    JCPhotoDownLoadRecord *theRecord = filtration.photoRecord;
    
    NSString *key = [self.KeysOfAllEventsDictionary objectAtIndex:indexPath.section];
    
    eventObject *event = [self.allEevent[key] objectAtIndex:indexPath.row];
    
    event.photoDownload = theRecord;
    
    [self.allEevent[key] replaceObjectAtIndex:indexPath.row withObject:event];
    [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]];
    [self.pendingOperations.filtrationsInProgress removeObjectForKey:indexPath];
}


//#pragma mark - UIScrollView delegate
//
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    // 1
//    [self suspendAllOperations];
//}
//
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    // 2
//    if (!decelerate) {
//        [self loadImagesForOnscreenCells];
//        [self resumeAllOperations];
//    }
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    // 3
//    [self loadImagesForOnscreenCells];
//    [self resumeAllOperations];
//}
//
//#pragma mark - Cancelling, suspending, resuming queues / operations
//
//- (void)suspendAllOperations {
//    [self.pendingOperations.downloadQueue setSuspended:YES];
//    [self.pendingOperations.filtrationQueue setSuspended:YES];
//}
//
//- (void)resumeAllOperations {
//    [self.pendingOperations.downloadQueue setSuspended:NO];
//    [self.pendingOperations.filtrationQueue setSuspended:NO];
//}
//
//- (void)cancelAllOperations {
//    [self.pendingOperations.downloadQueue cancelAllOperations];
//    [self.pendingOperations.filtrationQueue cancelAllOperations];
//}
//
//- (void)loadImagesForOnscreenCells {
//    
//    // 1
//    NSSet *visibleRows = [NSSet setWithArray:[self.collectionView indexPathsForVisibleItems]];
//    
//    // 2
//    NSMutableSet *pendingOperations = [NSMutableSet setWithArray:[self.pendingOperations.downloadsInProgress allKeys]];
//    [pendingOperations addObjectsFromArray:[self.pendingOperations.filtrationsInProgress allKeys]];
//    
//    NSMutableSet *toBeCancelled = [pendingOperations mutableCopy];
//    NSMutableSet *toBeStarted = [visibleRows mutableCopy];
//    
//    // 3
//    [toBeStarted minusSet:pendingOperations];
//    // 4
//    [toBeCancelled minusSet:visibleRows];
//    
//    // 5
//    for (NSIndexPath *anIndexPath in toBeCancelled) {
//        
//        JCImageDownLoader *pendingDownload = [self.pendingOperations.downloadsInProgress objectForKey:anIndexPath];
//        [pendingDownload cancel];
//        [self.pendingOperations.downloadsInProgress removeObjectForKey:anIndexPath];
//        
//        JCPhotoFiltering *pendingFiltration = [self.pendingOperations.filtrationsInProgress objectForKey:anIndexPath];
//        [pendingFiltration cancel];
//        [self.pendingOperations.filtrationsInProgress removeObjectForKey:anIndexPath];
//    }
//    toBeCancelled = nil;
//    
//    // 6
//    for (NSIndexPath *anIndexPath in toBeStarted) {
//        
//        PhotoRecord *recordToProcess = [self.photos objectAtIndex:anIndexPath.row];
//        [self startOperationsForPhotoRecord:recordToProcess atIndexPath:anIndexPath];
//    }
//    toBeStarted = nil;
//    
//}
//



//-(void)setupLeftMenuButton{
//    
//    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
//    
//    
//    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
//    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(serchbuttonPressed:)];
//    
//}

//
//-(void)leftDrawerButtonPress:(id)sender{
//    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
//    
//}


//-(void)serchbuttonPressed:(id)sender {
//    
//    [self.MainScreenCollectionViewDelegate userDidSelectSearchIcon];
//    
//};

@end
