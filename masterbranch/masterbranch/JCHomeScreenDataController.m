//
//  JCHomeScreenDataController.m
//  PreAmp
//
//  Created by james cash on 15/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCHomeScreenDataController.h"
#import <AFNetworking/AFNetworking.h>
#import "EventObjectParser.h"
#import "eventObject.h"
#import "JCConstants.h"

@interface JCHomeScreenDataController ()

@property (nonatomic,strong) NSString *bandsInTownEventEndPoint;
@property (nonatomic,strong) NSString *bandsInTownArtistUpcomingGigEndPoint;

@property (nonatomic,strong) NSMutableArray *happeningLater;


@end

@implementation JCHomeScreenDataController{
    int switchCounter;

}



- (instancetype)init
{
    self = [super init];
    if (self) {
        self.bandsInTownEventEndPoint = @"http://api.bandsintown.com/events/search.json?api_version=2.0&app_id=preamp";
        self.bandsInTownArtistUpcomingGigEndPoint = @"http://api.bandsintown.com/artists/";
    }
    return self;
}

#pragma - Bandsintown
-(void)getEventsforDate:(NSDate *)date usingLocation:(NSString *)latitude Longditude:(NSString *)longditude competionBlock:(void (^)(NSError *, NSArray *))finishedGettingMyAtrits{
    

    
    NSString *FormattedNSDateToString = [self formatDateForAPIcall:date];
    NSString *dateSectionForAPICall = [NSString stringWithFormat:@"&date=%@,%@",FormattedNSDateToString,FormattedNSDateToString];
    NSString *locationSectionForAPICall = [NSString stringWithFormat:@"&location=%@,%@",latitude,longditude];
    NSString *radiusSectionForAPICall = [NSString stringWithFormat:@"&radius=50"];
    NSString *endpoint = [NSString stringWithFormat:@"%@%@%@%@",self.bandsInTownEventEndPoint,dateSectionForAPICall,locationSectionForAPICall,radiusSectionForAPICall];
    
    
    AFHTTPRequestOperationManager *bandsInTownGigRequest = [AFHTTPRequestOperationManager manager];
    [bandsInTownGigRequest GET:endpoint parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
        //TODO add error handeling for the reciver of the completion block here and in function bellow
        
        
        NSMutableArray *arrayOfParsedEvents = [[NSMutableArray alloc]init];
        
        [responseObject  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            eventObject *event = [[eventObject alloc]initWithTitle:obj];
            if (event != nil){
                [arrayOfParsedEvents addObject:event];
             }
         }];//end of enum using block loop
        
        finishedGettingMyAtrits(nil,arrayOfParsedEvents);
        
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        finishedGettingMyAtrits(error,nil);
    }];
    
    
   
    
}

//http://api.bandsintown.com/artists/"+encodedArtistName+"/events.json?artist_id=mbid_&api_version=2.0&app_id=PreAmp

-(void)getUpcomingGigsForArtist:(NSString *)artist competionBlock:(void (^)(NSError *, NSArray *))finishedGettingUpcomingGigs{
    

    NSString *artistNameEncodedForWeb = [artist stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    
    NSString *upcomingGigsEndSectionForAPICall = @"/events.json?artist_id=mbid_&api_version=2.0&app_id=PreAmp";
    NSString *endpoint = [NSString stringWithFormat:@"%@%@%@",self.bandsInTownArtistUpcomingGigEndPoint,artistNameEncodedForWeb,upcomingGigsEndSectionForAPICall];
    
    AFHTTPRequestOperationManager *bandsInTownGigRequest = [AFHTTPRequestOperationManager manager];
    [bandsInTownGigRequest GET:endpoint parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        

        
        NSMutableArray *arrayOfParsedEvents = [[NSMutableArray alloc]init];
        
        [responseObject  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            eventObject *event = [[eventObject alloc]initWithTitle:obj];
            if (event != nil){
                
                [arrayOfParsedEvents addObject:event];
            }
        }];//end of enum using block loop
        
        finishedGettingUpcomingGigs(nil,arrayOfParsedEvents);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        finishedGettingUpcomingGigs(error,nil);
    }];
    
    
    
    
}

