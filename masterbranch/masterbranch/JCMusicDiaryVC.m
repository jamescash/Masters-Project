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
@property (nonatomic,strong) NSMutableArray *MusicDiaryObjectsSortedArray;

@property (nonatomic,strong) NSSet *dateSet;
@property (nonatomic,strong) NSCalendar *calendar;

//UIElements
- (IBAction)IrelandWorld:(id)sender;


//Classes
@property (nonatomic,strong) JCParseQuerys *JCParseQuerys;

@end

@implementation JCMusicDiaryVC{
    NSInteger monthIndex;
    BOOL IrelandDataLoaded;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myMusicDiary.backgroundColor = [UIColor whiteColor];
    self.JCParseQuerys = [JCParseQuerys sharedInstance];
    self.calendar =                             [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    self.calendar.locale =                      [NSLocale currentLocale];
    self.MusicDiaryObjectsSortedArray =       [[NSMutableArray alloc]init];
    self.MusicDiaryObjectsSortedByDate =        [[NSMutableArray alloc]init];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadUpcomingGigs:YES];
    
    

}

-(NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self.MusicDiaryObjectsSortedArray[section]count];
}

-(NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
 
    return  [self.MusicDiaryObjectsSortedArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JCMusicDiaryCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
   
    NSArray *monthSection = [self.MusicDiaryObjectsSortedArray objectAtIndex:indexPath.section];
    
    JCMusicDiaryObject *objectForCellAtIndex = [monthSection objectAtIndex:indexPath.row];
    PFObject *currentGig = objectForCellAtIndex.UpcomingGigObject;
    
    NSString *dayIndex = [NSString stringWithFormat:@"%ld",(long)objectForCellAtIndex.dateComponents.day];
    
    if (objectForCellAtIndex.artistImage) {
        cell.backRoundImage.image = objectForCellAtIndex.artistImage;
    }else{
        cell.backRoundImage.image = [UIImage imageNamed:@"Placeholder.png"];
        
        //dispatch_async(imageLoad, ^{
        
            
            [self DownloadImageForeventAtIndex:indexPath completion:^(UIImage* image, NSError* error) {
                if (!error) {
                    objectForCellAtIndex.artistImage = image;
                    [self.MusicDiaryObjectsSortedArray[indexPath.section]replaceObjectAtIndex:indexPath.row withObject:objectForCellAtIndex];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                      [self.myMusicDiary reloadItemsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]];
                     });

                 }else if (error){
                    NSLog(@"%@",error);
                }
                
            }];
        
        //});

       
        
        
    }
    
    
    cell.monthIndex.text = dayIndex;
    cell.artistName.text = [currentGig objectForKey:@"artistName"];
    //cell.backroundImage.image = @"";
    return cell;
}


#pragma mark - UICollectionViewDelegate

- (UICollectionReusableView *)collectionView: (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    JCMusicDiaryHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:
                                           UICollectionElementKindSectionHeader withReuseIdentifier:@"collectionViewHeader" forIndexPath:indexPath];
    NSArray *month = self.MusicDiaryObjectsSortedArray[indexPath.section];
    JCMusicDiaryObject *day = month[indexPath.row];
    
    NSString *HreaderText = [NSString stringWithFormat:@"%ld ,%ld",(long)day.dateComponents.month,(long)day.dateComponents.year];
    
    [headerView setHeaderText:HreaderText];
    return headerView;
}
#pragma mark – UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat cellLeg = ((self.myMusicDiary.frame.size.width/3)-1);
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

-(void)DownloadImageForeventAtIndex:(NSIndexPath *)indexPath completion:(void (^)( UIImage *,NSError*)) completion {
             
    
    
            NSArray *monthSection = self.MusicDiaryObjectsSortedArray[indexPath.section];
            JCMusicDiaryObject *diaryObject = monthSection[indexPath.row];
    
             // if we fetched already, just return it via the completion block
             UIImage *existingImage = diaryObject.artistImage;
             if (existingImage){
                 completion(existingImage, nil);
             }
             
    
    [self.JCParseQuerys DownloadImageForArtist:[diaryObject.UpcomingGigObject objectForKey:@"artistName"] completionBlock:^(NSError *error, UIImage *image) {
        
        if (error) {
            
            completion(nil,error);
         }else{

             completion(image,nil);
            }
   }];

    
}






- (IBAction)IrelandWorld:(id)sender {
    
    if (IrelandDataLoaded) {
        [self emptyCollectionView];
        [self loadUpcomingGigs:NO];
    }else{
        [self emptyCollectionView];
        [self loadUpcomingGigs:YES];
    }
}


-(void)emptyCollectionView{
    
    [self.MusicDiaryObjectsSortedArray removeAllObjects];
    [self.myMusicDiary reloadData];
}


-(void)loadUpcomingGigs: (BOOL)forIrelandOnly{
    

    if (forIrelandOnly) {
        IrelandDataLoaded = YES;
    }else{
        IrelandDataLoaded = NO;
    }
    
    
[self.JCParseQuerys getMyAtritsUpComingGigs:forIrelandOnly comletionblock:^(NSError *error, NSMutableArray *response) {
    
    
         //self.MusicDiaryObjectsSortedArray = nil;

            NSMutableArray *MusicDiaryObjectsUnsorted = [[NSMutableArray alloc]init];
            
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-LL-dd HH:mm:ss"];
            
            
            
            for (PFObject *upComingGig in response) {
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
            
            //Sort the array by the date of upcoming gig.
            NSSortDescriptor *sortDescriptor;
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"UpcomingGigDate"
                                                         ascending:YES];
            NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
            NSArray *MusicDiaryObjectsSortedByDate = [[NSMutableArray alloc]init];
            MusicDiaryObjectsSortedByDate = [MusicDiaryObjectsUnsorted sortedArrayUsingDescriptors:sortDescriptors];
            
            //Then sort the array into years
            NSArray *twoDArraySortedYears = [self sortArrayInto2DArrayContaningYears:MusicDiaryObjectsSortedByDate];
    
            //Data is good untill here
    
            //Now that we have our year seperated sort each year array into months
            for (NSArray *year in twoDArraySortedYears) {
                NSArray *yearArraySortedintoMonths = [self sortArrayInto2DArrayContaningMonths:year];
                //finaly add the months to our
                [self.MusicDiaryObjectsSortedArray addObjectsFromArray:yearArraySortedintoMonths];
                
            }
            
            //IrelandDataLoaded = YES;
    
    
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.myMusicDiary reloadData];
            });
            
        }];
        
    
}
































@end
