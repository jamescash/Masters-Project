//
//  JCSearchPage.m
//  masterbranch
//
//  Created by james cash on 15/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "JCSearchPage.h"
#import "eventObject.h"
#import "JCSearchPageCell.h"
#import <TLYShyNavBar/TLYShyNavBarManager.h>
#import "HeaderViewWithImage.h"
#import "HeaderView.h"
#import "JCUpcomingGigTableViewCell.h"
#import "MGSwipeButton.h"
#import "JCHomeScreenDataController.h"
#import "JCConstants.h"
#import "JCSearchHeaders.h"
#import <Google/Analytics.h>

@interface JCSearchPage (){
    BOOL sortedByDistanceFromIreland;
}

@property (nonatomic,strong) JCSearchPageHTTPClient *searchclient;
@property (nonatomic,strong) JCHomeScreenDataController *JCSearchAPI;

@property (nonatomic,strong) NSDictionary *dataSource;
@property (weak, nonatomic) IBOutlet UISearchBar *SearchBar;
- (IBAction)UserSelectedDone:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *SearchResultsTable;
@property (weak, nonatomic) IBOutlet UIImageView *BackGroundImage;

@property (strong,nonatomic ) CAGradientLayer *vignetteLayer;
@property (strong,nonatomic) HeaderViewWithImage *headerView;
@property (strong,nonatomic) NSString *searchQuery;
@property (strong,nonatomic) NSString *resultsType;
//Results for current Query
@property (nonatomic,strong) NSDictionary *currentResults;
@property (nonatomic,strong) JCSortButtonsCell *ButtonsheaderView;




@end

@implementation JCSearchPage{
    UITapGestureRecognizer *resignKeyBoardOnTap;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.SearchBar.delegate = self;
    [self addCustomButtonOnNavBar];
    self.SearchResultsTable.emptyDataSetSource = self;
    self.SearchResultsTable.emptyDataSetDelegate = self;
    self.JCSearchAPI = [[JCHomeScreenDataController alloc]init];
    sortedByDistanceFromIreland = YES;
    self.screenName = @"Search Screen";

    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardOnScreen:) name:UIKeyboardDidShowNotification object:nil];
    //add tap recongiser that will resign first responder while keybord is up and user taps anywhere
    resignKeyBoardOnTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                  action:@selector(didTapAnywhere:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
//    [tracker set:kGAIScreenName value:@"Search"];
//    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
//    
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count ;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    static NSString *sortButtons = @"sortButtonsCell";
    static NSString *headerViews = @"header";

    self.ButtonsheaderView = [tableView dequeueReusableCellWithIdentifier:sortButtons];
    JCSearchHeaders *headerView = [tableView dequeueReusableCellWithIdentifier:headerViews];
    NSArray *numberOfGigsInIreland = [self.dataSource objectForKey:@"In Ireland"];
    NSArray *numberOfGigsAroundIreland = [self.dataSource objectForKey:@"Around Ireland"];

    //In Ireland
    NSLog(@"%@",self.dataSource);
    
    if (sortedByDistanceFromIreland) {
        switch (section)
        {
            case 0:
                if (self.ButtonsheaderView == nil){
                    [NSException raise:@"headerView == nil.." format:@"No cells with matching CellIdentifier loaded from your storyboard"];
                }
                
                [self.ButtonsheaderView formateCellWithBool:sortedByDistanceFromIreland];
                self.ButtonsheaderView.JCSortButtonsCellDelagate = self;
                return self.ButtonsheaderView;
                break;
            case 1:
               
                if ([numberOfGigsInIreland count]<1) {
                    UIView *nilView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
                    return nilView;
                }else{
                    [headerView formatHeaderWithTitle:@"Gigs in Ireland"];
                    return headerView;
                 }
                
               
                break;
            case 2:
                if ([numberOfGigsAroundIreland count]<1) {
                    UIView *nilView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 1)];
                    return nilView;
                }else{
                    [headerView formatHeaderWithTitle:@"Sorted by distance from Ireland"];
                    return headerView;
                }


                break;
            default:
                break;
        }
    }else{
        switch (section)
        {
            case 0:
                if (self.ButtonsheaderView == nil){
                    [NSException raise:@"headerView == nil.." format:@"No cells with matching CellIdentifier loaded from your storyboard"];
                }
                [self.ButtonsheaderView formateCellWithBool:sortedByDistanceFromIreland];

                self.ButtonsheaderView.JCSortButtonsCellDelagate = self;
                return self.ButtonsheaderView;
                break;
            case 1:
                [headerView formatHeaderWithTitle:@"Sorted by upcoming date"];
                return headerView;
                break;
            default:
                break;
        }
    }
    [headerView formatHeaderWithTitle:@"Oops Something went wrong"];
    return headerView;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (sortedByDistanceFromIreland) {
        switch (section)
        {
            case 0:
                return 112;
                break;
            case 1:
                return 50;
                break;
            case 2:
                 return 50;
                break;
            default:
                break;
        }
    }else{
        switch (section)
        {
            case 0:
                return 112;
                break;
            case 1:
                return 50;
                break;
            default:
                break;
        }
    }
    
    return 140;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *allKeys;
    
    if (sortedByDistanceFromIreland) {
        
        allKeys = @[@"Blank Section",@"In Ireland",@"Around Ireland"];
        
    }else{
        allKeys = @[@"Blank Section",@"Sorted by date"];
        
    }
    
    return [[self.dataSource objectForKey:allKeys[section]]count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JCUpcomingGigTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"upComingGig"];
    NSArray *allKeys;

    if (sortedByDistanceFromIreland) {
        allKeys = @[@"Blank Section",@"In Ireland",@"Around Ireland"];

    }else{
        allKeys = @[@"Blank Section",@"Sorted by date"];

    }
        eventObject *event = [self.dataSource objectForKey:[allKeys objectAtIndex:indexPath.section]][indexPath.row];
        [cell formatCell:event];
        cell.leftButtons = @[[MGSwipeButton buttonWithTitle:@"Invite Friends" icon:nil backgroundColor:[UIColor colorWithRed:234.0f/255.0f green:65.0f/255.0f blue:150.0f/255.0f alpha:1.0f]]];
        cell.delegate = self;
        cell.leftSwipeSettings.transition = MGSwipeTransition3D;
    
    return cell;

    

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return 85;
}