-(void)getArtistUpComingEventsForArtistSearch:(NSString*)artistname andMbidNumber:(NSString*)mbidNumber competionBlock:(void(^)(NSError* error,NSDictionary* results))finishedGettingSearchResults{
    
    NSString *endpoint = [NSString stringWithFormat:@"http://api.bandsintown.com/artists/%@/events.json?artist_id=mbid_%@&api_version=2.0&app_id=PreAmp",artistname,mbidNumber];
    
    NSURL *url = [NSURL URLWithString:endpoint];
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            finishedGettingSearchResults(error,nil);
        }else{
            
            NSArray *JSONresults = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            
            if ([JSONresults count]== 0 ) {
                NSDictionary *results = @{JCSeachPageResultsDicResults:JCSeachPageResultsDicNoUpcomingGigs};
                finishedGettingSearchResults(nil,results);
                return;
            }
            
            else if ([JSONresults count] == 1) {
                
                //this is a work around I had to do to fix a bug that was cuasing a crash
                //If the api did not know the aritst it returns a dictionary with one error key
                //if i did know the artist it returns an Array/ and so I have to check array that have a count
                //of one to make sure its not an error and in order to do that I have to convert to a dictionary
                //becuse all results are cast to an ARRAY
                NSDictionary *errorCheking = [self indexKeyedDictionaryFromArray:JSONresults];
                if ([[errorCheking objectForKey:@"objectOne"] isEqual: @"errors"]) {
                    NSDictionary *results = @{JCSeachPageResultsDicResults:JCSeachPageResultsDicResultsArtistUnknown};
                    finishedGettingSearchResults(nil,results);
                    return;
                }
                
            }
            
            if ([JSONresults count]>0) {
                
                NSMutableArray *fullArrayOfSearchResults = [[NSMutableArray alloc]init];
                
                [JSONresults  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    //create event objects from the JSON results
                    eventObject *event = [[eventObject alloc]initWithTitle:obj];
                    
                    if (event != nil){
                        //cheack to so if we didnt kill that event object in any other class's
                        //then add it to the array
                        [fullArrayOfSearchResults addObject:event];
                    }
                }];
                
                NSMutableArray *resultesOrderedByUpcomingData = [[NSMutableArray alloc]init];
                
                [resultesOrderedByUpcomingData addObjectsFromArray:fullArrayOfSearchResults];
                
                
                //sort the results in distance from irlenad
                NSSortDescriptor *sortInDistanceFromIreland;
                sortInDistanceFromIreland = [[NSSortDescriptor alloc] initWithKey:@"DistanceFromIreland"
                                                                        ascending:YES];
                NSArray *sortDescriptors = [NSArray arrayWithObject:sortInDistanceFromIreland];
                NSArray *SearchResultsSortedInDistanceFromIreland;
                SearchResultsSortedInDistanceFromIreland = [resultesOrderedByUpcomingData sortedArrayUsingDescriptors:sortDescriptors];
                
                // put them into a mutable array so they can be eddited
                NSMutableArray *searchResultsSortedDistanceFromIrelandInMutableArry = [[NSMutableArray alloc]init];
                [searchResultsSortedDistanceFromIrelandInMutableArry addObjectsFromArray:SearchResultsSortedInDistanceFromIreland];
                
                
                NSMutableArray *InIreland = [[NSMutableArray alloc]init];
                
                //switchCounter = 0;
                
                
                //Find all the gigs that are in Irelnad add them to there own array
                for (eventObject *obj in searchResultsSortedDistanceFromIrelandInMutableArry) {
                    
                    if ([obj.country isEqualToString:@"Ireland"]) {
                        
                        [InIreland addObject:obj];
                    }
                 };
                
                //remove Irish gigs from array before it goes for more sorting
                 [searchResultsSortedDistanceFromIrelandInMutableArry removeObjectsInArray:InIreland];
                NSMutableArray *EmptyArray = [[NSMutableArray alloc]init];
                
                NSDictionary *reultsSortedIndistanceFromIreland = @{@"In Ireland":InIreland,@"Around Ireland":searchResultsSortedDistanceFromIrelandInMutableArry,@"Blank Section":EmptyArray};
                
                NSDictionary *resultsSortdedByUpcmoingDate = @{@"Sorted by date":resultesOrderedByUpcomingData,@"Blank Section":EmptyArray};
                 //2D Array sorted with Irish gigs ontop and second array with gig ordered by distance from Irlenad
                 //[searchResultsSortedDistanceFromIrelandInMutableArry insertObject:InIreland atIndex:0];
               
                NSDictionary *results = @{ JCSeachPageResultsDicResults:@{JCSeachPageResultsDicResultsSortedDistanceFromIreland:reultsSortedIndistanceFromIreland,JCSeachPageResultsDicResultsSortedOrderOfUpcmoingDate:resultsSortdedByUpcmoingDate}};
               
                finishedGettingSearchResults(nil,results);
                
            }
            
            
        }
        
    }];

    
    
}

#pragma - Echo Nest

-(void)getmbidNumberfor:(NSString*)artistname competionBlock:(void(^)(NSError* error,NSString * mbid))finishedGettingMbid{
    
    //cheack to see if I can find a mbid for the artist name becuse If i can im more likely to be able to find an artist image
    
    NSString *endpoint = [NSString stringWithFormat:@"http://developer.echonest.com/api/v4/artist/search?api_key=VLWOTTE5BDW9KEQEK&format=json&name=%@&bucket=id:musicbrainz&results=1&limit=true",artistname];
    
    NSURL *url = [NSURL URLWithString:endpoint];
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            finishedGettingMbid(error,nil);
        } else {
            
            NSDictionary *echoNestResults = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            NSDictionary *reponse = echoNestResults[@"response"];
            NSArray *artist = reponse[@"artists"];
            
            
            //if no mbid number just search by artist name
            if ([artist count]==0 ) {
                NSLog(@"No mbid found for that artist");
                finishedGettingMbid(nil,nil);
            }else{
                
                NSDictionary *artisthammerdown = artist[0];
                NSArray *foreign_ids = artisthammerdown[@"foreign_ids"];
                NSDictionary *foreign_idsHammerdown = foreign_ids[0];
                NSString *foreign_id = foreign_idsHammerdown[@"foreign_id"];
                NSString *mbid = [foreign_id stringByReplacingOccurrencesOfString:@"musicbrainz:artist:" withString:@""];
                finishedGettingMbid(nil,mbid);
                
            }
            
        }
        
    }];
    
    
}


-(NSString*)formatDateForAPIcall:(NSDate*)date{
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    [dateFormat setDateFormat:@"yyyy-LL-dd"];
    
    NSString *formattedDate = [dateFormat stringFromDate:date];
    
    return formattedDate;
};

#pragma - Helper Method

- (NSDictionary *) indexKeyedDictionaryFromArray:(NSArray *)array
{
    //this is a bug fix
    id objectInstance;
    NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
    for (objectInstance in array)
        [mutableDictionary setObject:objectInstance forKey:@"objectOne"];
    
    return mutableDictionary;
}


@end
