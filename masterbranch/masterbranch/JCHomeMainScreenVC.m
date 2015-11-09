//
//  JCHomeMainScreenVC.m
//  masterbranch
//
//  Created by james cash on 20/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "JCHomeMainScreenVC.h"
//top buttons in the nav bar
//So I can call a segue to this VC
#import <QuartzCore/QuartzCore.h>
//Customised Cell class for collection view
#import "JCCustomCollectionCell.h"
//Imports for asyn download and filtration of homescreen Images
#import "JCPhotoDownLoadRecord.h"
#import "JCPendingOperations.h"
//class for colection view header
#import "JCCollectionViewHeaders.h"

//AF netwroking
#import "AFNetworking/AFNetworking.h"
//main app delaget
//parse backend to check if users logged in or not
#import <Parse/Parse.h>

//adding infanit scrolling
//#import "UIScrollView+SVPullToRefresh.h"
//#import "UIScrollView+SVInfiniteScrolling.h"

//data contrller for homescreen
#import "JCHomeScreenDataController.h"
#import "JCleftSlideOutVC.h"


#import <CCBottomRefreshControl/UIScrollView+BottomRefreshControl.h>

#import <TLYShyNavBar/TLYShyNavBarManager.h>

#import "JCCustomSearchPageSegue.h"

//backend

//#define kDatasourceURLString @"https://sites.google.com/site/soheilsstudio/tutorials/nsoperationsampleproject/ClassicPhotosDictionary.plist"

@interface JCHomeMainScreenVC ()
//collection view data model object
//@property (nonatomic,strong) NSDictionary *upComingGigsDataForCollectionView;
//@property (nonatomic,strong) NSArray *KeysOfAllEventsDictionary;
//UIELements
@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;
//Properties
@property(nonatomic,strong) NSDate *dateForAPICall;
@property(nonatomic,strong) NSString *usersLongditude;
@property(nonatomic,strong) NSString *userLatitude;
@property(nonatomic,strong) CLLocation *userLocation;
@property(nonatomic,strong) UIView *pullUpView;
//Keep track of all the image downloads for homescreen
@property (nonatomic, strong) JCPendingOperations *pendingOperations;
//classes
@property (nonatomic,strong) JCHomeScreenDataController *JCHomeScreenDataController;


//CollectionViewData
@property (nonatomic,strong) NSMutableArray *collectionViewDataObject;


@end

//TODO make this class a shared instance and just update the collection view data model objects to stop the BADACCESS Image downlaoder URL. 

@implementation JCHomeMainScreenVC{
    CLLocationManager *locationManager;

}

#pragma LazyInitations

- (JCPendingOperations *)pendingOperations {
    if (!_pendingOperations) {
        _pendingOperations = [[JCPendingOperations alloc] init];
    }
    return _pendingOperations;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if ((self = [super initWithCoder:aDecoder])){
        [self initialization];
    }
    return self;
}

-(void)initialization{
    self.collectionViewDataObject = [[NSMutableArray alloc]init];
    self.JCHomeScreenDataController = [[JCHomeScreenDataController alloc]init];
    self.dateForAPICall = [NSDate date];
    [self addCustomButtonOnNavBar];
}

