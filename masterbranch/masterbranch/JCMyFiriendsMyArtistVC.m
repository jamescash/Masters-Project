//
//  JCMyFiriendsMyArtistVC.m
//  PreAmp
//
//  Created by james cash on 20/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCMyFiriendsMyArtistVC.h"
#import "JCParseQuerys.h"
#import <Parse/Parse.h>
#import "JCMyArtistCell.h"
#import "JCMyFriendsCell.h"
#import "JCAddMyFriendsVC.h"






@interface JCMyFiriendsMyArtistVC () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *tableViewDataSource;
@property (nonatomic,strong) JCParseQuerys *JCParseQuerys;
@property (nonatomic,strong) NSMutableArray *imageFiles;
@property (nonatomic,strong) NSArray *MyFireds;


@end

@implementation JCMyFiriendsMyArtistVC{
    NSString *firendskey;
    NSString *artistkey;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    firendskey = @"friends";
    artistkey =@"artist";
    self.imageFiles = [[NSMutableArray alloc]init];
    self.tableView.allowsSelection = NO;
    self.JCParseQuerys = [JCParseQuerys sharedInstance];
}


- (void) viewWillAppear:(BOOL)animated{
    
    NSLog(@"%@",self.tableViewType);
    
    if ([self.tableViewType isEqualToString:firendskey]) {
        
        [self setupNavBarForScreen:self.tableViewType];
         self.navigationItem.title = @"My Friends";
        [self.JCParseQuerys getMyFriends:^(NSError *error, NSArray *response) {
            
            self.tableViewDataSource = response;
            self.MyFireds = response;


            for (PFObject *user in response) {
                PFFile *imageFile = [user objectForKey:@"thumbnailProfilePicture"];
                [self.imageFiles addObject:[@{@"pfFile":imageFile} mutableCopy]];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                 });
         }];
    }else if ([self.tableViewType isEqualToString:artistkey]){
         self.navigationItem.title = @"My artist";
        [self.JCParseQuerys getMyAtrits:^(NSError *error, NSArray *response) {
            
            self.tableViewDataSource = response;
            for (PFObject *artist in response) {
                 PFFile *imageFile = [artist objectForKey:@"thmbnailAtistImage"];
                [self.imageFiles addObject:[@{@"pfFile":imageFile} mutableCopy]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                 [self.tableView reloadData];
            });
         }];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.tableViewType isEqualToString:firendskey]){
    JCMyFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendsCell" forIndexPath:indexPath];
    [cell formateCell:[self.tableViewDataSource objectAtIndex:indexPath.row]];
        UIImage *userImage = self.imageFiles[indexPath.row][@"image"];

        if (userImage) {
            cell.userImage.image = userImage;
            cell.userImage.contentMode = UIViewContentModeScaleToFill;
        }else {
            NSUInteger randomNumber = arc4random_uniform(5);
            switch (randomNumber) {
                case 0:
                    cell.userImage.image = [UIImage imageNamed:@"loadingYellow.png"];
                    cell.userImage.contentMode = UIViewContentModeScaleAspectFill;
                    break;
                case 1:
                    cell.userImage.image = [UIImage imageNamed:@"loadingPink.png"];
                    cell.userImage.contentMode = UIViewContentModeScaleAspectFill;
                    break;
                case 2:
                    cell.userImage.image = [UIImage imageNamed:@"loadingBlue.png"];
                    cell.userImage.contentMode = UIViewContentModeScaleAspectFill;
                    break;
                case 3:
                    cell.userImage.image = [UIImage imageNamed:@"loadingGreen.png"];
                    cell.userImage.contentMode = UIViewContentModeScaleAspectFill;
                    break;
              }
            
            [self DownloadImageForeventAtIndex:indexPath completion:^(UIImage* image, NSError* error) {
                if (!error) {
                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
                
            }];
        }
        return cell;
      }else if ([self.tableViewType isEqualToString:artistkey]){
    
    JCMyArtistCell *cell = [tableView dequeueReusableCellWithIdentifier:@"artistCell" forIndexPath:indexPath];
    [cell formatCell:[self.tableViewDataSource objectAtIndex:indexPath.row]];
        UIImage *artistImage = self.imageFiles[indexPath.row][@"image"];

  
        if (artistImage) {
            cell.artistImage.image = artistImage;
            cell.artistImage.contentMode = UIViewContentModeScaleToFill;
        }else {
            NSUInteger randomNumber = arc4random_uniform(5);
            switch (randomNumber) {
                case 0:
                    cell.artistImage.image = [UIImage imageNamed:@"loadingYellow.png"];
                    cell.artistImage.contentMode = UIViewContentModeScaleAspectFill;
                    break;
                case 1:
                    cell.artistImage.image = [UIImage imageNamed:@"loadingPink.png"];
                    cell.artistImage.contentMode = UIViewContentModeScaleAspectFill;
                    break;
                case 2:
                    cell.artistImage.image = [UIImage imageNamed:@"loadingBlue.png"];
                    cell.artistImage.contentMode = UIViewContentModeScaleAspectFill;
                    break;
                case 3:
                    cell.artistImage.image = [UIImage imageNamed:@"loadingGreen.png"];
                    cell.artistImage.contentMode = UIViewContentModeScaleAspectFill;
                    break;
                    
            }
            
            [self DownloadImageForeventAtIndex:indexPath completion:^(UIImage* image, NSError* error) {
                if (!error) {
                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
                
            }];
        }
      return cell;
    }
    
    return nil;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableViewDataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 68;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)DownloadImageForeventAtIndex:(NSIndexPath *)indexPath completion:(void (^)( UIImage *,NSError*)) completion {
    
    // if we fetched already, just return it via the completion block
    UIImage *existingImage = self.imageFiles[indexPath.row][@"image"];
    
    if (existingImage){
        completion(existingImage, nil);
    }
    
    PFFile *pfFile = self.imageFiles[indexPath.row][@"pfFile"];
    
    if (!pfFile) {
      UIImage *eventImage = [UIImage imageNamed:@"loadingYellow.png"];
        completion(eventImage, nil);
    }
    
    [pfFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *eventImage = [UIImage imageWithData:imageData];
           
            
            
            self.imageFiles[indexPath.row][@"image"] = eventImage;
            completion(eventImage, nil);
        } else {
            completion(nil, error);
        }
    }];
}

#pragma - HelperMethods


- (void)setupNavBarForScreen:(NSString*)screenType
{
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton setImage:[UIImage imageNamed:@"iconSearch.png"] forState:UIControlStateNormal];
    [searchButton setImage:[UIImage imageNamed:@"iconSearch.png"] forState:UIControlStateHighlighted];
    searchButton.adjustsImageWhenDisabled = NO;
    searchButton.frame = CGRectMake(0, self.tableView.frame.size.width-40 , 40, 40);
    
    [searchButton addTarget:self action:@selector(serchbuttonPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *searchbarbutton = [[UIBarButtonItem alloc] initWithCustomView:searchButton];
    self.navigationItem.rightBarButtonItem = searchbarbutton;
    //self.navigationItem.hidesBackButton = YES;
    //self.navigationItem.leftBarButtonItem =item1;
}

-(void)serchbuttonPressed{
    [self performSegueWithIdentifier:@"addFriends" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"addFriends"]){
        //Pass list of friends to add freinds VC so it knows who's alrealdy your friends3
        JCAddMyFriendsVC *addfirendsPage = (JCAddMyFriendsVC*)segue.destinationViewController;
        addfirendsPage.myFriends = [NSMutableArray arrayWithArray:self.MyFireds];
    }
};


@end
