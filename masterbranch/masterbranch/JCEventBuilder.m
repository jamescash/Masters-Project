//
//  JCEventBuilder.m
//  masterbranch
//
//  Created by james cash on 05/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "JCEventBuilder.h"

@interface JCEventBuilder ()

@property (nonatomic,strong) NSMutableArray *happeningNow;
@property (nonatomic,strong) NSMutableArray *happeningLater;
//@property (nonatomic,strong) NSMutableArray *happenedLastNight;

@end

@implementation JCEventBuilder{
    NSArray *countysInIreland;
    EventObjectParser *formatter;
    int counterForRunningDeligation;
    NSDictionary *collectionViewData;
};


//make sure this class is a sinleton so all major downloads only happen once at launch
+ (JCEventBuilder*)sharedInstance
{
    // 1
    static JCEventBuilder *_sharedInstance = nil;
    
    // 2
    static dispatch_once_t oncePredicate;
    
    //Use Grand Central Dispatch (GCD) to execute a block which initializes an instance of LibraryAPI. This is the essence of the Singleton design pattern: the initializer is never called again once the class has been instantiated.
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[JCEventBuilder alloc] init];
    });
    return _sharedInstance;
}



- (id)init
{
    self = [super init];
    if (self) {
      
        counterForRunningDeligation = 0;
        countysInIreland = [[NSArray alloc]init];
        formatter = [[EventObjectParser alloc]init];
        //_happenedLastNight = [[NSMutableArray alloc]init]; //removing events that happened last night due to API rate limit
        _happeningLater = [[NSMutableArray alloc]init];
        _happeningNow = [[NSMutableArray alloc]init];
        
  
        
        countysInIreland = @[@"Dublin,Ireland",@"Cork,Ireland",@"Galway,Ireland",@"Belfast,United+Kingdom",@"Kildare,Ireland",@"Carlow,Ireland",@"Kilkenny,Ireland",
                             @"Donegal,Ireland",@"Mayo,Ireland",@"Sligo,Ireland",@"Derry,Ireland",@"Cavan,Ireland",@"Leitrim,Ireland",@"Monaghan,Ireland"
                             ,@"Louth,Ireland",@"Roscommon,Ireland",@"Longford,Ireland",@"Claregalway,Ireland",@"Tipperary,Ireland",@"Limerick,Ireland",@"Wexford,Ireland",@"Waterford,Ireland",@"Kerrykeel,Ireland"];
      
        //countysInIreland = @[@"Dublin,Ireland"];
        
        NSDate *now = [NSDate date];
        NSString *todaysDate = [formatter formatDateForAPIcall:now];
        //NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow: -(60.0f*60.0f*24.0f)];
        //NSString *yesterdaysDate = [formatter formatDateForAPIcall:yesterday];
        //NSArray *dates = @[todaysDate,yesterdaysDate];
        
       
        //for (NSString *theDate in dates) {
            
            for (NSString *countyName in countysInIreland) {
               [self GetEventJSON:countyName dateObject:todaysDate];
            }
       // };
        
    }
    return self;
}

-(void)GetEventJSON: (NSString*)countyName dateObject:(NSString*)date {
    
    //connet to the BandsinTown API get all events from the area on todays date
    NSString *endpoint = [NSString stringWithFormat:@"https://api.bandsintown.com/events/search.json?api_version=2.0&app_id=preamp&date=%@,%@&location=%@",date,date,countyName];
    
    NSURL *url = [NSURL URLWithString:endpoint];
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            NSLog(@"api call didnt work to bandsintown with %@",error);
            counterForRunningDeligation ++;
            [self considerRunningDeligation];
            return;

            
        }else {
            
            NSArray *JSONresults = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
         
        
            if ([JSONresults count]== 0 ) {
                counterForRunningDeligation ++;
                [self considerRunningDeligation];
                return;
            
            } else if ([JSONresults count] == 1) {
                
                //this is a work around I had to do to fix a bug that was cuasing a crash
                NSDictionary *errorCheking = [self indexKeyedDictionaryFromArray:JSONresults];
                if ([[errorCheking objectForKey:@"objectOne"] isEqual: @"errors"]) {
                    NSLog(@"Unknown Event Object");
                    counterForRunningDeligation ++;
                    [self considerRunningDeligation];
                    return;
                }
                
            }
            
            
            if ([JSONresults count] > 0) {
                //TODO BAD_ACCESS  CODE 1 CRASH
               [JSONresults  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    
                    eventObject *event = [[eventObject alloc]initWithTitle:obj];
                    if (event != nil){
                        
                        {
                        //Removing already happened gigs from our app due to API rate limit
//                    if ([event.status isEqualToString:@"alreadyHappened"]) {
//                       //TODO uncomment this, its commented just for testing
//                      [self.happenedLastNight addObject:event];
//                    }
                        }
                        
                    if ([event.status isEqualToString:@"happeningLater"]) {
                        [self.happeningLater addObject:event];
                      }
                        
                    if ([event.status isEqualToString:@"currentlyhappening"]) {
                        [self.happeningNow addObject:event];
                       }
                    
                     }
               }];//end of enum using block loop
               
                 counterForRunningDeligation ++;
                [self considerRunningDeligation];
           
            }//end of statment where JSON is parsed
       
       }//end of statment where JSON is parsed
        
  }];//end of NSURL send asyn request
    
};//end of GetEvntJSON





- (NSDictionary*)getEvent
{
   return collectionViewData;
}

- (NSDictionary *) indexKeyedDictionaryFromArray:(NSArray *)array
{
    id objectInstance;
    NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
    for (objectInstance in array)
        [mutableDictionary setObject:objectInstance forKey:@"objectOne"];
    
    return mutableDictionary;
}

-(void)considerRunningDeligation{
    
    if (counterForRunningDeligation == [countysInIreland count]) {
        
        NSArray *FilteredHappeningLater = [self RemoveDuplicatsfromArray:self.happeningLater];
        NSArray *FilteredHappeninfNow = [self RemoveDuplicatsfromArray:self.happeningNow];
        
        collectionViewData = @{@"Curently Happening":FilteredHappeninfNow,@"Coming up Tonight":FilteredHappeningLater};
        
        [self.delegate LoadMapView];
    }
};

-(NSArray*)RemoveDuplicatsfromArray: (NSMutableArray*) originalArray{
    

    NSMutableSet *existingNames = [NSMutableSet set];
    NSMutableArray *filteredArray = [NSMutableArray array];
    for (id object in originalArray) {
        if (![existingNames containsObject:[object venueName]]) {
            [existingNames addObject:[object venueName]];
            [filteredArray addObject:object];
        }
    }

    return filteredArray;

};


@end
