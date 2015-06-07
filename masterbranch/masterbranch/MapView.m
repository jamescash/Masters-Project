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
        self.todaysGigs = [[NSMutableArray alloc]init];
        self.todaysGigs = event.todaysObjects;
        [self buildannotations];
    }];

    [self.MkMapViewOutLet setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)buildannotations{
    
    
    
    self.annotations = [[NSMutableArray alloc]init];
    CLLocationCoordinate2D location;
    eventObject *current = [[eventObject alloc]init];

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
        ann.subtitle = current.venueName;
        ann.eventObjectIndex = i;
        
        [self.annotations addObject:ann];
        
     
        
    }
    
    
    [self.MkMapViewOutLet addAnnotations:self.annotations];

    
    
}



- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{

    Annotation *currentannoation = view.annotation;
    int indexpath = currentannoation.eventObjectIndex;
    [self performSegueWithIdentifier:@"socialStream" sender:self.todaysGigs[indexpath]];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"socialStream"])
    {
        eventObject *currentevent = sender;
        SocialStream *svc = [segue destinationViewController];
        svc.currentevent = currentevent;

    }
}



@end
