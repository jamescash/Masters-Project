//
//  JCURLRetriever.m
//  masterbranch
//
//  Created by james cash on 21/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "JCURLRetriever.h"

@interface JCURLRetriever ()
@property (nonatomic, readwrite, strong) NSIndexPath *indexPathInTableView;
@property (nonatomic, readwrite, strong) JCPhotoDownLoadRecord *photoRecord;
@end

@implementation JCURLRetriever{
    BOOL Log;
}

#pragma mark - Life Cycle

- (id)initWithPhotoRecord:(JCPhotoDownLoadRecord *)record atIndexPath:(NSIndexPath *)indexPath delegate:(id<JCURLRetrieverDelegate>)theDelegate {
    
    if (self = [super init]) {
        self.delegate = theDelegate;
        self.indexPathInTableView = indexPath;
        self.photoRecord = record;
        Log = NO;
    }
    return self;
}


#pragma mark - Downloading image

- (void)main {
    
    @autoreleasepool {
        
        if (self.isCancelled) {
            return;
        }
        

        if (![self.photoRecord.artistMbid  isEqual: @"error"]) {
            //first try bandsintown with MBID
            self.photoRecord.URL = [self getimageURLfromBandsintownwithartistMBID];
        }
        if ((self.photoRecord.URL == nil)) {
            //Second try bandsintown with artist name
            self.photoRecord.URL = [self getimageURLfromBandsintownwithartistName];
        }
        if ((self.photoRecord.URL == nil)&&![self.photoRecord.artistMbid isEqual: @"error"]) {
            //thid try echo nest with MBID
            self.photoRecord.URL = [self getimageURLFromEchoNestWithMBID];
        }
        if ((self.photoRecord.URL == nil)) {
            //last try echo nest woth just artsit name
           self.photoRecord.URL = [self getimageURLFromEchoNestWithArtistName];
        }
         if ((self.photoRecord.URL == nil)) {
            self.photoRecord.failed = YES;
           
            if (Log) {
               
                NSLog(@"couldnt find image for %@ and MBID %@",self.photoRecord.name,self.photoRecord.artistMbid);

            };
            
        
        }
        
    [(NSObject *)self.delegate performSelectorOnMainThread:@selector(JCURLRetrieverDidFinish:) withObject:self waitUntilDone:NO];

    
    }
}

//http://developer.echonest.com/api/v4/artist/images?api_key=VLWOTTE5BDW9KEQEK&id=musicbrainz:artist:a74b1b7f-71a5-4011-9441-d0b5e4122711&format=json&results=15&start=0&license=unknown

-(NSURL*)getimageURLFromEchoNestWithMBID{
    
    NSString *endpoint = [NSString stringWithFormat:@"https://developer.echonest.com/api/v4/artist/images?api_key=VLWOTTE5BDW9KEQEK&id=musicbrainz:artist:%@&format=json&results=15&start=0&license=unknown",self.photoRecord.artistMbid];
    
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:endpoint]];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                          returningResponse:&response
                                                      error:&error];
    
    if (self.isCancelled) {
        return nil;
    }
    
    
    if (error == nil)
    {
        NSDictionary *jsonData = [[NSDictionary alloc]init];
        jsonData  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        
        
        if ([jsonData count]== 0 ) {
            
            if (self.isCancelled) {
                return nil;
            }
            
            if (Log) {

            NSLog(@"No info for that artist seched by mbif, ECHONEST");
            return nil;
            }
       
        }
        
        if ([jsonData count] != 0) {
            
            if (self.isCancelled) {
                return nil;
            }
            
            NSDictionary *response = jsonData[@"response"];
           
            NSDictionary *status = response[@"status"];
            
            int five = 5;
            
            NSNumber *fivee = [NSNumber numberWithInt:five];
            
            if ([status[@"code"] isEqualToNumber:fivee]) {
                return nil;
            }
            
            NSNumber *total = response [@"total"];
            
            if (total == 0) {
                return nil;
            }
          
            NSArray *images = response[@"images"];
            
            if (images.count == 0) {
                return nil;
            }
            
            NSDictionary *license = images[0];
            
            NSString *stringURL = license[@"url"];
            
            NSURL *url = [NSURL URLWithString:stringURL];
           
            if (Log) {
            NSLog(@"GOT URL VIA MBID SEARCH ECHONEST %@",stringURL);
            }
            
            return url;
            
        }
        
    }else{
        if (self.isCancelled) {
            return nil;
        }
        if (Log) {

        NSLog(@"JSON ERROR adding coverpicture URL artsit search with MBID ECHO NEST");
        }
    }
    
    if (self.isCancelled) {
        return nil;
    }
    
    
    return nil;
    
}

