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
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface JCSocailStreamController () <UIActionSheetDelegate>
@property (nonatomic, copy) NSArray *prototypeEntitiesFromJSON;
@property (nonatomic, strong) NSMutableArray *feedEntitySections; // 2d array
@property (nonatomic, assign) BOOL cellHeightCacheEnabled;
@end

@implementation JCSocailStreamController{
    NSString *searchquery;
    NSString *instaPlaceID;
    NSString *FBplaceID;
    //dispatch_queue_t FBapiCalls;


}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 200;
    self.tableView.fd_debugLogEnabled = NO;
    self.cellHeightCacheEnabled = YES;
    
    [self buildTestDataThen];
     
//     :^{
//         self.feedEntitySections = @[].mutableCopy;
//        [self.feedEntitySections addObject:self.prototypeEntitiesFromJSON.mutableCopy];
//        [self.tableView reloadData];
//    }];
}

- (void)buildTestDataThen//:(void (^)(void))then
{
    
    //if (!FBapiCalls) {
     //   FBapiCalls = dispatch_queue_create("APIcall.FBapiCalls", NULL);
   // }
    
   //dispatch_async(FBapiCalls, ^{
        
   //if event has not happened yet do this
    if ([self.currentevent.status isEqualToString:@"happeningLater"])
    {
        /////////////////////       //////////////////////////
        //longditude test
        searchquery = [NSString stringWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?client_id=d767827366a74edca4bece00bcc8a42c",@"longitude"];
        
       /////////////////////      //////////////////////////
        
        
        
        
        //normal search
//         searchquery = [NSString stringWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?client_id=d767827366a74edca4bece00bcc8a42c",[self.currentevent InstaSearchQuery]];
        NSLog(@"searched by Happeninglater/already happened");
        
        [self connectToInstagramWithCorrectEndPoint:searchquery then:^{
            self.feedEntitySections = @[].mutableCopy;
            [self.feedEntitySections addObject:self.prototypeEntitiesFromJSON.mutableCopy];
            [self.tableView reloadData];
        }];
    
   
    }
    
    
    
    
    else if ([self.currentevent.status isEqualToString:@"alreadyHappened"]){
        /////////////////////
        //LONGITTUDE TEST
        NSString *latLong = @"53.2775,-6.269722";
        [self getFbPlaceID:@"Marlay Park" location:latLong];
        /////////////////////
      
        //NORMAL
        //NSString *latLong = [NSString stringWithFormat:@"%@,%@",[self.currentevent.LatLong valueForKey:@"lat"],[self.currentevent.LatLong valueForKey:@"long"]];
        //[self getFbPlaceID:self.currentevent.venueName location:latLong];
        
        
        }
        
        
    else{
        
        //////////////////////////
        //longditude test
        searchquery = [NSString stringWithFormat:@"https://api.instagram.com/v1/tags/%@/media/recent?client_id=d767827366a74edca4bece00bcc8a42c",@"longitude"];
        
        //////////////////////////
        

        
        
        
        
        //normal
//        NSDictionary *LatLong = [[NSDictionary alloc]init];
//        LatLong = self.currentevent.LatLong;
//        
//        NSString *latitude = LatLong[@"lat"];
//        NSString *Longditude = LatLong [@"long"];
//        
//        //search by lon and lat
//        searchquery = [NSString stringWithFormat:@"https://api.instagram.com/v1/media/search?lat=%@&lng=%@&distance=50&client_id=d767827366a74edca4bece00bcc8a42c",latitude,Longditude];
//        NSLog(@"searched by LatLong");
        
        [self connectToInstagramWithCorrectEndPoint:searchquery then:^{
            self.feedEntitySections = @[].mutableCopy;
            [self.feedEntitySections addObject:self.prototypeEntitiesFromJSON.mutableCopy];
            [self.tableView reloadData];
        }];

    }
    
}//end of buildTestDataThen

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


















-(void)getFbPlaceID:(NSString*)venueName location:(NSString*)location{

   // dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    
    NSDictionary *parameters = @{@"q":venueName,@"type":@"place",@"center":location,@"distance":@"2000"};
    
    //NSLog(@"parameters %@",parameters);
    
    
    
    
    

    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"search"
                                  parameters:parameters
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        //NSLog(@"working in the complection handeler fb api call TOP");
        
        NSDictionary *JsonResult = result;
        
        NSArray *data = JsonResult[@"data"];
        
        if ([data count]==0) {
            
            NSLog(@"venue name for FB search is %@",venueName);

         
            NSLog(@"Couldnt find a place ID on FaceBook");
        
        }else{
            
            
            NSDictionary *object1 = [data objectAtIndex:1];
            
            FBplaceID = [object1 valueForKey:@"id"];
            
           
            NSLog(@"venue name for FB search is %@",venueName);
            
            NSLog(@"venue lat long for FB search is %@",location);
            
            NSLog(@"%@",data);
            
            NSLog(@"%@ FBplace ID",FBplaceID);
            
            [self getInstagramPlaceIDfromFBplaceID:FBplaceID];
        }
        
    }];
    




    
    

};



-(void)getInstagramPlaceIDfromFBplaceID: (NSString*) FBplaceIDstring{
    
    
    
    
    NSString *InstaPlaceIdSearch = [NSString stringWithFormat:@"https://api.instagram.com/v1/locations/search?facebook_places_id=%@&client_id=d767827366a74edca4bece00bcc8a42c",FBplaceIDstring];
    
    
    NSURL *url = [NSURL URLWithString:InstaPlaceIdSearch];
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            NSLog(@"error coming from InstaPlaceIdSearch %@",error);
        } else {
            
            NSDictionary *instaresults = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            
            
            NSArray *data = instaresults [@"data"];
           
            if ([data count]==0) {
                NSLog(@"couldnt get place ID from instagram");
            }else{
            NSDictionary *NSDdata = [data objectAtIndex:0];
            instaPlaceID = NSDdata[@"id"];
                NSLog(@"insta resulte are %@",data);
                NSLog(@"%@ instaPlaceID",instaPlaceID);
                
            searchquery = [NSString stringWithFormat:@"https://api.instagram.com/v1/locations/%@/media/recent?client_id=d767827366a74edca4bece00bcc8a42c",instaPlaceID];
          
            [self connectToInstagramWithCorrectEndPoint:searchquery then:^{
                self.feedEntitySections = @[].mutableCopy;
                [self.feedEntitySections addObject:self.prototypeEntitiesFromJSON.mutableCopy];
                [self.tableView reloadData];
            }];
            
           }
            
        }
    }];
    
    
    
}





-(void)connectToInstagramWithCorrectEndPoint: (NSString*)endpoint then: (void (^)(void))then{
    

    NSURL *url = [NSURL URLWithString:endpoint];
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            NSLog(@"error coming from insta APIcall %@",error);
        } else {
            
            NSDictionary *instaresults = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            
            NSArray *feedDicts = instaresults [@"data"];
            
            if ([feedDicts count]==0) {
                NSLog(@"no media back from insta API call");
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








};


//for now object1 is most likely the object were going to be after but
//must come back here and add in some more complex checking to see if it is the right one
//and if not which one is more sutible




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