#pragma ViewLoadingPoints
- (void)viewDidLoad {
    [super viewDidLoad];

    
   
    [self getlocationAndWaitforUpdateThenGetDataForCollectionView];
    
    //show login screen if users not logged in
    
    if (![PFUser currentUser]) {
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
    
    
}

- (void)refresh {
    [self getDataForCollectionView];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self cancelAllOperations];
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self.collectionViewDataObject[section] count];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return [self.collectionViewDataObject count];
    //return [self.KeysOfAllEventsDictionary count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   
    JCCustomCollectionCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"EventImageCell" forIndexPath:indexPath];
   
    if (!cell) {
        cell = [[JCCustomCollectionCell alloc] init];
    }
    
    //NSString *key = [self.KeysOfAllEventsDictionary objectAtIndex:indexPath.section];
    eventObject *event = [self.collectionViewDataObject[indexPath.section] objectAtIndex:indexPath.row];
    
    //acesss the photo download object of that current event
    
    JCPhotoDownLoadRecord *aRecord = event.photoDownload;

    //check if it has an image 
    if (aRecord.hasImage) {
        
        //TODO mke cells tight to the right side
        
        [cell setImage:aRecord.image andArtistNamr:event.eventTitle andVenueName:event.venueName];
     }
    // 4
    else if (aRecord.isFailed) {
        //[((UIActivityIndicatorView *)cell.accessoryView) stopAnimating];
        cell.MainImageView.image = [UIImage imageNamed:@"loadingGray.png"];
        cell.CellTitle.text = @"Failed";
    }
    // 5
    else {

        cell.MainImageView.image = [UIImage imageNamed:@"loadingGray.png"];
        cell.CellTitle.text = @"";
        cell.venue.text = @"";
        
        if (!cv.dragging && !cv.decelerating) {
           [self startOperationsForPhotoRecord:aRecord atIndexPath:indexPath];
         }
        
    }
    return cell;

}

#pragma mark - UICollectionViewDelegate

- (UICollectionReusableView *)collectionView: (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
   
    JCCollectionViewHeaders *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
                                         UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionViewHeader" forIndexPath:indexPath];
    
    //TODO Make a date formatter class for here and in Music Diary
    //TODO Setting the header by getting the date from the first item but what if there is no first item?
    
    eventObject *firstEventInsection = self.collectionViewDataObject[indexPath.section][indexPath.row];
    [headerView formateHeaderwithEventObject:firstEventInsection];

    
    return headerView;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self PerformNavigationForItemAtIndex:indexPath];
}

#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
   
    CGFloat cellLeg =  ((self.collectionView.frame.size.width/2)-1);
    return CGSizeMake(cellLeg,cellLeg);
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)sectio{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


#pragma Aysnc Downlaod Operations

-(void)startOperationsForPhotoRecord:(JCPhotoDownLoadRecord *)record atIndexPath:(NSIndexPath *)indexPath {
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

-(void)startURLDownloading:(JCPhotoDownLoadRecord *)record atIndexPath:(NSIndexPath *)indexPath {

    if (![self.pendingOperations.URLRetrieversInProgress.allKeys containsObject:indexPath]) {
        
        JCURLRetriever *URLGetter = [[JCURLRetriever alloc] initWithPhotoRecord:record atIndexPath:indexPath delegate:self];
        [self.pendingOperations.URLRetrieversInProgress setObject:URLGetter forKey:indexPath];
        [self.pendingOperations.URLRetriever addOperation:URLGetter];
    }
}

-(void)startImageDownloadingForRecord:(JCPhotoDownLoadRecord *)record atIndexPath:(NSIndexPath *)indexPath {

    if (![self.pendingOperations.downloadsInProgress.allKeys containsObject:indexPath]) {
        
        // Start downloading
        JCImageDownLoader *imageDownloader = [[JCImageDownLoader alloc] initWithPhotoRecord:record atIndexPath:indexPath delegate:self];
        
        JCURLRetriever *dependency = [self.pendingOperations.URLRetrieversInProgress objectForKey:indexPath];
        if (dependency)
            [imageDownloader addDependency:dependency];
        
        
        [self.pendingOperations.downloadsInProgress setObject:imageDownloader forKey:indexPath];
        [self.pendingOperations.downloadQueue addOperation:imageDownloader];
    }
}

-(void)startImageFiltrationForRecord:(JCPhotoDownLoadRecord *)record atIndexPath:(NSIndexPath *)indexPath {
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

#pragma mark - Downloader delegate

-(void)JCURLRetrieverDidFinish:(JCURLRetriever *)downloader{
    
    NSIndexPath *indexPath = downloader.indexPathInTableView;
    
    JCPhotoDownLoadRecord *theRecord = downloader.photoRecord;
    
    //NSString *key = [self.KeysOfAllEventsDictionary objectAtIndex:indexPath.section];
    
    eventObject *event = [self.collectionViewDataObject[indexPath.section] objectAtIndex:indexPath.row];
    
    event.photoDownload = theRecord;

    [self.collectionViewDataObject[indexPath.section] replaceObjectAtIndex:indexPath.row withObject:event];
    
    //TODO what is causing the crahs here? !!!!!!!!!
    [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]];
    
    [self.pendingOperations.URLRetrieversInProgress removeObjectForKey:indexPath];
    
}

-(void)imageDownloaderDidFinish:(JCImageDownLoader *)downloader {
    
    
    // 1: Check for the indexPath of the operation, whether it is a download, or filtration.
    NSIndexPath *indexPath = downloader.indexPathInTableView;
    
    // 2: Get hold of the PhotoRecord instance.
    JCPhotoDownLoadRecord *theRecord = downloader.photoRecord;
    
    eventObject *event = [self.collectionViewDataObject[indexPath.section] objectAtIndex:indexPath.row];
    
    event.photoDownload = theRecord;
    
    [self.collectionViewDataObject[indexPath.section] replaceObjectAtIndex:indexPath.row withObject:event];
   
    //becuse im adding sections so the index path is diffrent then when added?
        [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]];

    // 5: Remove the operation from downloadsInProgress (or filtrationsInProgress).
    [self.pendingOperations.downloadsInProgress removeObjectForKey:indexPath];
}

-(void)imageFiltrationDidFinish:(JCPhotoFiltering *)filtration {
    
    NSIndexPath *indexPath = filtration.indexPathInTableView;
   
    JCPhotoDownLoadRecord *theRecord = filtration.photoRecord;
    
    eventObject *event = [self.collectionViewDataObject[indexPath.section] objectAtIndex:indexPath.row];
    
    event.photoDownload = theRecord;
    
    [self.collectionViewDataObject[indexPath.section] replaceObjectAtIndex:indexPath.row withObject:event];
    
    [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]];
        

    [self.pendingOperations.filtrationsInProgress removeObjectForKey:indexPath];
}

