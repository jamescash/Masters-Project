//
//  JCHomeMainScreenVC.m
//  masterbranch
//
//  Created by james cash on 20/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "JCHomeMainScreenVC.h"
#import <QuartzCore/QuartzCore.h>
#import "JCCustomCollectionCell.h"//Customised Cell class for collection view
#import "JCPhotoDownLoadRecord.h"//photo download object
#import "JCPendingOperations.h"//NSoperation Q, deals with URL retreving, and image downloading
#import "JCCollectionViewHeaders.h"//home screen headers
#import "AFNetworking/AFNetworking.h"
#import <Parse/Parse.h>//backend
#import "JCHomeScreenDataController.h"//class build to deal with BandsintownAPI/Echo Nest API.
#import "JCleftSlideOutVC.h"
#import <TLYShyNavBar/TLYShyNavBarManager.h>//https://github.com/telly/TLYShyNavBar// //Hiding the nav bar on scroll
#import "DGActivityIndicatorView.h"//https://github.com/gontovnik/DGActivityIndicatorView //image loading anaimtions
#import <Google/Analytics.h>


#import <CCBottomRefreshControl/UIScrollView+BottomRefreshControl.h>

//backend

//#define kDatasourceURLString @"https://sites.google.com/site/soheilsstudio/tutorials/nsoperationsampleproject/ClassicPhotosDictionary.plist"

@interface JCHomeMainScreenVC ()
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


@implementation JCHomeMainScreenVC{
    //store users loation
    CLLocationManager *locationManager;
}

#pragma LazyInitations
//home screen image asyn downloading
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

    //google analitics
    self.screenName = @"Home Screen";
   
    //see method for details - gets user loaction and gets data from BandsIntown
    [self getlocationAndWaitforUpdateThenGetDataForCollectionView];
    
    //show login screen if users not logged in
    if (![PFUser currentUser]) {
        NSLog(@"current user %@",[[PFUser currentUser]username]);
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
    
    
}

- (void)refresh {
    //gets data from BandsIntown
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
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   
    JCCustomCollectionCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"EventImageCell" forIndexPath:indexPath];
   
    if (!cell) {
        cell = [[JCCustomCollectionCell alloc] init];
    }
    
    eventObject *event = [self.collectionViewDataObject[indexPath.section] objectAtIndex:indexPath.row];
    
    //acesss the photo download object of that current event
    JCPhotoDownLoadRecord *aRecord = event.photoDownload;
    
    

    //check if it has an image
    if (aRecord.hasImage) {
        [cell stopLoadingAnimation];
        [cell setImage:aRecord.image andArtistNamr:event.eventTitle andVenueName:event.venueName];
        [cell addVinettLayer];
     }
    else if (aRecord.isFailed) {
        [cell stopLoadingAnimation];
        [cell addVinettLayer];
        [cell setImage:nil andArtistNamr:event.eventTitle andVenueName:event.venueName];
        cell.MainImageView.image = [UIImage imageNamed:@"iconFailed"];

    }
    else {
        //if it has no image and is not failed then set it to loading state as the image is being downloed
        [cell startLoadingAnimation];
        cell.MainImageView.image = [UIImage imageNamed:@"loadingGreyPlane"];
        [cell removeVinettLayer];
        cell.CellTitle.text = @"";
        cell.venue.text = @"";
        
        //only load the image into the cell it the collection view is static on the screne
        //and not when the users draging
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
    eventObject *firstEventInsection = self.collectionViewDataObject[indexPath.section][indexPath.row];
    //use an event object from that section the format the header view.. date/daystring ect..
    [headerView formateHeaderwithEventObject:firstEventInsection];
    return headerView;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
    //take the index so we know what to show the user in the detailed view
    [self PerformNavigationForItemAtIndex:indexPath];
    //Track Button clicks
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"       // Event category (required)
                                                          action:@"button_press"    // Event action (required)
                                                           label:@"Gig_HomeScreen" // Event label
                                                           value:nil] build]];      // Event value
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
//This aysnc image retriver system was build on the bases of a tutorial I did found @http://www.raywenderlich.com/76341/use-nsoperation-nsoperationqueue-swift

