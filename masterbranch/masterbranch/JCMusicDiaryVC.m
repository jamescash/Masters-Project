//
//  JCMusicDiaryVC.m
//  PreAmp
//
//  Created by james cash on 11/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCMusicDiaryVC.h"
#import "JCMusicDiaryHeader.h"
#import "JCParseQuerys.h"
#import "JCMusicDiaryCell.h"
#import "JCMusicDiaryObject.h"
#import "JCMusicDiaryArtistObject.h"
#import "JCGigsComingUpInThisMonthVC.h"
#import "RESideMenu.h"
#import "JCCustomCollectionCell.h"

#import "JCConstants.h"






@interface JCMusicDiaryVC ()
//properties
@property (weak, nonatomic) IBOutlet UICollectionView *myMusicDiary;
@property (nonatomic,strong) NSDictionary *UpcomingGigsCalander;
@property (nonatomic,strong) NSArray *UpcomingGigsCalanderKeys;
@property (nonatomic,strong) NSMutableArray *imageFilesForAsyncDownload;


//test properties
@property (nonatomic,strong) NSArray *MusicDiaryObjectsSortedByDate;
@property (nonatomic,strong) NSMutableArray *MusicDiaryObjectsSortedArray;
@property (nonatomic,strong) JCMusicDiaryArtistObject *selectedObject;

@property (nonatomic,strong) NSSet *dateSet;
@property (nonatomic,strong) NSCalendar *calendar;


//UIElements
@property (nonatomic,strong) UIButton *searchButton;

//Classes
@property (nonatomic,strong) JCParseQuerys *JCParseQuerys;

@end

@implementation JCMusicDiaryVC{
    NSInteger monthIndex;
    BOOL IrelandDataLoaded;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myMusicDiary.backgroundColor =  [UIColor whiteColor];
    self.JCParseQuerys =                 [JCParseQuerys sharedInstance];
    self.calendar =                      [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    self.calendar.locale =               [NSLocale currentLocale];
    self.MusicDiaryObjectsSortedArray =  [[NSMutableArray alloc]init];
    self.MusicDiaryObjectsSortedByDate = [[NSMutableArray alloc]init];
    [self addCustomButtonOnNavBar];
    [self loadUpcomingGigs:YES];
    self.myMusicDiary.emptyDataSetDelegate = self;
    self.myMusicDiary.emptyDataSetSource = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    

}

-(NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self.MusicDiaryObjectsSortedArray[section]count];
}

-(NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
 
    return  [self.MusicDiaryObjectsSortedArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //JCMusicDiaryCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
   
    
    JCCustomCollectionCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"EventImageCell" forIndexPath:indexPath];

    if (!cell) {
        cell = [[JCCustomCollectionCell alloc] init];
    }
    
    
    NSArray *monthSection = [self.MusicDiaryObjectsSortedArray objectAtIndex:indexPath.section];
    
    JCMusicDiaryArtistObject *daryObject = [monthSection objectAtIndex:indexPath.row];
   
    PFObject *artist = daryObject.artist;
    
   
    if (daryObject.artistImage) {
  
        [cell stopLoadingAnimation];
        [cell setImage:daryObject.artistImage andArtistNamr:[artist objectForKey:JCArtistArtistName] andVenueName:nil];
        [cell addVinettLayer];

    }else{
        [cell startLoadingAnimation];
        //cell.backgroundColor = [UIColor lightGrayColor];
        cell.MainImageView.image = [UIImage imageNamed:@"loadingGreyPlane"];
        [cell removeVinettLayer];
        cell.CellTitle.text = @"";
        cell.venue.text = @"";
        
        [self DownloadImageForeventAtIndex:indexPath completion:^(UIImage* image, NSError* error) {
                if (!error) {
                    daryObject.artistImage = image;
                    [self.MusicDiaryObjectsSortedArray[indexPath.section]replaceObjectAtIndex:indexPath.row withObject:daryObject];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                      [self.myMusicDiary reloadItemsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]];
                     });

                 }else if (error){
                    NSLog(@"%@",error);
                }
                
            }];
        }
    return cell;
    
    
    
    
}


#pragma mark - UICollectionViewDelegate

