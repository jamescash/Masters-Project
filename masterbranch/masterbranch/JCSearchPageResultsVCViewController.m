//
//  JCSearchPageResultsVCViewController.m
//  PreAmp
//
//  Created by james cash on 30/11/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCSearchPageResultsVCViewController.h"
#import <TLYShyNavBar/TLYShyNavBarManager.h>
//bandsintown, echo nest api manager
#import "JCHomeScreenDataController.h"
#import "JCSearchResultsCell.h"
#import "JCSearchResultsObject.h"
#import "JCSearchPage.h"
#import "JCSearchPageDetailView.h"


@interface JCSearchPageResultsVCViewController ()
@property (nonatomic,strong) JCHomeScreenDataController *JCSearchAPI;
@property (weak, nonatomic) IBOutlet UISearchBar *UISearchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *tableViewDataSource;
@property (nonatomic, strong) JCPendingOperations *pendingOperations;
@property (nonatomic,strong) JCSearchResultsObject *selectedObject;
@property (nonatomic,strong) NSString *searchQuery;
@end

@implementation JCSearchPageResultsVCViewController{
    BOOL isLoadingData;
    BOOL isFirstScreenLaunch;
    UITapGestureRecognizer *resignKeyBoardOnTap;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
    [self addCustomButtonOnNavBar];
    
}

-(void)initialize{
    self.UISearchBar.delegate = self;
    self.JCSearchAPI = [[JCHomeScreenDataController alloc]init];
    self.tableViewDataSource = [[NSMutableArray alloc]init];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    isLoadingData = NO;
    isFirstScreenLaunch = YES;
    [self listenForKeyboardNoticfitions];
}

- (JCPendingOperations *)pendingOperations {
    if (!_pendingOperations) {
        _pendingOperations = [[JCPendingOperations alloc] init];
    }
    return _pendingOperations;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - Table View Delage
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.tableViewDataSource count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JCSearchResultsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchResultsCell"];
    
    JCSearchResultsObject *artist = [self.tableViewDataSource objectAtIndex:indexPath.row];
    
    JCPhotoDownLoadRecord *aRecord = artist.photoDownload;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (aRecord.hasImage) {
        cell.UIImageArtistImage.image = aRecord.image;
    }else if (aRecord.isFailed) {
        cell.UIImageArtistImage.image = [UIImage imageNamed:@"iconFailed"];
    }else{
        cell.UIImageArtistImage.image = [UIImage imageNamed:@"loadingGreyPlane"];
        [self startOperationsForPhotoRecord:aRecord atIndexPath:indexPath];
    }
    
    cell.UILableArtistName.text = artist.artistName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    self.selectedObject = [self.tableViewDataSource objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"ShowSearchDetail" sender:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

#pragma - Search API
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    isFirstScreenLaunch = NO;
    isLoadingData = YES;
    self.searchQuery = searchBar.text;

    dispatch_async(dispatch_get_main_queue(), ^{
       [self.tableView reloadData];
        
    });
    //encode search query for web
    NSString *searchQueryEncoded = [searchBar.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    [self.JCSearchAPI getArtistSuggestionsForSearchQuery:searchQueryEncoded competionBlock:^(NSError *error, NSArray *artistSuggestions) {
        [self.tableViewDataSource removeAllObjects];
        [self.tableViewDataSource addObjectsFromArray:artistSuggestions];
        isLoadingData = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableView reloadData];
                
            });
        
    }];
    
    

    [searchBar resignFirstResponder];
}