///1 search the web with the artist name and find a url to an image
///2 once we have the URL start the image downloading of that image
///3 once that image is downlaoded we and filter it
///4 display the image in the cell

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
  //if the user isint already being retrived then start getting it
  //add it the the pedingoperations
    
    if (![self.pendingOperations.URLRetrieversInProgress.allKeys containsObject:indexPath]) {
        
        JCURLRetriever *URLGetter = [[JCURLRetriever alloc] initWithPhotoRecord:record atIndexPath:indexPath delegate:self];
        [self.pendingOperations.URLRetrieversInProgress setObject:URLGetter forKey:indexPath];
        [self.pendingOperations.URLRetriever addOperation:URLGetter];
    }
}

-(void)startImageDownloadingForRecord:(JCPhotoDownLoadRecord *)record atIndexPath:(NSIndexPath *)indexPath {

    if (![self.pendingOperations.downloadsInProgress.allKeys containsObject:indexPath]) {
        
        JCImageDownLoader *imageDownloader = [[JCImageDownLoader alloc] initWithPhotoRecord:record atIndexPath:indexPath delegate:self];
        
        JCURLRetriever *dependency = [self.pendingOperations.URLRetrieversInProgress objectForKey:indexPath];
        if (dependency)
            [imageDownloader addDependency:dependency];
        
        
        [self.pendingOperations.downloadsInProgress setObject:imageDownloader forKey:indexPath];
        [self.pendingOperations.downloadQueue addOperation:imageDownloader];
    }
}

-(void)startImageFiltrationForRecord:(JCPhotoDownLoadRecord *)record atIndexPath:(NSIndexPath *)indexPath {

    if (![self.pendingOperations.filtrationsInProgress.allKeys containsObject:indexPath]) {
        
        // Start filtration
        JCPhotoFiltering *imageFiltration = [[JCPhotoFiltering alloc] initWithPhotoRecord:record atIndexPath:indexPath delegate:self];
        
        JCImageDownLoader *dependency = [self.pendingOperations.downloadsInProgress objectForKey:indexPath];
        if (dependency)
            [imageFiltration addDependency:dependency];
        
        [self.pendingOperations.filtrationsInProgress setObject:imageFiltration forKey:indexPath];
        [self.pendingOperations.filtrationQueue addOperation:imageFiltration];
    }
}

#pragma mark - Downloader delegate
//this is where we get the call backs for when the Operation is complete
-(void)JCURLRetrieverDidFinish:(JCURLRetriever *)downloader{
    //Url is now retrived
   
    NSIndexPath *indexPath = downloader.indexPathInTableView;
    
    JCPhotoDownLoadRecord *theRecord = downloader.photoRecord;
    
    //get the event from the collection view
    eventObject *event = [self.collectionViewDataObject[indexPath.section] objectAtIndex:indexPath.row];
    //insert the photoDownload object to replace the old one
    event.photoDownload = theRecord;
    [self.collectionViewDataObject[indexPath.section] replaceObjectAtIndex:indexPath.row withObject:event];
    //relaod the table view
    [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]];
    //take out of operation Q
    [self.pendingOperations.URLRetrieversInProgress removeObjectForKey:indexPath];
    
}
//method as above
-(void)imageDownloaderDidFinish:(JCImageDownLoader *)downloader {
    NSIndexPath *indexPath = downloader.indexPathInTableView;
    JCPhotoDownLoadRecord *theRecord = downloader.photoRecord;
    eventObject *event = [self.collectionViewDataObject[indexPath.section] objectAtIndex:indexPath.row];
    event.photoDownload = theRecord;
    [self.collectionViewDataObject[indexPath.section] replaceObjectAtIndex:indexPath.row withObject:event];
    [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]];
    [self.pendingOperations.downloadsInProgress removeObjectForKey:indexPath];
}
//method as above
-(void)imageFiltrationDidFinish:(JCPhotoFiltering *)filtration {
    
    NSIndexPath *indexPath = filtration.indexPathInTableView;
    JCPhotoDownLoadRecord *theRecord = filtration.photoRecord;
    eventObject *event = [self.collectionViewDataObject[indexPath.section] objectAtIndex:indexPath.row];
    event.photoDownload = theRecord;
    [self.collectionViewDataObject[indexPath.section] replaceObjectAtIndex:indexPath.row withObject:event];
    [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]];
    [self.pendingOperations.filtrationsInProgress removeObjectForKey:indexPath];
}

