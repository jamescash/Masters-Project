//
//  JCHomeMainScreenVC.m
//  masterbranch
//
//  Created by james cash on 20/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "JCHomeMainScreenVC.h"
//top buttons in the nav bar
#import "MMDrawerBarButtonItem.h"
//framework for moving leftside viewcontroler
#import "UIViewController+MMDrawerController.h"

#import "JCSocailStreamController.h"
//#import "MMDrawerController.h"

#import <QuartzCore/QuartzCore.h>

@interface JCHomeMainScreenVC ()
@property (nonatomic,strong) JCEventBuilder *eventbuilder;
@property (nonatomic,strong) NSDictionary *allEevent;
@property (nonatomic,strong) NSArray *KeysOfAllEventsDictionary;
@property(nonatomic, strong) IBOutlet UICollectionView *collectionView;



@end

@implementation JCHomeMainScreenVC


#pragma ViewLoadingPoints
- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.KeysOfAllEventsDictionary = [[NSArray alloc]init];
    self.allEevent = [[NSDictionary alloc]init];
    
    
    
    //go to bandsintown and build a single array of parsed events
    //this is the entry point to a facade API i designed to deal with the event getting and building
    _eventbuilder  = [JCEventBuilder sharedInstance];
    _eventbuilder.delegate = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"EventImageCell"];

//    [self setupLeftMenuButton];
//    
//    UIColor * barColor = [UIColor
//                          colorWithRed:247.0/255.0
//                          green:249.0/255.0
//                          blue:250.0/255.0
//                          alpha:1.0];
//    
//    [self.navigationController.navigationBar setBarTintColor:barColor];
//    [self.navigationController.view.layer setCornerRadius:10.0f];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//delegate method thats called when all the events are laoded and parsed into the main array
-(void)LoadMapView{
    
    
    _allEevent = [self.eventbuilder getEvent];
    NSLog(@"%d all events count",[self.allEevent count]);
    //[self buildannotations:allEvents];
    [self.collectionView reloadData];
    
    //make sure the annotations are added to the mapview on the main thread
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//        [self.MkMapViewOutLet addAnnotations:annotations];
//        [av stopAnimating];
//        
//    });
    
}


#pragma mark - UICollectionView Datasource


- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    
    if ([self.allEevent count] > 1) {
        self.KeysOfAllEventsDictionary = [self.allEevent allKeys];
        
        NSString *searchTerm = self.KeysOfAllEventsDictionary[section];
        NSLog(@"key for section in collection view delegate %@",searchTerm);
        
        return [self.allEevent[searchTerm] count];
    }else{
        
        return 1;
    }
    
    
    



}


- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    
    //if ([self.allEevent count] > 1) {

    //return [self.KeysOfAllEventsDictionary count];
    
    return 3;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"EventImageCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

/*- (UICollectionReusableView *)collectionView:
 (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
 {
 return [[UICollectionReusableView alloc] init];
 }*/



#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Select Item
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}


#pragma mark – UICollectionViewDelegateFlowLayout

// 1
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    //NSString *searchTerm = self.KeysOfAllEventsDictionary[indexPath.section];
    
    //eventObject *event = self.allEevent[searchTerm][indexPath.row];
    // 2
   // CGSize retval = photo.thumbnail.size.width > 0 ? photo.thumbnail.size : CGSizeMake(100, 100);
   
    
    CGSize retval = CGSizeMake(100, 100);

    retval.height += 35; retval.width += 35;

    return retval;
}

// 3
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(50, 20, 50, 20);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma delegateActions

//-(void)setupLeftMenuButton{
//    
//    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
//    
//    
//    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
//    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(serchbuttonPressed:)];
//    
//}

//
//-(void)leftDrawerButtonPress:(id)sender{
//    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
//    
//}


//-(void)serchbuttonPressed:(id)sender {
//    
//    [self.MainScreenCollectionViewDelegate userDidSelectSearchIcon];
//    
//};

@end