//http://www.raywenderlich.com/19788/how-to-use-nsoperations-and-nsoperationqueues
#pragma mark - UIScrollView delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // 1
    [self suspendAllOperations];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    // 2
    if (!decelerate) {
        [self loadImagesForOnscreenCells];
        [self resumeAllOperations];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    float endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
//    NSLog(@"scroll content offset y %f",scrollView.contentOffset.y);
//    NSLog(@"scroll height %f",scrollView.frame.size.height);
//    NSLog(@"scroll content size %f",scrollView.contentSize.height);
//    NSLog(@"endscrolling %f",endScrolling);
    
    if (endScrolling >= scrollView.contentSize.height)
    {
        //TODO add animation to pull to refresh
        //TODO add defensive code to stop the collection view from going into a loop call BIT API
        [self getDataForCollectionView];
    }
    
    [self loadImagesForOnscreenCells];
    [self resumeAllOperations];
}

#pragma mark - Cancelling, suspending, resuming queues / operations

- (void)suspendAllOperations {
    [self.pendingOperations.downloadQueue setSuspended:YES];
    [self.pendingOperations.filtrationQueue setSuspended:YES];
}

- (void)resumeAllOperations {
    [self.pendingOperations.downloadQueue setSuspended:NO];
    [self.pendingOperations.filtrationQueue setSuspended:NO];
}

- (void)cancelAllOperations {
    [self.pendingOperations.downloadQueue cancelAllOperations];
    [self.pendingOperations.filtrationQueue cancelAllOperations];
}