- (UICollectionReusableView *)collectionView: (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    JCMusicDiaryHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
                                           UICollectionElementKindSectionHeader withReuseIdentifier:@"collectionViewHeader" forIndexPath:indexPath];
    NSArray *month = self.MusicDiaryObjectsSortedArray[indexPath.section];
    JCMusicDiaryArtistObject *day = month[indexPath.row];
    
    NSString *HreaderText = [NSString stringWithFormat:@"%@ - %ld",[self monthforindex:day.dateComponents.month],(long)day.dateComponents.year];
    
    [headerView setHeaderText:HreaderText];
    return headerView;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.myMusicDiary deselectItemAtIndexPath:indexPath animated:YES];
    NSArray *monthSection = [self.MusicDiaryObjectsSortedArray objectAtIndex:indexPath.section];
    JCMusicDiaryArtistObject *diaryObject = [monthSection objectAtIndex:indexPath.row];
    self.selectedObject = diaryObject;
    [self PerformNavigationToDetailedView];
    //[self performSegueWithIdentifier:@"ShowUpcomingGigs" sender:self];
    
}

-(void)PerformNavigationToDetailedView{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *myVC = (UINavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"NavConMusicDiaryDetailView"];
    JCGigsComingUpInThisMonthVC *DVC = [myVC viewControllers][0];
    DVC.diaryObject = self.selectedObject;
    DVC.IsIrishQuery = IrelandDataLoaded;
    [self presentViewController:myVC animated:YES completion:nil];
}

#pragma mark – UICollectionViewDelegateFlowLayout


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat cellLeg = ((self.myMusicDiary.frame.size.width/2)-1);
    return CGSizeMake(cellLeg,cellLeg);
}
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}



#pragma - Calender Helper Methods
- (NSDate *)dateWithFirstDayOfMonth:(NSDate *)date
{
    NSDateComponents *dateComponents = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    dateComponents.day = 1;
    return [self.calendar dateFromComponents:dateComponents];
}

         
#pragma - Helper Methods

