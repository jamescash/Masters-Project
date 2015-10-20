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



@interface JCMyFiriendsMyArtistVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *tableViewDataSource;
@property (nonatomic,strong) JCParseQuerys *JCParseQuerys;

@end

@implementation JCMyFiriendsMyArtistVC

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void) viewWillAppear:(BOOL)animated{
    
    
    
    self.JCParseQuerys = [JCParseQuerys sharedInstance];
    
    if ([self.tableViewType isEqualToString:@"friends"]) {
        
        
        if (self.JCParseQuerys.MyFriends) {
            self.tableViewDataSource = self.JCParseQuerys.MyFriends;
        }else{
            
            [self.JCParseQuerys getMyFriends:^(NSError *error, NSArray *response) {
                
                self.tableViewDataSource = response;
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }];
        }
        
        
        
        
    }
    else if ([self.tableViewType isEqualToString:@"artist"]){
        
        if (self.JCParseQuerys.MyArtist) {
            self.tableViewDataSource = self.JCParseQuerys.MyArtist;

            
        }else{
            
            [self.JCParseQuerys getMyAtrits:^(NSError *error, NSArray *response) {
                
                self.tableViewDataSource = response;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
                
            }];
        }
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.tableViewDataSource.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if ([self.tableViewType isEqualToString:@"friends"]){
        
UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendsCell" forIndexPath:indexPath];
        
        
    PFUser *user = [self.tableViewDataSource objectAtIndex:indexPath.row];
        cell.textLabel.text = user.username;
        
        return cell;
        
    }else if ([self.tableViewType isEqualToString:@"artist"]){
        
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"artistCell" forIndexPath:indexPath];
        
        
    PFObject *artist = [self.tableViewDataSource objectAtIndex:indexPath.row];
        cell.textLabel.text = [artist objectForKey:@"artistName"];
        return cell;
        
    
    }
    
    return nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