#pragma - Costomize UI
- (void)addCustomButtonOnNavBar
{
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [menuButton setImage:[UIImage imageNamed:@"iconDown.png"] forState:UIControlStateNormal];
    //[menuButton setImage:[UIImage imageNamed:@"iconMenu.png"] forState:UIControlStateHighlighted];
    menuButton.adjustsImageWhenDisabled = NO;
    //set the frame of the button to the size of the image (see note below)
    menuButton.frame = CGRectMake(0, 0, 40, 40);
    menuButton.opaque = YES;
    
    [menuButton addTarget:self action:@selector(menuButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    //create a UIBarButtonItem with the button as a custom view
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    self.navigationItem.leftBarButtonItem = customBarItem;
    self.navigationItem.titleView = self.UISearchBar;
    
    
    [self.UISearchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"iconEmpty.png"]forState:UIControlStateNormal];
    
    self.shyNavBarManager.scrollView = self.tableView;
    
}
-(void)menuButtonPressed{
    [self.UISearchBar resignFirstResponder];
     [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma - Asyn Image Downloader

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

-(void)JCURLRetrieverDidFinish:(JCURLRetriever *)downloader{
    
    
    NSIndexPath *indexPath = downloader.indexPathInTableView;
    
    JCPhotoDownLoadRecord *theRecord = downloader.photoRecord;
    
    //NSString *key = [self.KeysOfAllEventsDictionary objectAtIndex:indexPath.section];
    
    JCSearchResultsObject *artist = [self.tableViewDataSource objectAtIndex:indexPath.row];
    
    artist.photoDownload = theRecord;
    
    [self.tableViewDataSource replaceObjectAtIndex:indexPath.row withObject:artist];
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];

    //[self.tableView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]];
    
    [self.pendingOperations.URLRetrieversInProgress removeObjectForKey:indexPath];
    
}

-(void)imageDownloaderDidFinish:(JCImageDownLoader *)downloader {
    
    
    // 1: Check for the indexPath of the operation, whether it is a download, or filtration.
    NSIndexPath *indexPath = downloader.indexPathInTableView;
    
    // 2: Get hold of the PhotoRecord instance.
    JCPhotoDownLoadRecord *theRecord = downloader.photoRecord;
    
    JCSearchResultsObject *artist = [self.tableViewDataSource objectAtIndex:indexPath.row];
    
    artist.photoDownload = theRecord;
    
    [self.tableViewDataSource replaceObjectAtIndex:indexPath.row withObject:artist];
    
    //becuse im adding sections so the index path is diffrent then when added?
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    // 5: Remove the operation from downloadsInProgress (or filtrationsInProgress).
    [self.pendingOperations.downloadsInProgress removeObjectForKey:indexPath];
}

-(void)imageFiltrationDidFinish:(JCPhotoFiltering *)filtration {
    
    NSIndexPath *indexPath = filtration.indexPathInTableView;
    
    JCPhotoDownLoadRecord *theRecord = filtration.photoRecord;
    
    JCSearchResultsObject *artist = [self.tableViewDataSource objectAtIndex:indexPath.row];
    
    artist.photoDownload = theRecord;
    
    [self.tableViewDataSource replaceObjectAtIndex:indexPath.row withObject:artist];
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    [self.pendingOperations.filtrationsInProgress removeObjectForKey:indexPath];
}


#pragma - Empty data set 

-(NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView

{
    NSString *text;
    if (isFirstScreenLaunch) {
        text = @"Search";
    }else{
        
        if (isLoadingData) {
            text = @"Loading...";
        }else{
            text = @"No results found";
        }

        
        
    }
    
   
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

-(NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text;
    if (isFirstScreenLaunch) {
        text = @"Search for your favorite artist or band";
    }else{
        
        if (isLoadingData) {
            text = [NSString stringWithFormat:@"Searching artists and bands named %@",self.searchQuery];
        }else{
            text = @"Please try searching for another artist";
        }
        
        
    }
   
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    
        return [UIImage imageNamed:@"emptySearch"];
    
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return 2;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   
    if ([segue.identifier isEqualToString:@"ShowSearchDetail"]){
        
        JCSearchPageDetailView *DVC =(JCSearchPageDetailView*)[segue destinationViewController];
        
        DVC.artistName = self.selectedObject.artistName;
        DVC.artistImage = self.selectedObject.photoDownload.image;
        
        
    }
}

#pragma - Keyboard Handler

-(void)listenForKeyboardNoticfitions{
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(keyboardOnScreen:) name:UIKeyboardDidShowNotification object:nil];
     [center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        //add tap recongiser that will resign first responder while keybord is up and user taps anywhere
        resignKeyBoardOnTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                      action:@selector(didTapAnywhere)];
    
}
-(void)didTapAnywhere{
    [self.UISearchBar resignFirstResponder];
}

-(void)keyboardOnScreen:(NSNotification *)notification
{
    NSLog(@"keyboardOnScreen");
    [self.view addGestureRecognizer:resignKeyBoardOnTap];
}
-(void)keyboardWillHide:(NSNotification *) note
{
    NSLog(@"keyboardWillHide");
    [self.view removeGestureRecognizer:resignKeyBoardOnTap];
}


@end