#pragma SearchHTTPdelegatMethods

-(void)searchResultsGathered:(NSMutableArray *)searchResults{
    
  //old code
};

-(void)getHeaderImageForSeachResults:(eventObject *)event complectionBlock:(void(^)(NSError* error,UIImage * image))finishedsettingHeader{
    
    
    NSString *imageURL = event.imageUrl;
    
    if (imageURL) {
        NSURL *imageNSURL = [[NSURL alloc]initWithString:imageURL];
        NSData *imageData = [[NSData alloc]initWithContentsOfURL:imageNSURL];
        UIImage *downloadedImage = [UIImage imageWithData:imageData];
        
        finishedsettingHeader(nil,downloadedImage);
    }else{
        
        NSDictionary *userInfo = @{
                                   NSLocalizedDescriptionKey: NSLocalizedString(@"Operation was unsuccessful.", nil),
                                   NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"no image URL found.", nil),
                                   NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"set image to default", nil)
                                   };
        
        
        NSError *error = [NSError errorWithDomain:@"error" code:500 userInfo:userInfo];
        
        finishedsettingHeader(error,nil);

    }
    
    

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.SearchResultsTable shouldPositionParallaxHeader];
}

#pragma searchbarDelagateMethods

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    sortedByDistanceFromIreland = YES;
    NSString *artistNameEncodedRequest = [searchBar.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    self.searchQuery = artistNameEncodedRequest;
    self.headerView.HeaderImageView.image = nil;   //[UIImage imageNamed:@"loadingGray.png"];
    self.headerView.ArtistName.text = @"loading..";

    [self.JCSearchAPI getmbidNumberfor:artistNameEncodedRequest competionBlock:^(NSError *error, NSString *mbid) {
        
        if (error) {
            NSLog(@"%@ getting MBID",error);
        }else{
            
            [self.JCSearchAPI getArtistUpComingEventsForArtistSearch:artistNameEncodedRequest andMbidNumber:mbid competionBlock:^(NSError *error, NSDictionary *results) {
                
                //NSLog(@"%@",results);
                
                
                if ([[results objectForKey:JCSeachPageResultsDicResults] isKindOfClass:[NSString class]] ) {
                    NSString *resultsType = [results objectForKeyedSubscript:JCSeachPageResultsDicResults];
                    if ([resultsType isEqualToString:JCSeachPageResultsDicNoUpcomingGigs]) {
                        self.resultsType = JCSeachPageResultsDicNoUpcomingGigs;

                        [self handelEmptyResultsOftype:JCSeachPageResultsDicNoUpcomingGigs];

                    }else if([resultsType isEqualToString:JCSeachPageResultsDicResultsArtistUnknown]){
                        
                        self.resultsType = JCSeachPageResultsDicResultsArtistUnknown;
                        [self handelEmptyResultsOftype:JCSeachPageResultsDicResultsArtistUnknown];


                    }
                    
                    }else{
                     
                        [self handelSearchResultsWithUpcmoingGigs:results];
                  
                    }
               }];
            }
        
          }];
    
    [searchBar resignFirstResponder];
}