-(NSURL*)getimageURLFromEchoNestWithArtistName{
    
    
    
    NSString *endpoint = [NSString stringWithFormat:@"https://developer.echonest.com/api/v4/artist/images?api_key=VLWOTTE5BDW9KEQEK&format=json&results=15&&name=%@&start=0&license=unknown",self.photoRecord.name];
    
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:endpoint]];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                          returningResponse:&response
                                                      error:&error];
    
    if (self.isCancelled) {
        return nil;
    }
    
    
    if (error == nil)
    {
        NSDictionary *jsonData = [[NSDictionary alloc]init];
        jsonData  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
       
        if (self.isCancelled) {
            return nil;
        }
        
        if ([jsonData count]== 0 ) {
            
            if (Log) {
             NSLog(@"No info for that artist seched by name, ECHONEST");
            }
            return nil;

        }

        if ([jsonData count] != 0) {
            
            if (self.isCancelled) {
                return nil;
            }
            
            NSDictionary *response = jsonData[@"response"];

            NSDictionary *status = response[@"status"];
            
            
            int five = 5;
            
            NSNumber *fivee = [NSNumber numberWithInt:five];
            
            if ([status[@"code"] isEqualToNumber:fivee]) {
                return nil;
            }
       

            NSNumber *total = response [@"total"];
            
            if (total == 0) {
                return nil;
            }
            
            NSArray *images = response[@"images"];
            
            if (images.count == 0) {
                return nil;
            }
            NSDictionary *license = images[0];
            
            NSString *stringURL = license[@"url"];
            
            NSURL *url = [NSURL URLWithString:stringURL];
            if (Log) {
                NSLog(@"GOT URL VIA NAME SEARCH ECHONEST %@",stringURL);
            }
            
            return url;
            
        }
        
    }else{
        if (self.isCancelled) {
            return nil;
        }
        if (Log) {
            NSLog(@"%@",endpoint);

            NSLog(@"JSON ERROR adding coverpicture URL artsit search with name ECHO NEST %@",[error localizedDescription]);
            return nil;

        }
      }
    
    if (self.isCancelled) {
        return nil;
    }
    
    
    return nil;
    
}

-(NSURL*)getimageURLfromBandsintownwithartistName{
    
    
    NSString *endpoint = [NSString stringWithFormat:@"https://api.bandsintown.com/artists/%@.json?api_version=2.0&app_id=PreAmpImageUrl",self.photoRecord.name];
    
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:endpoint]];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                          returningResponse:&response
                                                      error:&error];
    
    if (self.isCancelled) {
        return nil;
    }
    
    
    if (error == nil)
    {
        NSDictionary *jsonData = [[NSDictionary alloc]init];
        jsonData  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        
        if (self.isCancelled) {
            return nil;
        }
        
        if ([jsonData count]== 0 ) {
            
           
            
                if (Log) {
                NSLog(@"No info for that artist seched by name BANDSINTOWN");
                }
            return nil;
            
        }
        
        if (jsonData[@"errors"]) {
            if (self.isCancelled) {
                return nil;
            }
            NSString *error = jsonData[@"errors"];
                if (Log) {
                NSLog(@"unkown artist picture %@",error);
                }
            return nil;
            
        }
        
        if ([jsonData count] != 0) {
            
            if (self.isCancelled) {
                return nil;
            }
            //NSLog(@"%@",jsonData);
            NSString *imageUrl = jsonData [@"thumb_url"];
            
            NSURL *url = [NSURL URLWithString:imageUrl];
                if (Log) {
                NSLog(@"GOT URL VIA NAME SEARCH BANDSINTOW %@",imageUrl);
                }
            return url;
            
        }
        
    }else{
        if (self.isCancelled) {
            return nil;
        }
            if (Log) {
                NSLog(@"%@",endpoint);
            NSLog(@"JSON ERROR adding coverpicture URL artsit search with name BANDSINTOWN %@",[error localizedDescription]);
                
                return nil;

            }
       }
    if (self.isCancelled) {
        return nil;
    }
    
    
    return nil;


}

-(NSURL*)getimageURLfromBandsintownwithartistMBID{
    
    
    NSString *endpoint = [NSString stringWithFormat:@"https://api.bandsintown.com/artists/mbid_%@?format=json&api_version=2.0&app_id=PreAmpImageUrl",self.photoRecord.artistMbid];
    
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:endpoint]];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                          returningResponse:&response
                                                      error:&error];
    
    if (self.isCancelled) {
        return nil;
    }
    
    
    if (error == nil)
    {
        NSDictionary *jsonData = [[NSDictionary alloc]init];
        jsonData  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        
        
        if ([jsonData count]== 0 ) {
            
            if (self.isCancelled) {
                return nil;
            }
                if (Log) {
                NSLog(@"No info for that artist seched by MBID BANDSINTOWN");
                }
            return nil;
            
        }
        
        if (jsonData[@"errors"]) {
            if (self.isCancelled) {
                return nil;
            }
            NSString *error = jsonData[@"errors"];
                if (Log) {
                    NSLog(@"unkown artist picture %@",error);
                }
            return nil;
            
        }
        
        if ([jsonData count] != 0) {
            
            if (self.isCancelled) {
                return nil;
            }
            NSString *imageUrl = jsonData [@"thumb_url"];
            
            NSURL *url = [NSURL URLWithString:imageUrl];
            
            if (Log) {
             NSLog(@"GOT URL VIA MBID %@",imageUrl);
            }
            return url;
            
        }
        
    }else{
        if (self.isCancelled) {
            return nil;
        }
        if (Log) {
         NSLog(@"JSON ERROR adding coverpicture URL artsit search with MBID BANDSINTOWN");
        }
    }
    if (self.isCancelled) {
        return nil;
    }
    
    
    return nil;
    
    
    
}

@end
