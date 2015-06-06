//
//  MapView.m
//  masterbranch
//
//  Created by james cash on 06/06/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "MapView.h"
#import "Annotation.h"

@interface MapView ()

@end

@implementation MapView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    EngineRoom *event = [[EngineRoom alloc]init];
    
    [event songKickApiCall:^{
                //  NSString *stringRep = [NSString stringWithFormat:@"%@", event.todaysObjects];
               // NSLog(@"%@",stringRep);
        self.todaysGigs = [[NSMutableArray alloc]init];
        self.todaysGigs = event.todaysObjects;
        [self buildannotations];
    }];














}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)buildannotations{
    
    
    
    self.annotations = [[NSMutableArray alloc]init];
    CLLocationCoordinate2D location;
    eventObject *current = [[eventObject alloc]init];

    //NSLog(@"%d",[self.todaysGigs count]);
    
    
    for (int i = 0; i<[self.todaysGigs count]; i++) {
        
        //CLLocationCoordinate2D location;
        current = self.todaysGigs[i];
        NSString *latitude = current.LatLong[@"lat"];
        NSString *Long = current.LatLong[@"long"];
        
        location.latitude = [latitude doubleValue];
        location.longitude = [Long doubleValue];
        Annotation *ann = [[Annotation alloc]init];
        ann.coordinate = location;
        ann.title = current.eventTitle;
        
        [self.annotations addObject:ann];
        
    
    }
    
    NSString *stringRep = [NSString stringWithFormat:@"%@", self.annotations];
    NSLog(@"%@",stringRep);
    
    [self.MkMapViewOutLet addAnnotations: self.annotations];
    
    
    
    
    
    //    for ( id item in self.todaysGigs) {
//   
//        
//        NSLog(@"%@",[item description]);
//    
//    
// 
//        
//        
//        
//    }
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