-(void)handelSearchResultsWithUpcmoingGigs:(NSDictionary*)results {

    self.currentResults = results;
    NSDictionary *resultsDic = [results objectForKey:JCSeachPageResultsDicResults];
    self.dataSource = [resultsDic objectForKey:JCSeachPageResultsDicResultsSortedDistanceFromIreland];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self formatHeaderView];
        [self.SearchResultsTable reloadData];
        
    });
    
    
    
}

-(void)handelEmptyResultsOftype:(NSString*)resultsType{
    
    self.dataSource = @{};
    
      dispatch_async(dispatch_get_main_queue(), ^{
          [self formatHeaderView];
          [self.SearchResultsTable reloadData];
      });
}

-(void)formatHeaderView{
    
        // Do any additional setup after loading the view, typically from a nib.
    if (!self.headerView) {
        self.headerView = [HeaderViewWithImage instantiateFromNib];
        self.headerView.ArtistName.text = @"Loading...";
        [self setNameAndImageOnHeaderView:self.searchQuery];
        self.vignetteLayer = [CAGradientLayer layer];
        [self.vignetteLayer setBounds:[self.headerView.HeaderImageView bounds]];
        [self.vignetteLayer setPosition:CGPointMake([self.headerView.HeaderImageView  bounds].size.width/2.0f, [self.headerView.HeaderImageView  bounds].size.height/2.0f)];
        UIColor *lighterBlack = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.9];
        [self.vignetteLayer setColors:@[(id)[[UIColor clearColor] CGColor], (id)[lighterBlack CGColor]]];
        [self.vignetteLayer setLocations:@[@(.10), @(1.0)]];
        [[self.headerView.HeaderImageView  layer] addSublayer:self.vignetteLayer];
        [self.SearchResultsTable setParallaxHeaderView:self.headerView
                                                  mode:VGParallaxHeaderModeFill
                                                height:200];
    }else{
        [self setNameAndImageOnHeaderView:self.searchQuery];

    }
    
        
    
}