//TODO add lazy initiation to the Mutable arrays so they are only initalised as they are needed
-(NSArray*)sortArrayInto2DArrayContaningYears:(NSArray*)ArrayToSort{


    
    NSMutableArray *TwentyFourteen = [[NSMutableArray alloc]init];
    NSMutableArray *TwentyFifeteen = [[NSMutableArray alloc]init];
    NSMutableArray *TwentySixteen = [[NSMutableArray alloc]init];
    NSMutableArray *TwentySeventeen = [[NSMutableArray alloc]init];
    NSMutableArray *TwentyEightteen = [[NSMutableArray alloc]init];
    NSMutableArray *TwentyNineteen = [[NSMutableArray alloc]init];
    NSMutableArray *TwentyTwenty = [[NSMutableArray alloc]init];
    NSMutableArray *TwentyTwentyOne = [[NSMutableArray alloc]init];
    NSMutableArray *ReturnArray = [[NSMutableArray alloc]init];
    
    
    for (JCMusicDiaryArtistObject *upcomingGigMusicDiaryObject in ArrayToSort) {
        
        
        switch (upcomingGigMusicDiaryObject.dateComponents.year) {
                
            case 2014:
                [TwentyFourteen addObject:upcomingGigMusicDiaryObject];
                break;
            case 2015:
                [TwentyFifeteen addObject:upcomingGigMusicDiaryObject];
                break;
            case 2016:
                [TwentySixteen addObject:upcomingGigMusicDiaryObject];
                break;
            case 2018:
                [TwentySeventeen addObject:upcomingGigMusicDiaryObject];
                break;
            case 2019:
                [TwentyEightteen addObject:upcomingGigMusicDiaryObject];
                break;
            case 2020:
                [TwentyNineteen addObject:upcomingGigMusicDiaryObject];
                break;
            case 2021:
                [TwentyTwenty addObject:upcomingGigMusicDiaryObject];
                break;
            case 2022:
                [TwentyTwentyOne addObject:upcomingGigMusicDiaryObject];
                break;
            default:
                NSLog(@"default");
                break;
         }
      }
    
    
    if ([TwentyFourteen count]!=0) {
        [ReturnArray addObject:TwentyFourteen];
    }
    if ([TwentyFifeteen count]!=0) {
        [ReturnArray addObject:TwentyFifeteen];
    }
    if ([TwentySixteen count]!=0) {
        [ReturnArray addObject:TwentySixteen];
    }
    if ([TwentySeventeen count]!=0) {
        [ReturnArray addObject:TwentySeventeen];
    }
    if ([TwentyEightteen count]!=0) {
        [ReturnArray addObject:TwentyEightteen];
    }
    if ([TwentyNineteen count]!=0) {
        [ReturnArray addObject:TwentyNineteen];
    }
    if ([TwentyTwenty count]!=0) {
        [ReturnArray addObject:TwentyTwenty];
    }
    if ([TwentyTwentyOne count]!=0) {
        [ReturnArray addObject:TwentyTwentyOne];
    }
    


    return ReturnArray;
};
-(NSArray*)sortArrayInto2DArrayContaningMonths:(NSArray*)ArrayToSort{
    

    
    NSMutableArray *January = [[NSMutableArray alloc]init];
    NSMutableArray *February = [[NSMutableArray alloc]init];
    NSMutableArray *March = [[NSMutableArray alloc]init];
    NSMutableArray *Aplri = [[NSMutableArray alloc]init];
    NSMutableArray *May = [[NSMutableArray alloc]init];
    NSMutableArray *June = [[NSMutableArray alloc]init];
    NSMutableArray *July = [[NSMutableArray alloc]init];
    NSMutableArray *August = [[NSMutableArray alloc]init];
    NSMutableArray *September = [[NSMutableArray alloc]init];
    NSMutableArray *October = [[NSMutableArray alloc]init];
    NSMutableArray *November = [[NSMutableArray alloc]init];
    NSMutableArray *December = [[NSMutableArray alloc]init];
    NSMutableArray *ReturntArray = [[NSMutableArray alloc]init];
    //.1 itterate through the results
    //.2 if month inxed = x - add it to array
    //.3 add dictionary with keys for the arrays
    
    for (JCMusicDiaryArtistObject *upComingGig in ArrayToSort) {
        switch (upComingGig.dateComponents.month) {
            case 1:
                [January addObject:upComingGig];
                break;
            case 2:
                [February addObject:upComingGig];
                break;
            case 3:
                [March addObject:upComingGig];
                break;
            case 4:
                [Aplri addObject:upComingGig];
                break;
            case 5:
                [May addObject:upComingGig];
                
                break;
            case 6:
                [June addObject:upComingGig];
                
                break;
            case 7:
                [July addObject:upComingGig];
                
                break;
            case 8:
                [August addObject:upComingGig];
                
                break;
            case 9:
                [September addObject:upComingGig];
                
                break;
            case 10:
                [October addObject:upComingGig];
                
                break;
            case 11:
                [November addObject:upComingGig];
                
                break;
            case 12:
                [December addObject:upComingGig];
                break;
            default:
                NSLog(@"default");
                break;
                
        }
    };
    
    
    if ([January count]!=0) {
        [ReturntArray addObject:January];
    }
    if ([February count]!=0) {
        [ReturntArray addObject:February];
    }
    if ([March count]!=0) {
        [ReturntArray addObject:March];
    }
    if ([Aplri count]!=0) {
        [ReturntArray addObject:Aplri];
    }
    if ([May count]!=0) {
        [ReturntArray addObject:May];
    }
    if ([June count]!=0) {
        [ReturntArray addObject:June];
    }
    if ([July count]!=0) {
        [ReturntArray addObject:July];
    }
    if ([August count]!=0) {
        [ReturntArray addObject:August];
    }
    if ([September count]!=0) {
        [ReturntArray addObject:September];
    }
    if ([October count]!=0) {
        [ReturntArray addObject:October];
    }
    if ([November count]!=0) {
        [ReturntArray addObject:November];
    }
    if ([December count]!=0) {
        [ReturntArray addObject:December];
    }
    

    return ReturntArray;
//    self.UpcomingGigsCalander = @{@"January":January,@"February":February,@"March":March,@"April":Aplri,@"May":May,@"June":June,@"July":July,@"August":August,@"September":September,@"October":October,@"November":November,@"December":December};
//    
//    //build a manual array of keys to make sure they are in the right order
//    self.UpcomingGigsCalanderKeys = @[@"January",@"February",@"March",@"April",@"May",@"June",@"July",@"August",@"September",@"October",@"November",@"December"];
};
-(void)DownloadImageForeventAtIndex:(NSIndexPath *)indexPath completion:(void (^)( UIImage *,NSError*)) completion {
             
    
     NSArray *monthSection = self.MusicDiaryObjectsSortedArray[indexPath.section];
            JCMusicDiaryArtistObject *diaryObject = monthSection[indexPath.row];
    
             // if we fetched already, just return it via the completion block
             UIImage *existingImage = diaryObject.artistImage;
             if (existingImage){
                 completion(existingImage, nil);
             }
    
    
    PFFile *artistimage = [diaryObject.artist objectForKey:@"atistImage"];
    [artistimage getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        
        UIImage *image = [UIImage imageWithData:data];
        
        if (error) {
            completion(nil,error);
        }else{
            
            completion(image,nil);
        }
        
    }];
    
}