#pragma mark - UIScrollView delegate
//to make sure we are only downloading image for where the user is in the collection view
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    //user is scrolling to a diffrent point so suspend operation for current point
    [self suspendAllOperations];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

    if (!decelerate) {
        [self loadImagesForOnscreenCells];
        [self resumeAllOperations];
    }
}

//the mothod laods a new section into the collection view when the user gets to the bottom of the collection view
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    float endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;

    
    if (endScrolling >= scrollView.contentSize.height)
    {
        //TODO add animation to pull to refresh
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

//- (IBAction)unwindHomeScreenCollectionView:(UIStoryboardSegue *)unwindSegue
//{
//    
//}

-(void)PerformNavigationForItemAtIndex: (NSIndexPath*)index{
    
    //when user clicks a cell.
    //1 get event object(gig) user clicked on
    //2 Give the to the destination View Contolrer
    //2 load an instance of Destination View Controler (JCGigMoreInfo)
    eventObject *currentEvent = [self.collectionViewDataObject[index.section] objectAtIndex:index.row];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *myVC = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"JCGigMoreInfoNav"];
        JCGigMoreInfoVC *DVC = [myVC viewControllers][0];
        DVC.JCGigMoreInfoVCDelegate = self;
        DVC.currentEvent = currentEvent;
        [self presentViewController:myVC animated:YES completion:nil];
        
}

//load search VC
-(void)serchbuttonPressed:(id)sender {
 [self performSegueWithIdentifier:@"showSearchPage" sender:self];

}

-(void)JCSearchPageDidSelectDone:(JCSearchPage *)controller{
    [self dismissViewControllerAnimated:YES completion:nil];
};


-(void)menuButtonPressed{
    //[self.navigationController setNavigationBarHidden: YES animated:YES];
    [self.sideMenuViewController presentLeftMenuViewController];
    
}

-(void)JCGigMoreInfoVCDidSelectDone:(JCGigMoreInfoVC *)controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma  - Helper Methods

-(void)getDataForCollectionView{

    //1 add one day onto the date for the next api call
    //2 get data form BIT useing the class I made
    //3 returns an array of parsed event objects so add the to the table view data soucre
    //4 relaod table view
    //If location acress denided default loacation is set to diblin
    
    NSDate  *dateForAPICall = [[NSDate alloc]init];
    dateForAPICall = self.dateForAPICall;
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = 1;
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    self.dateForAPICall = [theCalendar dateByAddingComponents:dayComponent toDate:self.dateForAPICall options:0];
    
   
    if (!self.userLocation) {
        NSLog(@"location acess denied getting gigs from dublin");
    }
    
    
    [self.JCHomeScreenDataController getEventsforDate:dateForAPICall usingLocation:self.userLatitude Longditude:self.usersLongditude competionBlock:^(NSError *error, NSArray *response) {
        
        
        if ([response count]!=0) {
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionViewDataObject addObject:response];
                [self.collectionView reloadData];
                
                      //if less the 7 gigs come back go the BIT and get the next days to, this ensures there is never an empty screen on first load.
                        if ([response count]<=7) {
                            [self performSelector:@selector(getDataForCollectionView) withObject:self afterDelay:1.0 ];
                        }
            });
        }
    }];
    
}

//ask for users loaction and wait for call back
-(void)getlocationAndWaitforUpdateThenGetDataForCollectionView{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
}

//customise nav bar
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

//if access denined default to dublin
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    self.userLatitude = @"53.3478";
    self.usersLongditude = @"-6.2597";
    [self getDataForCollectionView];
    //NSLog(@"location set to dublin");
}

//else user allowed location services
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


-(void)SocialStreamViewControllerDidSelectDone:(JCSocailStreamController *)controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
