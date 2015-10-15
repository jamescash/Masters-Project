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
@interface JCHomeScreenDataController ()

@property (nonatomic,strong) NSString *bandsInTownEndPoint;
@property (nonatomic,strong) NSMutableArray *happeningLater;

@end

@implementation JCHomeScreenDataController{
    
}



- (instancetype)init
{
    self = [super init];
    if (self) {
        self.bandsInTownEndPoint = @"http://api.bandsintown.com/events/search.json?api_version=2.0&app_id=preamp";
    }
    return self;
}

-(void)getEventsforDate:(NSDate *)date usingLocation:(NSString *)latitude Longditude:(NSString *)longditude competionBlock:(void (^)(NSError *, NSArray *))finishedGettingMyAtrits{
    

    
    NSString *FormattedNSDateToString = [self formatDateForAPIcall:date];
    NSString *dateSectionForAPICall = [NSString stringWithFormat:@"&date=%@,%@",FormattedNSDateToString,FormattedNSDateToString];
    NSString *locationSectionForAPICall = [NSString stringWithFormat:@"&location=%@,%@",latitude,longditude];
    NSString *radiusSectionForAPICall = [NSString stringWithFormat:@"&radius=50"];
    NSString *endpoint = [NSString stringWithFormat:@"%@%@%@%@",self.bandsInTownEndPoint,dateSectionForAPICall,locationSectionForAPICall,radiusSectionForAPICall];
    
    
    AFHTTPRequestOperationManager *bandsInTownGigRequest = [AFHTTPRequestOperationManager manager];
    [bandsInTownGigRequest GET:endpoint parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
        
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



-(NSString*)formatDateForAPIcall:(NSDate*)date{
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    [dateFormat setDateFormat:@"yyyy-LL-dd"];
    
    NSString *formattedDate = [dateFormat stringFromDate:date];
    
    return formattedDate;
};

@end