- (void)loadImagesForOnscreenCells {
    
    // 1
    NSSet *visibleRows = [NSSet setWithArray:[self.collectionView indexPathsForVisibleItems]];
    
    // 2
    NSMutableSet *pendingOperations = [NSMutableSet setWithArray:[self.pendingOperations.downloadsInProgress allKeys]];
    [pendingOperations addObjectsFromArray:[self.pendingOperations.filtrationsInProgress allKeys]];
    
    NSMutableSet *toBeCancelled = [pendingOperations mutableCopy];
    NSMutableSet *toBeStarted = [visibleRows mutableCopy];
    
    // 3
    [toBeStarted minusSet:pendingOperations];
    // 4
    [toBeCancelled minusSet:visibleRows];
    
    // 5
    for (NSIndexPath *anIndexPath in toBeCancelled) {
        
        JCImageDownLoader *pendingDownload = [self.pendingOperations.downloadsInProgress objectForKey:anIndexPath];
        [pendingDownload cancel];
        [self.pendingOperations.downloadsInProgress removeObjectForKey:anIndexPath];
        
        JCPhotoFiltering *pendingFiltration = [self.pendingOperations.filtrationsInProgress objectForKey:anIndexPath];
        [pendingFiltration cancel];
        [self.pendingOperations.filtrationsInProgress removeObjectForKey:anIndexPath];
    }
    toBeCancelled = nil;
    
    // 6
    for (NSIndexPath *anIndexPath in toBeStarted) {
        
       eventObject *event = [self.collectionViewDataObject[anIndexPath.section] objectAtIndex:anIndexPath.row];
        
        
        JCPhotoDownLoadRecord *recordToProcess = event.photoDownload;
        [self startOperationsForPhotoRecord:recordToProcess atIndexPath:anIndexPath];
    }
    toBeStarted = nil;
    
}

#pragma Navigation

- (IBAction)unwindHomeScreenCollectionView:(UIStoryboardSegue *)unwindSegue
{
    
}

-(void)PerformNavigationForItemAtIndex: (NSIndexPath*)index{
    
    
    //NSString *key = [self.collectionViewDataObject objectAtIndex:index.section];
    eventObject *currentEvent = [self.collectionViewDataObject[index.section] objectAtIndex:index.row];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

  
    //if ([currentEvent.status isEqualToString:@"alreadyHappened"]||[currentEvent.status isEqualToString:@"currentlyhappening"]) {
        
        //TODO uncomment this so social stream shows up again
        
//         UINavigationController *myVC = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"AlreadyHappenedSocialStreamNav"];
//        
//        JCSocailStreamController *jc = [myVC viewControllers][0];
//        jc.JCSocailStreamControllerDelegate = self;
//        jc.currentevent = currentEvent;
//        [self presentViewController:myVC animated:YES completion:nil];
        
        UINavigationController *myVC = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"JCGigMoreInfoNav"];
        JCGigMoreInfoVC *DVC = [myVC viewControllers][0];
        DVC.JCGigMoreInfoVCDelegate = self;
        DVC.currentEvent = currentEvent;
        [self presentViewController:myVC animated:YES completion:nil];
        
//}
//    if ([currentEvent.status isEqualToString:@"happeningLater"]) {
//        
//        UINavigationController *myVC = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"HappeningLater"];
//        JCHappeningTonightVC *DVC = [myVC viewControllers][0];
//        DVC.JCHappeningTonightVCDelegate = self;
//        DVC.currentEvent = currentEvent;
//        [self presentViewController:myVC animated:YES completion:nil];
//    }
    
    
    
    
}

-(void)serchbuttonPressed:(id)sender {
    
 [self performSegueWithIdentifier:@"showSearchPage" sender:self];
  
}

-(void)JCSearchPageDidSelectDone:(JCSearchPage *)controller{
    
    [self dismissViewControllerAnimated:YES completion:nil];
};

-(void)SocialStreamViewControllerDidSelectDone:(JCSocailStreamController *)controller{
    
    [self dismissViewControllerAnimated:YES completion:nil];

    
}

-(void)menuButtonPressed{
    //[self.navigationController setNavigationBarHidden: YES animated:YES];
    [self.sideMenuViewController presentLeftMenuViewController];
    
}

-(void)JCGigMoreInfoVCDidSelectDone:(JCGigMoreInfoVC *)controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}





#pragma  - Helper Methods

