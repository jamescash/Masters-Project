//
//  JCHttpFacade.m
//  masterbranch
//
//  Created by james cash on 30/07/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "JCHttpFacade.h"



@interface JCHttpFacade ()
@property (nonatomic, strong) JCHTTPClient *JCHTTPClient;
@property (strong,nonatomic) NSMutableArray *socialStreamData;

@end



@implementation JCHttpFacade{
    BOOL considerDeligation1;
    BOOL considerDeligation2;
    BOOL considerDeligation3;

}


- (id)initWithEvent:(eventObject*)currentevent
{
    self = [super init];
    if (self) {
        considerDeligation1 = NO;
        considerDeligation2 = NO;
        considerDeligation3 = NO;

        
        self.socialStreamData = [[NSMutableArray alloc]init];
        self.JCHTTPClient = [[JCHTTPClient alloc]initWithEvent:currentevent];
        
        [self.JCHTTPClient addObserver:self forKeyPath:@"InstaHashTagResults" options:0 context:nil];
        [self.JCHTTPClient addObserver:self forKeyPath:@"InstaPlacesResults" options:0 context:nil];
        [self.JCHTTPClient addObserver:self forKeyPath:@"ParseTwitterResults" options:0 context:nil];

       // [self addObserver:self forKeyPath:@"socialStreamData" options:0 context:nil];

}
    return self;
}



- (void)dealloc
{
    [self.JCHTTPClient removeObserver:self forKeyPath:@"InstaHashTagResults"];
    //[self.JCHTTPClient addObserver:self forKeyPath:@"InstaPlacesResults" options:0 context:nil];


    NSLog(@"dealloc in JChttpFacade called");
}




-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    
    
    if ([keyPath isEqualToString:@"InstaHashTagResults"]){
        
            [self.socialStreamData addObjectsFromArray:self.JCHTTPClient.InstaHashTagResults];
            NSLog(@" %d InstaHashTagResults added to social stream array",[self.JCHTTPClient.InstaHashTagResults count]);
            considerDeligation1 = YES;
        
     }
    
    if ([keyPath isEqualToString:@"InstaPlacesResults"]) {

            [self.socialStreamData addObjectsFromArray:self.JCHTTPClient.InstaPlacesResults];
            considerDeligation2 = YES;
            NSLog(@"%d InstaPlacesResults added to social stream array", [self.JCHTTPClient.InstaHashTagResults count]);

     
    }
    
    
    if ([keyPath isEqualToString:@"ParseTwitterResults"]) {
        
            [self.socialStreamData addObjectsFromArray:self.JCHTTPClient.ParseTwitterResults];
            considerDeligation3 = YES;
            NSLog(@"%d Twitter added to social stream array",[self.JCHTTPClient.ParseTwitterResults count]);

            
        
    }
    
    
    if (considerDeligation1&&considerDeligation2&&considerDeligation3) {
        
        [self.JCHttpFacadedelegate reloadTableViewithArray:self.socialStreamData];

    }
    
    

    
    
    


}





//[self.JCHttpFacadedelegate reloadTableViewithArray:self.socialStreamData];




//-(void)APIreqestDidFinish1:(NSArray *)paresedData{
//    
//    [self.socialStreamData addObject:self.JCHTTPClient.instaresults];
//    
//    [self.JCHttpFacadedelegate APIreqestDidFinish:self.socialStreamData];
//    
//};

@end
