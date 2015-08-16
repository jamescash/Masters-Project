//
//  JCSearchPage.m
//  masterbranch
//
//  Created by james cash on 15/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "JCSearchPage.h"
#import "JCSearchPageHTTPClient.h"


@interface JCSearchPage ()

@property (nonatomic,strong) JCSearchPageHTTPClient *searchclient;

@end

@implementation JCSearchPage

- (void)viewDidLoad {
    [super viewDidLoad];
    self.SearchBar.delegate = self;
    
    //[self getArtistUpComingEvents:artistNameEncodedRequest];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

#pragma searchbarDelagateMethods

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    _searchclient = [[JCSearchPageHTTPClient alloc]initWithArtistName:searchBar.text];
}


- (IBAction)UserSelectedDone:(id)sender {

    [self.JCSearchPageDelegate JCSearchPageDidSelectDone:self];
}
@end
