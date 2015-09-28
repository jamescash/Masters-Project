//
//  JCFollowingArtistVC.m
//  PreAmp
//
//  Created by james cash on 27/09/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCFollowingArtistVC.h"

@interface JCFollowingArtistVC ()
@property (weak, nonatomic) IBOutlet UITableView *follwoingArtist;
@property (nonatomic,strong) NSArray *MyArtist;
@property (nonatomic,strong) PFRelation *artistRelations;

@end

@implementation JCFollowingArtistVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{


     [super viewWillAppear:animated];
     [self getMyartist];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.MyArtist.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    
    PFObject *artist = [self.MyArtist objectAtIndex:indexPath.row];
    cell.textLabel.text = [artist objectForKey:@"artistName"];
    return cell;
}

#pragma - Helper Methods

-(void)getMyartist{
    
    
    self.artistRelations = [[PFUser currentUser] objectForKey:@"ArtistRelation"];
    PFQuery *query  = [self.artistRelations query];
    [query orderByAscending:@"artistName"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"Error coming form insode get my artist relations %@",error);
        }else{
        
        self.MyArtist = objects;
        [self.follwoingArtist reloadData];
        }
        
    }];
    
}


@end
