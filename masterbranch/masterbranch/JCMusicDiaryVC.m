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





@interface JCMusicDiaryVC ()
//properties
@property (weak, nonatomic) IBOutlet UICollectionView *myMusicDiary;
@property (nonatomic,strong) NSDictionary *UpcomingGigsCalander;
@property (nonatomic,strong) NSArray *UpcomingGigsCalanderKeys;
@property (nonatomic,strong) NSMutableArray *imageFilesForAsyncDownload;


//test properties
@property (nonatomic,strong) NSArray *MusicDiaryObjectsSortedByDate;
@property (nonatomic,strong) NSMutableArray *MusicDiaryObjects3DSortedArray;

@property (nonatomic,strong) NSSet *dateSet;
@property (nonatomic,strong) NSCalendar *calendar;



//Classes
@property (nonatomic,strong) JCParseQuerys *JCParseQuerys;

@end

@implementation JCMusicDiaryVC{
    NSInteger monthIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.JCParseQuerys = [JCParseQuerys sharedInstance];
    
    //Get upcoming gigs and store them in our data model
    [self.JCParseQuerys getMyAtritsUpComingGigs:^(NSError *error, NSMutableArray *response) {
    self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    self.calendar.locale = [NSLocale currentLocale];
    self.MusicDiaryObjects3DSortedArray = [[NSMutableArray alloc]init];
    NSMutableArray *MusicDiaryObjectsUnsorted = [[NSMutableArray alloc]init];
    self.MusicDiaryObjectsSortedByDate = [[NSMutableArray alloc]init];
        
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-LL-dd HH:mm:ss"];
       
        
        
    for (PFObject *upComingGig in response) {
            //make the NSDate First
            NSString *objectdate = [upComingGig objectForKey:@"datetime"];
            NSString *dateformatted = [objectdate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
            NSDate *date = [dateFormat dateFromString:dateformatted];
            NSCalendar *calendar = [NSCalendar currentCalendar];
            unsigned unitFlags = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
            NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:date];
            NSDate *FormattedDate = [calendar dateFromComponents:dateComponents];
            
        //Then Creat The Music Diary Object
        JCMusicDiaryObject *MusicDiaryObject = [[JCMusicDiaryObject alloc]initWithEvent:FormattedDate andDateComponents:dateComponents andGigObject:upComingGig];
        [MusicDiaryObjectsUnsorted addObject:MusicDiaryObject];
       
    }
        
     
        NSSortDescriptor *sortDescriptor;
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"UpcomingGigDate"
                                                     ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        self.MusicDiaryObjectsSortedByDate = [MusicDiaryObjectsUnsorted sortedArrayUsingDescriptors:sortDescriptors];

        
        NSArray *twoDArraySortedYears = [self sortArrayInto2DArrayContaningYears:self.MusicDiaryObjectsSortedByDate];
        
        
        for (NSArray *year in twoDArraySortedYears) {
            
           NSArray *yearArraySortedintoMonths = [self sortArrayInto2DArrayContaningMonths:year];
           
         [self.MusicDiaryObjects3DSortedArray addObjectsFromArray:yearArraySortedintoMonths];
        
        
        }
        
            
        
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.myMusicDiary reloadData];
                });
   
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    

   // int numberOfitemsinSection = 2;
    //int numberOfMonthsinEachYearTracker;
    //int numberOfitemsinSection = 3;
    //int i = 1;

    
//       if (([self.MusicDiaryObjects3DSortedArray[0]count]-1) < section) {
//            numberOfMonthsinEachYearTracker = (numberOfMonthsinEachYearTracker+([self.MusicDiaryObjects3DSortedArray[i]count]-1));
//           
//           if((([self.MusicDiaryObjects3DSortedArray[1]count]-1)+numberOfMonthsinEachYearTracker) > section ) {
//            return [self.MusicDiaryObjects3DSortedArray[1][section-numberOfMonthsinEachYearTracker]count];
//               
//           }
//           
//         
//        }else if (([self.MusicDiaryObjects3DSortedArray[0]count]-1)>section) {
//            return [self.MusicDiaryObjects3DSortedArray[i][section]count];
//        }
//
    
    
    return [self.MusicDiaryObjects3DSortedArray[section]count];

}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    //Number of sections is = to the number of months from the first upcoming gig to the last upcoming gig.
    //JCMusicDiaryObject *FirstMusicDiaryObject = [self.MusicDiaryObjectsSortedByDate objectAtIndex:0];
   /// NSDate *formDate = [self dateWithFirstDayOfMonth:FirstMusicDiaryObject.UpcomingGigDate];
    //JCMusicDiaryObject *lastMusicDiaryObject = [self.MusicDiaryObjectsSortedByDate lastObject];
    //NSDate *toDate = [self dateWithFirstDayOfMonth:lastMusicDiaryObject.UpcomingGigDate];
    
//    int numberOfSections = 5;
//
//    for (int i = 0; i<[self.MusicDiaryObjects3DSortedArray count]; i++) {
//        
//        numberOfSections = numberOfSections + [self.MusicDiaryObjects3DSortedArray[i] count];
//        
//    }
    
    return  [self.MusicDiaryObjects3DSortedArray count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JCMusicDiaryCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
   
    NSArray *monthSection = [self.MusicDiaryObjects3DSortedArray objectAtIndex:indexPath.section];
    
    JCMusicDiaryObject *objectForCellAtIndex = [monthSection objectAtIndex:indexPath.row];
    
    PFObject *currentGig = objectForCellAtIndex.UpcomingGigObject;
    
    NSString *themonthIndex = [NSString stringWithFormat:@"%d",objectForCellAtIndex.dateComponents.day];
    cell.monthIndex.text = themonthIndex;
    cell.artistName.text = [currentGig objectForKey:@"artistName"];
    //cell.backroundImage.image = @"";
    return cell;
}


#pragma mark - UICollectionViewDelegate

- (UICollectionReusableView *)collectionView: (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    JCMusicDiaryHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
                                           UICollectionElementKindSectionHeader withReuseIdentifier:@"collectionViewHeader" forIndexPath:indexPath];
    NSArray *month = self.MusicDiaryObjects3DSortedArray[indexPath.section];
    JCMusicDiaryObject *day = month[indexPath.row];
    
    NSString *HreaderText = [NSString stringWithFormat:@"%d ,%d",day.dateComponents.day,day.dateComponents.year];
    
    [headerView setHeaderText:HreaderText];
    return headerView;
}


#pragma mark – UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat cellLeg = ((self.myMusicDiary.frame.size.width-20)/3);
    return CGSizeMake(cellLeg,cellLeg);
}
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(5, 0, 0, 0);
}


#pragma - Calender Helper Methods 

- (NSDate *)dateWithFirstDayOfMonth:(NSDate *)date
{
    NSDateComponents *dateComponents = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    dateComponents.day = 1;
    return [self.calendar dateFromComponents:dateComponents];
}



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
    
    
    for (JCMusicDiaryObject *upcomingGigMusicDiaryObject in ArrayToSort) {
        
        
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
    
    for (JCMusicDiaryObject *upComingGig in ArrayToSort) {
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

@end
