//
//  JCInboxDetail.m
//  PreAmp
//
//  Created by james cash on 20/09/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCInboxDetail.h"
#import "HeaderViewWithImage.h"
#import "HeaderView.h"
#import "JCHomeMainScreenVC.h"



@interface JCInboxDetail ()
@property (weak, nonatomic) IBOutlet UITableView *tableViewVC;
@end

@implementation JCInboxDetail


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
 
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    HeaderViewWithImage *headerView = [HeaderViewWithImage instantiateFromNib];
    headerView.HeaderImageView.image = self.selectedInviteImage;
    headerView.ArtistName.text = [self.userEvent objectForKey:@"eventTitle"];
    [self.tableViewVC setParallaxHeaderView:headerView
                                          mode:VGParallaxHeaderModeFill
                                        height:200];
    
//    
//    UILabel *stickyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//    stickyLabel.backgroundColor = [UIColor colorWithRed:1 green:0.749 blue:0.976 alpha:1];
//    stickyLabel.textAlignment = NSTextAlignmentCenter;
//    stickyLabel.text = [self.userEvent objectForKey:@"eventHostName"];;
//    
    //self.tableViewVC.parallaxHeader.stickyViewPosition = VGParallaxHeaderStickyViewPositionTop;
   //[self.tableViewVC.parallaxHeader setStickyView:stickyLabel
                                     // withHeight:40];
    
    
    //[self.mainScrollView setContentSize:CGSizeMake(self.view.bounds.size.width, 3000)];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.tableViewVC shouldPositionParallaxHeader];
    
    // Log Parallax Progress
    //NSLog(@"Progress: %f", scrollView.parallaxHeader.progress);
}
#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"Section %@", @(section)];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *CellIdentifier = @"SectionHeader";
    UITableViewCell *headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (headerView == nil){
        [NSException raise:@"headerView == nil.." format:@"No cells with matching CellIdentifier loaded from your storyboard"];
    }
    return headerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    
    
    return 202;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"Row %@", @(indexPath.row)];
    
    return cell;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
}


//
//#pragma mark - UICollectionView Datasource
//
//- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
//    
//    return 5;
//}
//
//- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
//    return 2;
//}
//
//
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//
//  UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
//  return cell;
//    
//}
//
//
//
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
//
//    NSLog(@"%@",kind);
//    
//    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
//        
//        //NSDictionary *obj = self.sections[indexPath.section];
//        
//        JCCollectionViewHeaders *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
//                                                                   withReuseIdentifier:@"sectionHeader"
//                                                                          forIndexPath:indexPath];
//        
//        //cell.textLabel.text = [[obj allKeys] firstObject];
//        
//        return cell;
//    } else if ([kind isEqualToString:CSStickyHeaderParallaxHeader]) {
//        
//        NSLog(@"hareder");
//        UICollectionReusableView *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind
//                                                                            withReuseIdentifier:@"header"
//                                                                                   forIndexPath:indexPath];
//        
//        return cell;
//    }
//    return nil;
//}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
