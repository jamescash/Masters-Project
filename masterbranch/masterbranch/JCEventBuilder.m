//
//  JCEventBuilder.m
//  masterbranch
//
//  Created by james cash on 05/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "JCEventBuilder.h"

@implementation JCEventBuilder{
    NSArray *countysInIreland;
    EventObjectParser *formatter;
    NSMutableArray *paresedEvents;
    
};




- (id)init
{
    self = [super init];
    if (self) {
      
        countysInIreland = [[NSArray alloc]init];
        formatter = [[EventObjectParser alloc]init];


        countysInIreland = @[@"Dublin,Ireland",@"Cork,Ireland",@"Galway,Ireland",@"Belfast,United+Kingdom",@"Kildare,Ireland",@"Carlow,Ireland",@"Kilkenny,Ireland",
                             @"Donegal,Ireland",@"Mayo,Ireland",@"Sligo,Ireland",@"Derry,Ireland",@"Cavan,Ireland",@"Leitrim,Ireland",@"Monaghan,Ireland"
                             ,@"Louth,Ireland",@"Roscommon,Ireland",@"Longford,Ireland",@"Claregalway,Ireland",@"Tipperary,Ireland",@"Limerick,Ireland",@"Wexford,Ireland",@"Waterford,Ireland",@"Kerrykeel,Ireland"];
        
        NSDate *now = [NSDate date];
      NSString *todaysDate = [formatter formatDateForAPIcall:now];
        NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow: -(60.0f*60.0f*24.0f)];
      NSString *yesterdaysDate = [formatter formatDateForAPIcall:yesterday];
        
        NSArray *dates = @[todaysDate,yesterdaysDate];
        
       
        for (NSString *theDate in dates) {
            
            for (NSString *countyName in countysInIreland) {
                
                [self GetEventJSON:countyName dateObject:theDate];
            }
        };
        
        
        
        
    }
    return self;
}

-(void)GetEventJSON: (NSString*)countyName dateObject:(NSString*)date {
    
    
    
    //connet to the BandsinTown API get all events from the area on todays date
    NSString *endpoint = [NSString stringWithFormat:@"http://api.bandsintown.com/events/search.json?api_version=2.0&app_id=preamp&date=%@,%@&location=%@",date,date,countyName];
    
    NSURL *url = [NSURL URLWithString:endpoint];
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            NSLog(@"api call didnt work to bandsintown with %@",error);
            
        }else {
            
            NSArray *JSONresults = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
         
        
            if ([JSONresults count]== 0 ) {
                
                NSLog(@"there was no events in %@ today %@",countyName,date);
                
            }
            else {
                
                
                NSMutableArray *events = [[NSMutableArray alloc]init];
                
                
                [JSONresults  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    
                    eventObject *event = [[eventObject alloc]initWithTitle:obj];
                    
                    if (event != nil){
                        [events addObject:event];
                    }
                }];
                
                
                paresedEvents = events;
                
                
            }
        
        
        
        }
        
    }];
    
    
    
   
    
};//end of GetEvntJSON

- (NSArray*)getEvent
{
    return paresedEvents;
}


@end