-(void)emptyCollectionView{
    
    [self.MusicDiaryObjectsSortedArray removeAllObjects];
    [self.myMusicDiary reloadData];
}


-(void)loadUpcomingGigs:(BOOL)forIrelandOnly{
    

    if (forIrelandOnly) {
        IrelandDataLoaded = YES;
    }else{
        IrelandDataLoaded = NO;
    }
    
    
  [self.JCParseQuerys getMyAtritsUpComingGigs:forIrelandOnly comletionblock:^(NSError *error, NSMutableArray *response) {
    
      if (error) {
          NSLog(@"error getting artits gig music diary %@",error);
          
      }else{
          
          
          NSArray *twoDArraySortedYears = [self sortArrayInto2DArrayContaningYears:response];
          //Now that we have our year seperated sort each year array into months
          for (NSArray *year in twoDArraySortedYears) {
              NSArray *yearArraySortedintoMonths = [self sortArrayInto2DArrayContaningMonths:year];
              //finaly add the months to our
              [self.MusicDiaryObjectsSortedArray addObjectsFromArray:yearArraySortedintoMonths];
          }
          
          dispatch_async(dispatch_get_main_queue(), ^{
              [self.myMusicDiary reloadData];
          });
      }
   }];
}
   
-(NSString*)monthforindex:(int)monthindex{
    
    switch (monthindex) {
        case 1:
            return  @"January";
            break;
        case 2:
            return  @"February";
            break;
        case 3:
            return  @"March";
            break;
        case 4:
            return  @"April";
            break;
        case 5:
            return  @"May";
            
            break;
        case 6:
            return  @"June";
            
            break;
        case 7:
            return  @"July";
            
            break;
        case 8:
            return @"August";
            
            break;
        case 9:
            return @"September";
            
            break;
        case 10:
            return  @"October";
            
            break;
        case 11:
            return @"November";
            
            break;
        case 12:
            return @"December";
            break;
        default:
            NSLog(@"default");
            break;
            
    }
    
    NSLog(@"month index fail");
    return nil;
    
}

- (void)addCustomButtonOnNavBar
{
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [menuButton setImage:[UIImage imageNamed:@"iconMenu.png"] forState:UIControlStateNormal];
    //[menuButton setImage:[UIImage imageNamed:@"iconMenu.png"] forState:UIControlStateHighlighted];
    menuButton.adjustsImageWhenDisabled = NO;
    //set the frame of the button to the size of the image (see note below)
    menuButton.frame = CGRectMake(0, 0, 40, 40);
    menuButton.opaque = YES;
    
    [menuButton addTarget:self action:@selector(menuButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    //create a UIBarButtonItem with the button as a custom view
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    self.navigationItem.leftBarButtonItem = customBarItem;
    
    
    
    self.searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.searchButton setImage:[UIImage imageNamed:@"iconIre.png"] forState:UIControlStateNormal];
    self.searchButton.adjustsImageWhenDisabled = NO;
    self.searchButton.frame = CGRectMake(0, 0, 42, 42);
    
    [self.searchButton addTarget:self action:@selector(IrelandUkManager) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *searchbarbutton = [[UIBarButtonItem alloc] initWithCustomView:self.searchButton];
    
    self.navigationItem.rightBarButtonItem = searchbarbutton;
    self.navigationItem.hidesBackButton = YES;
    
}

-(void)IrelandUkManager {
    
    if (IrelandDataLoaded) {
        [self emptyCollectionView];
        [self.searchButton setImage:[UIImage imageNamed:@"iconUK.png"] forState:UIControlStateNormal];

        [self loadUpcomingGigs:NO];
    }else{
        [self emptyCollectionView];
        [self.searchButton setImage:[UIImage imageNamed:@"iconIre.png"] forState:UIControlStateNormal];

        [self loadUpcomingGigs:YES];
    }
}
-(void)menuButtonPressed{
[self.sideMenuViewController presentLeftMenuViewController];
}


#pragma mark - Navigation
 
// // In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//     
//     JCGigsComingUpInThisMonthVC *dvc = (JCGigsComingUpInThisMonthVC*)segue.destinationViewController;
//     dvc.diaryObject = self.selectedObject;
//     dvc.IsIrishQuery = IrelandDataLoaded;
//}


-(CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath: @"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0)];
    animation.duration = 0.25;
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    return animation;
}

-(NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    
    NSString *text = @"Build a personal gig diary";
    
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

-(NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"We automatically add your artist's upcoming Irish gigs to your gig diary, so go follow some artist! ";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}























@end
