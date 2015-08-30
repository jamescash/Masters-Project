//
//  JCHappeningTonightHeaderVC.m
//  masterbranch
//
//  Created by james cash on 23/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "JCHappeningTonightHeaderVC.h"


@interface JCHappeningTonightHeaderVC ()


@property (weak, nonatomic) IBOutlet UIView *topBackGround;
@property (weak, nonatomic) IBOutlet MKMapView *EventLocation;
@property (weak, nonatomic) IBOutlet UILabel *ArtistNameAndVenue;
@property (weak, nonatomic) IBOutlet UILabel *EventLoactionLable;
@property (strong,nonatomic) JCAnnotation *eventannotation;
@end

@implementation JCHappeningTonightHeaderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ArtistNameAndVenue.text = self.currentEvent.eventTitle;
    NSString *eventlocation = [NSString stringWithFormat:@"%@ - %@",self.currentEvent.venueName,self.currentEvent.county];
    self.EventLoactionLable.text = eventlocation;

     [self buildannotations:self.currentEvent];
    
        NSString *latitude = self.currentEvent.LatLong[@"lat"];
        NSString *Long = self.currentEvent.LatLong[@"long"];
        CLLocationCoordinate2D track;
        track.latitude = [latitude doubleValue];
        track.longitude = [Long doubleValue];
        
        MKCoordinateRegion region;
        MKCoordinateSpan span;
        span.latitudeDelta = 0.01;
        span.longitudeDelta = 0.01;
        region.span = span;
        region.center = track;
        
    
        [self.EventLocation addAnnotation:self.eventannotation];
        [self.EventLocation setRegion:region animated:TRUE];
        [self.EventLocation regionThatFits:region];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)buildannotations:(eventObject*)currentgig{

CLLocationCoordinate2D location;

    //for (eventObject *event in arrayofgigs) {

        NSString *latitude = self.currentEvent.LatLong[@"lat"];
        NSString *Long = self.currentEvent.LatLong[@"long"];
        location.latitude = [latitude doubleValue];
        location.longitude = [Long doubleValue];
        self.eventannotation = [[JCAnnotation alloc]init];
        self.eventannotation.coordinate = location;
        //ann.title = event.eventTitle;
        //ann.subtitle = event.venueName;
        //ann.currentEvent = event;
        //ann.status = event.status;
        //[annotations addObject:ann];
    // }
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
