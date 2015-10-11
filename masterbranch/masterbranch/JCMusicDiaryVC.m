//
//  JCMusicDiaryVC.m
//  PreAmp
//
//  Created by james cash on 11/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCMusicDiaryVC.h"
#import "JCMusicDiaryHeader.h"


@interface JCMusicDiaryVC ()
@property (weak, nonatomic) IBOutlet UICollectionView *myMusicDiary;

@end

@implementation JCMusicDiaryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 4;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
}


#pragma mark - UICollectionViewDelegate

- (UICollectionReusableView *)collectionView: (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    JCMusicDiaryHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
                                           UICollectionElementKindSectionHeader withReuseIdentifier:@"collectionViewHeader" forIndexPath:indexPath];

    //NSString *text = self.KeysOfAllEventsDictionary[indexPath.section];

    //[headerView setHeaderText:text];

    return headerView;
}


#pragma mark – UICollectionViewDelegateFlowLayout


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat cellLeg = ((self.myMusicDiary.frame.size.width-20)/3);
    return CGSizeMake(cellLeg,cellLeg);
}


// 3
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(5, 0, 0, 0);
}


@end
