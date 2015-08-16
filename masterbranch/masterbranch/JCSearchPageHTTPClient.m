//
//  JCSearchPageHTTPClient.m
//  masterbranch
//
//  Created by james cash on 16/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "JCSearchPageHTTPClient.h"
#import "eventObject.h"


@interface JCSearchPageHTTPClient ()

@property (nonatomic,strong) NSMutableArray *paresedSearchResults;

@end

@implementation JCSearchPageHTTPClient




- (id)initWithArtistName:(NSString*)artistName
{
    self = [super init];
    if (self) {
        
        _paresedSearchResults = [[NSMutableArray alloc]init];
            NSString *artistNameEncodedRequest = [artistName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
        
        [self getmbidNumberfor:artistNameEncodedRequest];
        
        
    }
    return self;
}



-(void)getmbidNumberfor:(NSString*)artistname {
    
    
    NSString *endpoint = [NSString stringWithFormat:@"http://developer.echonest.com/api/v4/artist/search?api_key=VLWOTTE5BDW9KEQEK&format=json&name=%@&bucket=id:musicbrainz&results=1&limit=true",artistname];
    
    NSURL *url = [NSURL URLWithString:endpoint];
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            NSLog(@"error coming from echo nest, get mbid API call %@",error);
            //self.InstaPlacesResults = @[];
            
        } else {
            
            NSDictionary *echoNestResults = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            
            
            
            NSDictionary *reponse = echoNestResults[@"response"];
            NSArray *artist = reponse[@"artists"];
            
           
           //if no mbid number just search by artist name
            if ([artist count]==0 ) {
                NSLog(@"No mbid found for that artist");
                [self getArtistUpComingEvents:artistname andMbidNumber:nil];
            
            //else search with both artist name and mbid number
            }else{
            
            NSDictionary *artisthammerdown = artist[0];
            NSArray *foreign_ids = artisthammerdown[@"foreign_ids"];
            NSDictionary *foreign_idsHammerdown = foreign_ids[0];
            NSString *foreign_id = foreign_idsHammerdown[@"foreign_id"];
            NSString *mbid = [foreign_id stringByReplacingOccurrencesOfString:@"musicbrainz:artist:" withString:@""];

                NSLog(@"%@ mbid found",mbid);
                [self getArtistUpComingEvents:artistname andMbidNumber:mbid];
        
            }
      
        }
        
    }];
    
};



-(void)getArtistUpComingEvents:(NSString*)artistname andMbidNumber:(NSString*)mbidNumber {
    
    
    NSString *endpoint = [NSString stringWithFormat:@"http://api.bandsintown.com/artists/%@/events.json?artist_id=mbid_%@&api_version=2.0&app_id=PreAmp",artistname,mbidNumber];
    
    NSURL *url = [NSURL URLWithString:endpoint];
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            NSLog(@"error coming from bandsintown get artist upcoming events API call %@",error);
            //self.InstaPlacesResults = @[];
            
        } else {
            
            NSArray *JSONresults = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            
            if ([JSONresults count]== 0 ) {
                NSLog(@"no upcoming events found");
                return;
                //counterForRunningDeligation ++;
                //[self considerRunningDeligation];
            }
            
            else if ([JSONresults count] == 1) {
                
                //this is a work around I had to do to fix a bug that was cuasing a charch
                //If the api did not know the aritst it returns a dictionary with one error key
                //if i did know the artist it returns an Array/ and so I have to check array that have a count
                //of one to make sure its not an error and in order to do that I have to convert to a dictionary
                //becuse all results are cast to an ARRAY
                
                NSDictionary *errorCheking = [self indexKeyedDictionaryFromArray:JSONresults];

                if ([[errorCheking objectForKey:@"objectOne"] isEqual: @"errors"]) {
                    NSLog(@"Unknown Artists");
                    return;
                }
             
            }
            
            if ([JSONresults count]>0) {
                
                NSMutableArray *fullArrayOfSearchResults = [[NSMutableArray alloc]init];
             
         
                
                //TODO add this bug fix logic to other API calls to stop crashed
                [JSONresults  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    
                    eventObject *event = [[eventObject alloc]initWithTitle:obj];
                    
                    if (event != nil){
                        
                        [fullArrayOfSearchResults addObject:event];

                        
                        //if ([event.country isEqualToString:@"Ireland"]) {
//                            
//                            [InIreland addObject:event];
//
//                        } else if (event.DistanceFromIreland < 500) {
//                            [CloseToIreland addObject:event];
//                        
//                        }else{
//                            
//                            [EverythingElse addObject:event];
//                        }
                     }
                }];
                
                
                
                [self.paresedSearchResults addObjectsFromArray:fullArrayOfSearchResults];
                
                
                NSSortDescriptor *sortInDistanceFromIreland;
                sortInDistanceFromIreland = [[NSSortDescriptor alloc] initWithKey:@"DistanceFromIreland"
                                                             ascending:YES];
                NSArray *sortDescriptors = [NSArray arrayWithObject:sortInDistanceFromIreland];
                
                NSArray *SearchResultsSortedInDistanceFromIreland;
               
                SearchResultsSortedInDistanceFromIreland = [self.paresedSearchResults sortedArrayUsingDescriptors:sortDescriptors];
               
                
                 NSMutableArray *InIreland = [[NSMutableArray alloc]init];
                 NSMutableArray *TopClosest = [[NSMutableArray alloc]init];
                 NSMutableArray *EverythingElse = [[NSMutableArray alloc]init];
                
                 for (eventObject *obj in SearchResultsSortedInDistanceFromIreland) {
                
                     int counter = 0;
                     
                     
                     if ([obj.country isEqualToString:@"Ireland"]) {
                    
                         [InIreland addObject:obj];
                      }
                 

                     switch (counter) {
                         case 0 :
                             NSLog(@"first loop");
                             break;
                         case 1:
                             NSLog(@"second loop");
                             break;
                         case 3:
                             NSLog(@"third loop");
                             break;
                         case 4:
                             NSLog(@"fourth loop");
                             break;
                         case 5:
                             NSLog(@"5th loop");
                             break;
                         default:
                             NSLog(@"Unknown operator.");
                             break;
                     }
                 
                     counter ++;
                 
                 }
                
                
                
                //2d array to determin the sections in the table View
//                if ([InIreland count] != 0) {
//                    [self.paresedSearchResults addObject:InIreland];
//
//                }
//                
//                if ([CloseToIreland count] != 0) {
//                    [self.paresedSearchResults addObject:CloseToIreland];
//
//                }
//                
//                if ([EverythingElse count] != 0) {
//                    [self.paresedSearchResults addObject:EverythingElse];
//
//                }
                
                
                
                //NSLog(@"%@",self.paresedSearchResults );
                
                // counterForRunningDeligation ++;
                // [self considerRunningDeligation];
                
            }
           
            
            
            
        }
        
    }];
    
};


- (NSDictionary *) indexKeyedDictionaryFromArray:(NSArray *)array
{
    id objectInstance;
    NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
    for (objectInstance in array)
        [mutableDictionary setObject:objectInstance forKey:@"objectOne"];
    
    return mutableDictionary;
}

@end
