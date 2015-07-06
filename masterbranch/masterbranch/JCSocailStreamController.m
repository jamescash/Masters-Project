//
//  JCSocailStreamController.m
//  masterbranch
//
//  Created by james cash on 28/06/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "JCSocailStreamController.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "JCFeedObject.h"
#import "JCsocialStreamCell.h"

@interface JCSocailStreamController () <UIActionSheetDelegate>
@property (nonatomic, copy) NSArray *prototypeEntitiesFromJSON;
@property (nonatomic, strong) NSMutableArray *feedEntitySections; // 2d array
@property (nonatomic, assign) BOOL cellHeightCacheEnabled;
@end

@implementation JCSocailStreamController{
    NSString *searchquery;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
                          // NSString *stringRep = [NSString stringWithFormat:@"%@",[self.currentevent twitterSearchQuery] ];
                           //NSLog(@"%@",stringRep);
    self.tableView.estimatedRowHeight = 200;
    self.tableView.fd_debugLogEnabled = NO;
    self.cellHeightCacheEnabled = YES;
    
    [self buildTestDataThen:^{
         self.feedEntitySections = @[].mutableCopy;
        [self.feedEntitySections addObject:self.prototypeEntitiesFromJSON.mutableCopy];
        [self.tableView reloadData];
    }];
}

- (void)buildTestDataThen:(void (^)(void))then
{
    
    
   
    
    if ([self.currentevent.status isEqualToString:@"happeningLater"]||[self.currentevent.status isEqualToString:@"alreadyHappened"]) {
        
        //seach by event object insta search query
         searchquery = [NSString stringWithFormat:@"https://api.instagram.com/v1/tags/%@/media/popular?client_id=d767827366a74edca4bece00bcc8a42c",[self.currentevent InstaSearchQuery]];
        NSLog(@"searched by Happening later");
    }else{
        
        NSDictionary *LatLong = [[NSDictionary alloc]init];
        LatLong = self.currentevent.LatLong;
        
        NSString *latitude = LatLong[@"lat"];
        NSString *Longditude = LatLong [@"long"];
        
        //search by lon and lat
        searchquery = [NSString stringWithFormat:@"https://api.instagram.com/v1/media/search?lat=%@&lng=%@&distance=50&client_id=d767827366a74edca4bece00bcc8a42c",latitude,Longditude];
        NSLog(@"searched by LatLong");
    }
    
    
    
    NSURL *url = [NSURL URLWithString:searchquery];
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            NSLog(@"error connecting to insta API");
        } else {
            
            NSDictionary *instaresults = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            
            NSArray *feedDicts = instaresults [@"data"];
            
            if ([feedDicts count]==0) {
                NSLog(@"noting back from insta");
            };
            
            
            
                    /// Convert to `JCfeedObject`
                    NSMutableArray *entities = @[].mutableCopy;
                    [feedDicts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        [entities addObject:[[JCFeedObject alloc] initWithDictionary:obj]];
                    }];
                    self.prototypeEntitiesFromJSON = entities;
            
            
            
            
                 dispatch_async(dispatch_get_main_queue(), ^{
                    
                    !then ?: then();
                    
                });
                
            
            
     
            
            
        }
    }];
    
    
//    // Simulate an async request
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//        // Data from `data.json`
//        NSString *dataFilePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
//        NSData *data = [NSData dataWithContentsOfFile:dataFilePath];
//        NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//        NSArray *feedDicts = rootDict[@"feed"];
//        
//        // Convert to `FDFeedEntity`
//        NSMutableArray *entities = @[].mutableCopy;
//        [feedDicts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            [entities addObject:[[JCFeedObject alloc] initWithDictionary:obj]];
//        }];
//        self.prototypeEntitiesFromJSON = entities;
//        
//        // Callback
//        dispatch_async(dispatch_get_main_queue(), ^{
//            !then ?: then();
//        });
//    });
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.feedEntitySections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.feedEntitySections[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JCsocialStreamCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FDFeedCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(JCsocialStreamCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
    if (indexPath.row % 2 == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    cell.entity = self.feedEntitySections[indexPath.section][indexPath.row];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.cellHeightCacheEnabled) {
        return [tableView fd_heightForCellWithIdentifier:@"FDFeedCell" cacheByIndexPath:indexPath configuration:^(JCsocialStreamCell *cell) {
            [self configureCell:cell atIndexPath:indexPath];
        }];
    } else {
        return [tableView fd_heightForCellWithIdentifier:@"FDFeedCell" configuration:^(JCsocialStreamCell *cell) {
            [self configureCell:cell atIndexPath:indexPath];
        }];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableArray *mutableEntities = self.feedEntitySections[indexPath.section];
        [mutableEntities removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

//#pragma mark - Actions
//
//- (IBAction)refreshControlAction:(UIRefreshControl *)sender
//{
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.feedEntitySections removeAllObjects];
//        [self.feedEntitySections addObject:self.prototypeEntitiesFromJSON.mutableCopy];
//        [self.tableView reloadData];
//        [sender endRefreshing];
//    });
//}
//
//- (IBAction)leftSwitchAction:(UISwitch *)sender
//{
//    self.cellHeightCacheEnabled = sender.isOn;
//}
//
//- (IBAction)rightNavigationItemAction:(id)sender
//{
//    [[[UIActionSheet alloc]
//      initWithTitle:@"Actions"
//      delegate:self
//      cancelButtonTitle:@"Cancel"
//      destructiveButtonTitle:nil
//      otherButtonTitles:
//      @"Insert a row",
//      @"Insert a section",
//      @"Delete a section", nil]
//     showInView:self.view];
//}
//
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    SEL selectors[] = {
//        @selector(insertRow),
//        @selector(insertSection),
//        @selector(deleteSection)
//    };
//    
//    if (buttonIndex < sizeof(selectors) / sizeof(SEL)) {
//        void(*imp)(id, SEL) = (typeof(imp))[self methodForSelector:selectors[buttonIndex]];
//        imp(self, selectors[buttonIndex]);
//    }
//}
//
//- (FDFeedEntity *)randomEntity
//{
//    NSUInteger randomNumber = arc4random_uniform((int32_t)self.prototypeEntitiesFromJSON.count);
//    FDFeedEntity *randomEntity = self.prototypeEntitiesFromJSON[randomNumber];
//    return randomEntity;
//}
//
//- (void)insertRow
//{
//    if (self.feedEntitySections.count == 0) {
//        self.feedEntitySections[0] = @[].mutableCopy;
//    }
//    [self.feedEntitySections[0] insertObject:self.randomEntity atIndex:0];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//}
//
//- (void)insertSection
//{
//    [self.feedEntitySections insertObject:@[self.randomEntity].mutableCopy atIndex:0];
//    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
//}
//
//- (void)deleteSection
//{
//    if (self.feedEntitySections.count > 0) {
//        [self.feedEntitySections removeObjectAtIndex:0];
//        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
//    }
//}

@end