-(void)getDataForCollectionView{


    
    NSDate  *dateForAPICall = [[NSDate alloc]init];
    dateForAPICall = self.dateForAPICall;
    //add one day onto the date for the next api call
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = 1;
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    self.dateForAPICall = [theCalendar dateByAddingComponents:dayComponent toDate:self.dateForAPICall options:0];
    
    NSLog(@"Going to bandsintown to get data for %@",self.dateForAPICall);
    
   
    if (!self.userLocation) {
        NSLog(@"location acess denied getting gigs from dublin");
    }
    
    
    
    [self.JCHomeScreenDataController getEventsforDate:dateForAPICall usingLocation:self.userLatitude Longditude:self.usersLongditude competionBlock:^(NSError *error, NSArray *response) {
        
        
        if ([response count]!=0) {
            
            
           
            //NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:[self.collectionViewDataObject count]];

            //[self.collectionViewDataObject insertObjects:response atIndexes:indexSet];
            
            
            //[self.collectionViewDataObject ad]
            
            //[self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionViewDataObject addObject:response];
                [self.collectionView reloadData];
                //NSIndexSet *indexSet = [[NSIndexSet alloc]initWithIndex:[self.collectionViewDataObject count]];
                //[self.collectionView reloadSections:indexSet];
                        if ([response count]<=7) {
                           
                            [self performSelector:@selector(getDataForCollectionView) withObject:self afterDelay:1.0 ];
                            
                            //[self getDataForCollectionView];
                        
                        }
                
            });
            
        }
        

       
    }];
    
}

-(void)getlocationAndWaitforUpdateThenGetDataForCollectionView{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
}

- (void)addCustomButtonOnNavBar
{
    
    
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage im];
    //imageView.alpha = 0.5; //Alpha runs from 0.0 to 1.0
    
    [menuButton setImage:[UIImage imageNamed:@"iconMenu.png"] forState:UIControlStateNormal];
    //[menuButton setImage:[UIImage imageNamed:@"iconMenu.png"] forState:UIControlStateHighlighted];
     menuButton.adjustsImageWhenDisabled = NO;
    //set the frame of the button to the size of the image (see note below)
    menuButton.frame = CGRectMake(0, 0, 40, 40);
    menuButton.opaque = YES;

    [menuButton addTarget:self action:@selector(menuButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    //create a UIBarButtonItem with the button as a custom view
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    
    self.navigationItem.leftBarButtonItem = customBarItem;
    
    
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton setImage:[UIImage imageNamed:@"iconSearch.png"] forState:UIControlStateNormal];
    //[searchButton setImage:[UIImage imageNamed:@"iconSearch.png"] forState:UIControlStateHighlighted];
    searchButton.adjustsImageWhenDisabled = NO;
    searchButton.frame = CGRectMake(0, self.collectionView.frame.size.width-40 , 40, 40);

    [searchButton addTarget:self action:@selector(serchbuttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *searchbarbutton = [[UIBarButtonItem alloc] initWithCustomView:searchButton];

    
    self.navigationItem.rightBarButtonItem = searchbarbutton;
    
    
    self.navigationItem.hidesBackButton = YES;
    
    //self.navigationItem.leftBarButtonItem =item1;
    
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //if denied acess we set default values to the center of ireland 
    self.userLatitude = @"53.3478";
    self.usersLongditude = @"-6.2597";
    [self getDataForCollectionView];
    NSLog(@"location set to dublin");
    //[self getDataForCollectionView];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //save user location once
    if (!self.userLocation) {
        self.userLocation = [[CLLocation alloc]init];
        self.userLocation = newLocation;
        self.usersLongditude = [NSString stringWithFormat:@"%.8f", self.userLocation.coordinate.longitude];
        self.userLatitude = [NSString stringWithFormat:@"%.8f", self.userLocation.coordinate.latitude];
        [self getDataForCollectionView];


    }
    //run location was updates
    if (self.userLocation != nil) {
        [self locationWasUpdated:newLocation];
    }
}

-(void)locationWasUpdated:(CLLocation*)newLocation{
    
    //TODO store user location in NSUserDefaults and only refresh homepage if location is chaged by 3/4k
    CLLocationDistance distance = [self.userLocation distanceFromLocation:newLocation];

    if (distance > 50000) {
        NSLog(@"location updated");
        self.usersLongditude = [NSString stringWithFormat:@"%.8f", newLocation.coordinate.longitude];
        self.userLatitude = [NSString stringWithFormat:@"%.8f", newLocation.coordinate.latitude];
    }
    
}




@end
