//
//  MapView.m
//  masterbranch
//
//  Created by james cash on 06/06/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "MapView.h"
#import "Annotation.h"
#import "eventObject.h"


@interface MapView ()

@end

@implementation MapView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.MkMapViewOutLet setDelegate:self];
    eventObject *event = [[eventObject alloc]init];
    
    [event buildmasterarray:^{
        //NSLog(@"copletetion block");
        //self.todaysGigs = [[NSMutableArray alloc]init];
        //self.todaysGigs = event.happeningLater;
        
        self.arrayOfGigs = [[NSMutableArray alloc]init];
        self.arrayOfGigs = event.allEvents;
        

        
        self.annotations = [[NSMutableArray alloc]init];
        [self buildannotations:self.arrayOfGigs];
        

        [self.MkMapViewOutLet addAnnotations:self.annotations];
        
    }];//end of songkick API call + Data parsing
}//end of view did load

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}






-(void)buildannotations:(NSArray*)arrayofgigs{
  
    

    
    CLLocationCoordinate2D location;
    
    
    for (eventObject *event in arrayofgigs) {
        
        //NSLog(@"this should loop");
        NSString *latitude = event.LatLong[@"lat"];
        NSString *Long = event.LatLong[@"long"];
        location.latitude = [latitude doubleValue];
        location.longitude = [Long doubleValue];
        Annotation *ann = [[Annotation alloc]init];
        ann.coordinate = location;
        ann.title = event.eventTitle;
        ann.subtitle = event.venueName;
        ann.currentEvent = event;
        ann.status = event.status;
        
        [self.annotations addObject:ann];

   }
    
    
}


- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    //create the view
    
    MKPinAnnotationView *view = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"pin"];
    Annotation *currentAnnotaion = [[Annotation alloc]init];
    currentAnnotaion = annotation;
    
    if ([currentAnnotaion.status isEqualToString: @"alreadyHappened"]) {
        view.pinColor = MKPinAnnotationColorGreen;

    }else if ([currentAnnotaion.status isEqualToString:@"happeningLater"]){
        view.pinColor = MKPinAnnotationColorPurple;

    }else if ([currentAnnotaion.status isEqualToString:@"currentlyhappening"]){
        view.pinColor = MKPinAnnotationColorRed;
    }
    
    //enable annimation
    view.enabled = YES;
    view.animatesDrop = YES;
    view.canShowCallout = YES;
    view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    
    
    
    
    
    //NSString *pictureurl =currentAnnotaion.imageURL;
    //NSLog(@"%@",pictureurl);
    //NSURL *pic = [NSURL URLWithString:pictureurl];
    //NSData *data = [NSData dataWithContentsOfURL:pic];
    //UIImage *img = [[UIImage alloc] initWithData:data];
    //cell.imageView.image = img;
    
    return view;
    
    
};


//here trying to call the get artist cover picture API method when annotation is selected

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{

    
    Annotation *currentannoation = view.annotation;
    
    //getArtistInfo *getartistinfo = [[getArtistInfo alloc]init];
    
    eventObject *event = [[eventObject alloc]init];
    
    event = currentannoation.currentEvent;
   // (id)[NSNull null]
    if ([event.mbidNumber isEqualToString:@"empty"]) {
        NSLog(@"no mbid number");
    }else {
        NSString *url = [event getArtistInfoByMbidNumuber:event.mbidNumber completionBolock:^{NSLog(@"hi");}];
     }
    
    
    
    
    
    
    
    
    //NSString *coverpictureURL = [getartistinfor getArtistInfoByMbidNumuber:event.mbidNumber completionBolock:^{NSLog(@"it worked");} ];
    //NSString *url = [getartistinfo ]
    
   // NSLog(@"%@",coverpictureURL);
    
    //int indexpath = currentannoation.eventObjectIndex;
   // [self performSegueWithIdentifier:@"socialStream" sender:self.todaysGigs[indexpath]];
}

//
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([segue.identifier isEqualToString:@"socialStream"])
//    {
//        eventObject *currentevent = sender;
//        SocialStream *svc = [segue destinationViewController];
//        svc.currentevent = currentevent;
//
//    }
//}



@end