-(void)setNameAndImageOnHeaderView:(NSString*)artistName {
   
        
        //making a seperate call to bandsintown to get the artist image, this means we will get the image even if that artist has no upcmoing gigs.
        
        
    
    [self.JCSearchAPI getArtistImage:artistName andMbidNumber:nil competionBlock:^(NSError *error, NSDictionary *artistInfo) {
           
        
        
        
            if (error) {
                dispatch_async(dispatch_get_main_queue(), ^{

                NSLog(@"%@",error);
                self.headerView.HeaderImageView.image = [UIImage imageNamed:@"loadingGray.png"];
                self.headerView.ArtistName.text = @"loading..";
                });

            }else{
                NSString  *artistName = [artistInfo objectForKey:@"artistName"];
                UIImage   *artistImage = [artistInfo objectForKey:@"artistImage"];
                    
                    NSLog(@"ARTIST NAME %@",artistName);
                    
                 if (artistName == nil&&artistImage == nil){
                     dispatch_async(dispatch_get_main_queue(), ^{

                     self.headerView.ArtistName.text = @"Uknown Artist";
                    });

                 }else{
                
                     dispatch_async(dispatch_get_main_queue(), ^{

                     self.headerView.HeaderImageView.image = artistImage;
                         self.headerView.ArtistName.text = artistName;

                     });

                 }
                    
                    

            }
            
        }];
        
        
      
     

}

-(IBAction)UserSelectedDone:(id)sender {
    [self.SearchBar resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma - HelperMethods
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
    self.navigationItem.titleView = self.SearchBar;

    
    [self.SearchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"iconEmpty.png"]forState:UIControlStateNormal];

     self.shyNavBarManager.scrollView = self.SearchResultsTable;

   

    
}
-(void)menuButtonPressed{
    [self.SearchBar resignFirstResponder];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)UIButtonFollowArtist:(id)sender {
    
    
    
}


#pragma - Keyboard Handler

-(void)keyboardOnScreen:(NSNotification *)notification
{
    //[self.view addGestureRecognizer:resignKeyBoardOnSwipe];
    [self.view addGestureRecognizer:resignKeyBoardOnTap];
}
-(void)keyboardWillHide:(NSNotification *) note
{
    //[self.view removeGestureRecognizer:resignKeyBoardOnSwipe];
    [self.view removeGestureRecognizer:resignKeyBoardOnTap];
}

-(void)didTapAnywhere: (UITapGestureRecognizer*) recognizer {
    [self.SearchBar resignFirstResponder];
}

#pragma - SortButton Cell Delagte

-(void)segmentedControlClicked{
    
    
    if (sortedByDistanceFromIreland) {
        sortedByDistanceFromIreland = NO;
        
        
       // [self.ButtonsheaderView buttonSortByDateClicked];
        
        NSDictionary *resultsDic = [self.currentResults objectForKey:JCSeachPageResultsDicResults];
        self.dataSource = [resultsDic objectForKey:JCSeachPageResultsDicResultsSortedOrderOfUpcmoingDate];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.SearchResultsTable reloadData];
        });
    }else{
        
        sortedByDistanceFromIreland = YES;
        
        NSDictionary *resultsDic = [self.currentResults objectForKey:JCSeachPageResultsDicResults];
        self.dataSource = [resultsDic objectForKey:JCSeachPageResultsDicResultsSortedDistanceFromIreland];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.SearchResultsTable reloadData];
            
        });
        
        
    }
}

#pragma - Empty State
-(CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath: @"transform"];
    
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0)];
    
    animation.duration = 0.25;
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    
    return animation;
}
-(NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView

{
    
    NSString *text = @"Search";
    
    if ([self.resultsType isEqualToString:JCSeachPageResultsDicNoUpcomingGigs]){
        text = @"No upcmoing gigs found";
    }else if ([self.resultsType isEqualToString:JCSeachPageResultsDicResultsArtistUnknown]){
        text = @"Unkown Artist";

    }
    
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
-(NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"Type the name of an artist or band and we will tell you the next time they are playing in Ireland";
    
    
    if ([self.resultsType isEqualToString:JCSeachPageResultsDicNoUpcomingGigs]){
        text =[NSString stringWithFormat: @"Looks like we couldn't find any upcoming gigs for %@",self.SearchBar.text];
    }else if ([self.resultsType isEqualToString:JCSeachPageResultsDicResultsArtistUnknown]){
        text =[NSString stringWithFormat: @"We dont seem to have %@ on our database",self.SearchBar.text];
        
    }
    
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}








@end
