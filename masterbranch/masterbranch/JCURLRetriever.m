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

@implementation JCURLRetriever

#pragma mark - Life Cycle

- (id)initWithPhotoRecord:(JCPhotoDownLoadRecord *)record atIndexPath:(NSIndexPath *)indexPath delegate:(id<JCURLRetrieverDelegate>)theDelegate {
    
    if (self = [super init]) {
        self.delegate = theDelegate;
        self.indexPathInTableView = indexPath;
        self.photoRecord = record;
    }
    return self;
}


#pragma mark - Downloading image

- (void)main {
    
    @autoreleasepool {
        
        if (self.isCancelled) {
            return;
        }
        

        //TODO add more image nets here to that all request for users are filled with an image url 
        
        NSString *endpoint = [NSString stringWithFormat:@"http://api.bandsintown.com/artists/%@.json?api_version=2.0&app_id=PreAmp1",self.photoRecord.name];
        
        NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:endpoint]];
        NSURLResponse * response = nil;
        NSError * error = nil;
        NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest
                                              returningResponse:&response
                                                          error:&error];
        
        if (self.isCancelled) {
            self.photoRecord.URL = nil;
            return;
        }
        
        
        if (error == nil)
        {
            NSDictionary *jsonData = [[NSDictionary alloc]init];
            jsonData  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            
        
            if ([jsonData count]== 0 ) {
                
                if (self.isCancelled) {
                    self.photoRecord.URL = nil;
                    return;
                }
                
                NSLog(@"No info for that artist seched by name");
                self.photoRecord.failed = YES;
                self.photoRecord.URL = nil;
                
                }
        
            if (jsonData[@"errors"]) {
                if (self.isCancelled) {
                    self.photoRecord.URL = nil;
                    return;
                }
                NSString *error = jsonData[@"errors"];
                NSLog(@"unkown artist picture %@",error);
                self.photoRecord.failed = YES;
                self.photoRecord.URL = nil;
                
                }
        
            if ([jsonData count] != 0) {
                
                if (self.isCancelled) {
                    self.photoRecord.URL = nil;
                    return;
                }
                //NSString *coverpicURL;
                NSString *imageUrl = jsonData [@"thumb_url"];
                
                NSURL *url = [NSURL URLWithString:imageUrl];
                
                NSLog(@"%@ photo URL URL operation Q ",imageUrl);
                
                self.photoRecord.URL = url;
                
            }
        
        }else{
            if (self.isCancelled) {
                self.photoRecord.URL = nil;
                return;
            }
            NSLog(@"JSON ERROR adding coverpicture URL artsit search with name");
            
            self.photoRecord.failed = YES;
            self.photoRecord.URL = nil;
            
            
        }
        if (self.isCancelled) {
            self.photoRecord.URL = nil;
            return;
        }
      
        [(NSObject *)self.delegate performSelectorOnMainThread:@selector(JCURLRetrieverDidFinish:) withObject:self waitUntilDone:NO];

    
    }
}

//-(void)getArtistInfoByName:(NSString*)artistname{
//    
//    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
//
//    
//    if (self.isCancelled) {
//        return;
//    }
//    
//    
//    //conect to the endpoint with the artist name and get artist JSON
//    NSString *endpoint = [NSString stringWithFormat:@"http://api.bandsintown.com/artists/%@.json?api_version=2.0&app_id=PreAmp1",artistname];
//    NSURL *url = [NSURL URLWithString:endpoint];
//    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//        
////        [NSURLConnection sendSynchronousRequest:[[NSURLRequest alloc]initWithURL:url] returningResponse:(NSURLResponse *response) error:(NSError *error)];
//        
//        
//        if (error) {
//            NSLog(@"JSON ERROR adding coverpicture URL artsit search with name");
//            
//            self.photoRecord.failed = YES;
//            self.photoRecord.URL = nil;
//
//            dispatch_semaphore_signal(sema);
//
//          
//
//          }else {
//            
//            NSDictionary *jsonData = [[NSDictionary alloc]init];
//            jsonData  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
//            
//            if ([jsonData count]== 0 ) {
//                
//                if (self.isCancelled) {
//                    return;
//                }
//                NSLog(@"No info for that artist seched by name");
//                self.photoRecord.failed = YES;
//                self.photoRecord.URL = nil;
//
//                dispatch_semaphore_signal(sema);
//
//                
//           
//
//            }
//              
//            else {
//                if (self.isCancelled) {
//                    return;
//                }
//                
//                //if unknown artist object comes back form API call do this
//                if (jsonData[@"errors"]) {
//                    NSString *error = jsonData[@"errors"];
//                    NSLog(@"unkown artist picture %@",error);
//                    self.photoRecord.failed = YES;
//                    self.photoRecord.URL = nil;
//
//                    dispatch_semaphore_signal(sema);
//
//                    
//                 
//                    
//                }else{
//                    
//                    if (self.isCancelled) {
//                        return;
//                    }
//                    //NSString *coverpicURL;
//                    NSString *imageUrl = jsonData [@"thumb_url"];
//                    
//                    NSURL *url = [NSURL URLWithString:imageUrl];
//                  
//                    NSLog(@"%@ photo URL URL operation Q ",imageUrl);
//                    
//                    self.photoRecord.URL = url;
//                    dispatch_semaphore_signal(sema);
//
//                    
//                    
//                    
//                }
//                
//            }
//        }
//    
//    
//        
//    
//    
//    }];
//
//    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
//    [(NSObject *)self.delegate performSelectorOnMainThread:@selector(JCURLRetrieverDidFinish:) withObject:self waitUntilDone:NO];
//
//}

@end
