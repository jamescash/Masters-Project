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




@interface JCSearchPage ()

@property (nonatomic,strong) JCSearchPageHTTPClient *searchclient;
@property (nonatomic,strong) NSArray *searchResults;
@property (weak, nonatomic) IBOutlet UISearchBar *SearchBar;
- (IBAction)UserSelectedDone:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *SearchResultsTable;
@property (weak, nonatomic) IBOutlet UIImageView *BackGroundImage;


@end

@implementation JCSearchPage

- (void)viewDidLoad {
    [super viewDidLoad];
    self.SearchBar.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.searchResults.count;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = @"Gigs in Ireland";
            break;
        case 1:
            sectionName = @"Top 5 closest gigs to Ireland";
            break;
        case 2:
            sectionName = @"Everything Else";
            break;
        default:
            break;
    }
    return sectionName;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.searchResults[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //creat a cell from the class JCsocialStreamCell and give the the reuse identifier FDFeedCell
    JCSearchPageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResultsCell" forIndexPath:indexPath];
    
    //call the configurecell method on that cell
    //[self configureCell:cell atIndexPath:indexPath];
    
    eventObject *event = self.searchResults[indexPath.section][indexPath.row];
    cell.titleLabel.text = event.eventTitle;
    
    
    NSString *subtitle = [NSString stringWithFormat:@"%@ - %@, Distance from Ireland %dkm",event.county,event.country,event.DistanceFromIreland];
    
    cell.subtitleLabel.text = subtitle;
    
    
    //insert that cell
    return cell;
}


#pragma SearchHTTPdelegatMethods

-(void)searchResultsGathered:(NSMutableArray *)searchResults{
    
    self.searchResults = searchResults;
    
     dispatch_async(dispatch_get_main_queue(), ^{
        [self.SearchResultsTable reloadData];
     });
    
    

};


#pragma searchbarDelagateMethods

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    //when the user clicks seacrh alloc init the search HTTPCline with the search trem 
    _searchclient = [[JCSearchPageHTTPClient alloc]initWithArtistName:searchBar.text];
    self.searchclient.JCSearchPageHTTPClientdelegate = self;
    [searchBar resignFirstResponder];
}


- (IBAction)UserSelectedDone:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
