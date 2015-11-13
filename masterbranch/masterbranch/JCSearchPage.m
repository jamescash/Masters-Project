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
#import "JCCollectionViewHeaders.h"


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
@property (strong,nonatomic) eventObject *eventForTitleBox;
@property (strong,nonatomic) HeaderViewWithImage *headerView;

@end

@implementation JCSearchPage

- (void)viewDidLoad {
    [super viewDidLoad];
    self.SearchBar.delegate = self;
    [self addCustomButtonOnNavBar];
    self.SearchResultsTable.emptyDataSetSource = self;
    self.SearchResultsTable.emptyDataSetDelegate = self;
    self.JCSearchAPI = [[JCHomeScreenDataController alloc]init];
    sortedByDistanceFromIreland = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count ;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    static NSString *CellIdentifier = @"sortButtonsCell";
    UITableViewCell *ButtonsheaderView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //JCCollectionViewHeaders *StringHeaderView;
    if (sortedByDistanceFromIreland) {
        switch (section)
        {
            case 0:
                if (ButtonsheaderView == nil){
                    [NSException raise:@"headerView == nil.." format:@"No cells with matching CellIdentifier loaded from your storyboard"];
                }
                return ButtonsheaderView;
                break;
            case 1:
                return [self makeHeaderWithText:@"Irish Gigs"];
                break;
            case 2:
                return [self makeHeaderWithText:@"Distance from Ireland"];
                break;
            default:
                break;
        }
    }else{
        switch (section)
        {
            case 0:
                if (ButtonsheaderView == nil){
                    [NSException raise:@"headerView == nil.." format:@"No cells with matching CellIdentifier loaded from your storyboard"];
                }
                return ButtonsheaderView;
                break;
            case 1:
                return [self makeHeaderWithText:@"Sorted by date"];
                break;
            default:
                break;
        }
    }
    
    return [self makeHeaderWithText:@"Oops Something went wrong"];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (sortedByDistanceFromIreland) {
        switch (section)
        {
            case 0:
                return 100;
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
                return 100;
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

-(UIView*)makeHeaderWithText:(NSString*)title{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.SearchResultsTable.frame.size.width, 18)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, self.SearchResultsTable.frame.size.width, 18)];
    NSString *string = title;
    [label setText:string];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]]; //your background color
    return view;
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
    
    
    NSString *artistNameEncodedRequest = [searchBar.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    //when the user clicks seacrh alloc init the search HTTPCline with the search trem
    //_searchclient = [[JCSearchPageHTTPClient alloc]initWithArtistName:searchBar.text];
    //self.searchclient.JCSearchPageHTTPClientdelegate = self;
    
    [self.JCSearchAPI getmbidNumberfor:artistNameEncodedRequest competionBlock:^(NSError *error, NSString *mbid) {
        
        if (error) {
            NSLog(@"%@ getting MBID",error);
        }else{
            
            [self.JCSearchAPI getArtistUpComingEventsForArtistSearch:artistNameEncodedRequest andMbidNumber:mbid competionBlock:^(NSError *error, NSDictionary *results) {
                
                //NSLog(@"%@",results);
                
                
                if ([[results objectForKey:JCSeachPageResultsDicResults] isKindOfClass:[NSString class]] ) {
                    NSString *resultsType = [results objectForKeyedSubscript:JCSeachPageResultsDicResults];
                    if ([resultsType isEqualToString:JCSeachPageResultsDicNoUpcomingGigs]) {
                        
                        NSLog(@"No upcmoing Gigd");

                    }else if([resultsType isEqualToString:JCSeachPageResultsDicResultsArtistUnknown]){
                        
                        NSLog(@"Artist Unknown");

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

    NSDictionary *resultsDic = [results objectForKey:JCSeachPageResultsDicResults];
    self.dataSource = [resultsDic objectForKey:JCSeachPageResultsDicResultsSortedDistanceFromIreland];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // Do any additional setup after loading the view, typically from a nib.
        self.headerView = [HeaderViewWithImage instantiateFromNib];
        
//        for (NSArray *section in self.dataSource) {
//            
//            if ([section count]!=0) {
//                self.eventForTitleBox = [section firstObject];
//                break;
//            }
//        }
        
        if (self.eventForTitleBox != nil){
            self.headerView.ArtistName.text = self.eventForTitleBox.eventTitle;
            
            [self getHeaderImageForSeachResults:self.eventForTitleBox complectionBlock:^(NSError *error, UIImage *image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (error) {
                        NSLog(@"%@",error);
                        self.headerView.HeaderImageView.image = [UIImage imageNamed:@"loadingGray.png"];
                        
                    }else{
                        self.headerView.HeaderImageView.image = image;
                        
                    }
                });
                
            }];
        }
        
        //NSArray *sectionOne = [self.searchResults firstObject];
        //headerView.HeaderImageView.image =
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
        [self.SearchResultsTable reloadData];
    });
    
    
    
}




-(IBAction)UserSelectedDone:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    NSLog(@"cancle");
    
    self.dataSource = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
                
        [self.SearchResultsTable reloadData];
            });
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
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma - Empty 

- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath: @"transform"];
    
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0)];
    
    animation.duration = 0.25;
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    
    return animation;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"Search";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}


- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"Type the name of an artist or band and we will tell you the next time they are playing in Ireland";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}








@end
