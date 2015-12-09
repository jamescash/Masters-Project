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
#import "JCSearchResultsObject.h"

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
    
    //get gigs around the users current location on a certain date

    
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
    
    //1. search BIT for artist upcoming gigs
    //2. Determain if result is No Upcoming Unkown or Has Upcoming
    //3. Sort the upcoming gigs into - Gigs in Irelnad/Gigs Near Ireland/Other gigs
    
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
                
                //Using blocks to enum the list of results and build eventObjects
                
                [JSONresults  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    //create event objects from the JSON results
                    eventObject *event = [[eventObject alloc]initWithTitle:obj];
                    
                    if (event != nil){
                        //cheack to so if we didnt kill that event object in any other class's
                        //then add it to the array
                        [fullArrayOfSearchResults addObject:event];
                    }
                }];
                
                //See eventObject to see how we determin if gigs is in Irl vs Near Ire
                NSMutableArray *tourDatesInIrelnad = [[NSMutableArray alloc]init];
                NSMutableArray *tourDatesNearIrelnad = [[NSMutableArray alloc]init];
                NSMutableArray *OtherTourDates = [[NSMutableArray alloc]init];

                //Sort results
                for (eventObject *upcomingGig in fullArrayOfSearchResults) {
                    
                    if (upcomingGig.isInIreland) {
                        [tourDatesInIrelnad addObject:upcomingGig];
                    }else if (upcomingGig.isNearIreland){
                        [tourDatesNearIrelnad addObject:upcomingGig];
                    }else{
                        [OtherTourDates addObject:upcomingGig];
                    }
                 }
                tourDatesInIrelnad = [self sortArrayByUpcomingDate:tourDatesInIrelnad];
                tourDatesNearIrelnad = [self sortArrayByUpcomingDate:tourDatesNearIrelnad];
                OtherTourDates = [self sortArrayByUpcomingDate:OtherTourDates];
    
                NSMutableDictionary *sortedResultsDic = [[NSMutableDictionary alloc]init];
                    [sortedResultsDic setObject:tourDatesInIrelnad forKey:JCSeachPageResultsDicResultsInIreland];
                if ([tourDatesNearIrelnad count]!= 0) {
                    [sortedResultsDic setObject:tourDatesNearIrelnad forKey:JCSeachPageResultsDicResultsNearIreland];
                }
                    [sortedResultsDic setObject:OtherTourDates forKey:JCSeachPageResultsDicResultsOtherTourDates];
                //Return the array in a a dictionary
                NSDictionary *results = @{ JCSeachPageResultsDicResults:sortedResultsDic};
                finishedGettingSearchResults(nil,results);
            }
            
            
        }
        
    }];

    
    
}


//badly named method actully used to get all infomation about an artist from the artist name
-(void)getArtistImage:(NSString*)artistname andMbidNumber:(NSString*)mbidNumber competionBlock:(void(^)(NSError* error,NSDictionary *artistInfo))finishedGettingArtistImage{
    
    
    NSString *endpoint = [NSString stringWithFormat:@"http://api.bandsintown.com/artists/%@.json?api_version=2.0&app_id=PreAmp",artistname];
    
    NSURL *url = [NSURL URLWithString:endpoint];
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            finishedGettingArtistImage(error,nil);
        }else{
       
    NSDictionary *JSONresults = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            
            
            
            NSDictionary *returnDic;
            NSString *URLString = [JSONresults objectForKey:@"thumb_url"];
            NSString *artistName = [JSONresults objectForKey:@"name"];
            NSString *mbidNumber = [JSONresults objectForKey:@"mbid"];
            
            if (mbidNumber == (id)[NSNull null]) {
                mbidNumber = @"empty";
            }
            
            
            if (URLString) {
                NSURL *imageNSURL = [[NSURL alloc]initWithString:URLString];
                NSData *imageData = [[NSData alloc]initWithContentsOfURL:imageNSURL];
                UIImage *downloadedImage = [UIImage imageWithData:imageData];
                
                if (artistName) {
                    returnDic = @{@"artistName":artistName,@"artistImage":downloadedImage,@"mbid":mbidNumber};
                    finishedGettingArtistImage(nil,returnDic);
                }
                
            }else{
                //UNKNOWN ARTIST RETUN NOTING
                NSDictionary *returnDic = @{};
                finishedGettingArtistImage(nil,returnDic);


                
            }
        
        }
    
    }];

    
    ///http://api.bandsintown.com/artists/mbid_%@?format=json&api_version=2.0&app_id=PreAmp
    
}

#pragma - Echo Nest
//http://the.echonest.com

///check to see if echo nest has a mbid number for the artist name -- MBID's are good
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

//Use echo nest to get a list of suggestd artist for a name
-(void)getArtistSuggestionsForSearchQuery:(NSString*)searchQuery competionBlock:(void(^)(NSError* error,NSArray* artistSuggestions))finishedGettingArtistSuggestionsForSearchQuery{
    
    
   NSString *endpoint = [NSString stringWithFormat:@"http://developer.echonest.com/api/v4/artist/suggest?api_key=VLWOTTE5BDW9KEQEK&name=%@&results=7",searchQuery];
    
    AFHTTPRequestOperationManager *echoNestRequest = [AFHTTPRequestOperationManager manager];
    [echoNestRequest GET:endpoint parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
        NSDictionary *response = [responseObject objectForKey:@"response"];
        NSArray *artist = [response objectForKey:@"artists"];
        NSMutableArray *returnArray = [[NSMutableArray alloc]init];
        
        [artist  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            JCSearchResultsObject *artist = [[JCSearchResultsObject alloc]initWithJsonRsult:obj];
            
            if (artist != nil){
                //cheack to so if we didnt kill that event object in any other class's
                //then add it to the array
               [returnArray addObject:artist];
            }
        }];
        
        
        finishedGettingArtistSuggestionsForSearchQuery(nil,returnArray);
    
    
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        finishedGettingArtistSuggestionsForSearchQuery(error,nil);
    }];


}



#pragma - Helper Method

-(NSString*)formatDateForAPIcall:(NSDate*)date{
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    [dateFormat setDateFormat:@"yyyy-LL-dd"];
    
    NSString *formattedDate = [dateFormat stringFromDate:date];
    
    return formattedDate;
};
-(NSMutableArray*)sortArrayByUpcomingDate:(NSMutableArray*)arrayToBeSorted{
    
    //sort the results in distance from irlenad
    NSSortDescriptor *sortByUpcomingDate;
    sortByUpcomingDate = [[NSSortDescriptor alloc] initWithKey:@"eventDate"
                                                            ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortByUpcomingDate];
    NSMutableArray *sortedArray = [[NSMutableArray alloc]init];
   [sortedArray addObjectsFromArray:[arrayToBeSorted sortedArrayUsingDescriptors:sortDescriptors]];
    
    return sortedArray;
    
}
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
