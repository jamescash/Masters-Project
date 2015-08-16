//
//  JCSearchPage.m
//  masterbranch
//
//  Created by james cash on 15/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "JCSearchPage.h"
#import "eventObject.h"



@interface JCSearchPage ()

@property (nonatomic,strong) JCSearchPageHTTPClient *searchclient;
@property (nonatomic,strong) NSArray *searchResults;


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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.searchResults[section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //creat a cell from the class JCsocialStreamCell and give the the reuse identifier FDFeedCell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchResultsCell" forIndexPath:indexPath];
    
    //call the configurecell method on that cell
    //[self configureCell:cell atIndexPath:indexPath];
    
    eventObject *event = self.searchResults[indexPath.section][indexPath.row];
    
    cell.textLabel.text = event.eventTitle;
    
    cell.detailTextLabel.text = event.country;
    
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
    
    _searchclient = [[JCSearchPageHTTPClient alloc]initWithArtistName:searchBar.text];
    self.searchclient.JCSearchPageHTTPClientdelegate = self;
    [searchBar resignFirstResponder];
}


- (IBAction)UserSelectedDone:(id)sender {

    [self.JCSearchPageDelegate JCSearchPageDidSelectDone:self];
}
@end
