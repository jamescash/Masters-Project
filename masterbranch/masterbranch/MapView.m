//
//  MapView.m
//  masterbranch
//
//  Created by james cash on 06/06/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "MapView.h"


@interface MapView (){
  
    //the bandsintown API call are made on this queue
    dispatch_queue_t APIcalls;
    //the annoations image load is made on this queue
    dispatch_queue_t imageLoad;
    
}


@end

@implementation MapView


-(void)viewWillAppear:(BOOL)animated{
    
//close any open annotations befoure the view opens again
    
    for (NSObject<MKAnnotation> *annotation in [self.MkMapViewOutLet selectedAnnotations]) {
        [self.MkMapViewOutLet deselectAnnotation:(id <MKAnnotation>)annotation animated:NO];
    }
 
};


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    [self.MkMapViewOutLet setDelegate:self];
    
    //creat dispatch queue for bandsintown API call
    if (!APIcalls) {
        APIcalls = dispatch_queue_create("fmapView.BandsintownAPI.1", NULL);
    }
    
    eventObject *event = [[eventObject alloc]init];
    self.allGigs = [[NSMutableArray alloc]init];
    
   //add loading whwwl while map is loading
    UIActivityIndicatorView *av = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    av.frame=CGRectMake(145, 160, 100, 100);
    av.tag  = 1;
    [self.MkMapViewOutLet addSubview:av];
    [av startAnimating];
        
    
      dispatch_async(APIcalls, ^{
            
            
            //call the build master array on the API dispatch queue
            //this method connects to bandsintow api gets all the events data parses it
            //and returs an array of event objects
            
            
            
            [event buildmasterarray:^{
                
                
                self.annotations = [[NSMutableArray alloc]init];
                self.allGigs = event.allEvents;
                
                [self buildannotations:event.allEvents];
                [av removeFromSuperview];
                
                dispatch_async(dispatch_get_main_queue(), ^{[self.MkMapViewOutLet addAnnotations:self.annotations];});
                
            }];//end of songkick API call + Data parsing
            
            
            
        });
   
}//end of view did load

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}






-(void)buildannotations:(NSArray*)arrayofgigs{
  
    

    
    CLLocationCoordinate2D location;
    
  //Acessing the array of eventObjects build by the eventObject class
    for (eventObject *event in arrayofgigs) {
        
        //build an annotation for eveny object in that array
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
        
        //add it to an array of anationing that will be build when the array is finished being filled
        [self.annotations addObject:ann];
        
        

   }
    
    
}

//this delegation methid is called everytime an annotion is being built, it tell the annotation how it should look

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    //create the annotation view
     MKPinAnnotationView *view = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"pin"];
    Annotation *currentAnnotaion = [[Annotation alloc]init];
    currentAnnotaion = annotation;
    eventObject *event = [[eventObject alloc]init];
    event = currentAnnotaion.currentEvent;
    

    //here we decide what colour to make the annotation besed on the eventObject status
    if ([currentAnnotaion.status isEqualToString: @"alreadyHappened"]) {
        view.pinColor = MKPinAnnotationColorRed;

    }else if ([currentAnnotaion.status isEqualToString:@"happeningLater"]){
        view.pinColor = MKPinAnnotationColorPurple;

    }else if ([currentAnnotaion.status isEqualToString:@"currentlyhappening"]){
        view.pinColor = MKPinAnnotationColorGreen;
    }

    //enable annimation
    view.enabled = YES;
    view.animatesDrop = YES;
    view.canShowCallout = YES;
    UIButton *calloutbutton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    view.rightCalloutAccessoryView = calloutbutton;
    
    
    //view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    

//        if (!imageLoad) {
//            imageLoad = dispatch_queue_create("com.APIcall.annotationImages", NULL);
//       }
//
//
//    dispatch_async(imageLoad, ^{
//
//        
//        
//        if ([event.mbidNumber isEqualToString:@"empty"]) {
//            
//            UIImageView *aa = [[UIImageView alloc]init];
//            
//            aa = [event getArtistInfoByName:event.InstaSearchQuery];
//            
//            dispatch_async(dispatch_get_main_queue(), ^{view.image = aa.image;});
//            
//            
//        }else{
//            
//            
//            UIImageView *aa = [[UIImageView alloc]init];
//            
//            aa = [event getArtistInfoByMbidNumuber:event.mbidNumber];
//  
//            dispatch_async(dispatch_get_main_queue(), ^{view.image = aa.image;});
//            
//            
//        }
//        
//        //view.leftCalloutAccessoryView = event.coverpic;
//        
//    });


    
    
    
    return view;
};

//when the annation is selected this method is called becuse this class is the delaget
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
   //creat a dittrent queue
    if (!imageLoad) {
        imageLoad = dispatch_queue_create("com.APIcall.annotationImages", NULL);
    }
    
    eventObject *event = [[eventObject alloc]init];
    Annotation *currentannoation = view.annotation;
  
    //put the method the gets the cover picture onto that queue
    event = currentannoation.currentEvent;
    NSString *stringRep = [NSString stringWithFormat:@"%@",event.LatLong ];
    NSLog(@"%@",stringRep);
 dispatch_async(imageLoad, ^{
    
    
    
    if ([event.mbidNumber isEqualToString:@"empty"]) {
        
        event.coverpic = [event getArtistInfoByName:event.InstaSearchQuery];
        dispatch_async(dispatch_get_main_queue(), ^{view.leftCalloutAccessoryView = event.coverpic;});

        
    }else{
        
        
        event.coverpic = [event getArtistInfoByMbidNumuber:event.mbidNumber];
        dispatch_async(dispatch_get_main_queue(), ^{view.leftCalloutAccessoryView = event.coverpic;});

        
      }
 });

}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    Annotation *currentannoation = view.annotation;
    //eventObject *event = [[eventObject alloc]init];

    [self performSegueWithIdentifier:@"socialStream" sender:currentannoation.currentEvent];
   // [self performSegueWithIdentifier:@"happeningRightNowTable" sender:currentannoation.currentEvent];

    

}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   
    if ([segue.identifier isEqualToString:@"socialStream"])
    {
        eventObject *currentevent = [[eventObject alloc]init];
        currentevent = sender;
        //NSString *stringRep = [NSString stringWithFormat:@"%@",currentevent.eventTitle];
        NSLog(@"happening later segue called");
        JCssHappeningLater *jc = [segue destinationViewController];
        jc.currentevent = currentevent;
    }
//    }else if ([segue.identifier isEqualToString:@"happeningRightNowTable"]){
//        eventObject *currentevent = [[eventObject alloc]init];
//        currentevent = sender;
//        //NSString *stringRep = [NSString stringWithFormat:@"%@",currentevent.eventTitle];
//        NSLog(@"social stream segug called");
//        JCSocailStreamController *jc = [segue destinationViewController];
//        jc.currentevent = currentevent;
//   }





}






@end
