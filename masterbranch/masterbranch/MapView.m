//
//  MapView.m
//  masterbranch
//
//  Created by james cash on 06/06/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "MapView.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>



@interface MapView (){
  
    dispatch_queue_t imageLoad;
    
    NSArray *allEvents;
    JCEventBuilder *eventbuilder;
    NSMutableArray *annotations;
    UIActivityIndicatorView *av;
    
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
    annotations = [[NSMutableArray alloc]init];
    [self.MkMapViewOutLet setDelegate:self];
    eventbuilder  = [JCEventBuilder sharedInstance];
    eventbuilder.delegate = self;
    
   
    //fb logging button
    //[FBSDKSettings setAppID:@"962582523784456"];
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.readPermissions = @[@"email",@"public_profile"];
    loginButton.center = self.view.center;
    [self.view addSubview:loginButton];
    

    av = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    av.frame=CGRectMake(145, 160, 100, 100);
    av.tag  = 1;
    [self.MkMapViewOutLet addSubview:av];
    [av startAnimating];


}//end of view did load

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



-(void)LoadMapView{
    
    allEvents = [eventbuilder getEvent];
    [self buildannotations:allEvents];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.MkMapViewOutLet addAnnotations:annotations];
        [av stopAnimating];

    });

}


-(void)buildannotations:(NSArray*)arrayofgigs{
  
CLLocationCoordinate2D location;
    
    for (eventObject *event in arrayofgigs) {
        
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
        [annotations addObject:ann];
     }
}




- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    //create the annotation view
    MKPinAnnotationView *view = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"pin"];
    
    Annotation *currentAnnotaion = [[Annotation alloc]init];
    
    currentAnnotaion = annotation;

    if ([currentAnnotaion.status isEqualToString: @"alreadyHappened"]) {
        view.pinColor = MKPinAnnotationColorRed;

    }else if ([currentAnnotaion.status isEqualToString:@"happeningLater"]){
        view.pinColor = MKPinAnnotationColorPurple;

    }else if ([currentAnnotaion.status isEqualToString:@"currentlyhappening"]){
        view.pinColor = MKPinAnnotationColorGreen;
    }
    
    
    view.enabled = YES;
    view.animatesDrop = YES;
    view.canShowCallout = YES;
    UIButton *calloutbutton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    view.rightCalloutAccessoryView = calloutbutton;
    
  return view;
};


//here trying to call the get artist cover picture API method when annotation is selected
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
   
    if (!imageLoad) {
        imageLoad = dispatch_queue_create("com.APIcall.annotationImages", NULL);
    }
    
    eventObject *event = [[eventObject alloc]init];
    
    Annotation *currentannoation = view.annotation;
  
    event = currentannoation.currentEvent;

 
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
    
     [self performSegueWithIdentifier:@"socialStream" sender:currentannoation.currentEvent];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   
    if ([segue.identifier isEqualToString:@"socialStream"])
    {
        eventObject *currentevent = [[eventObject alloc]init];
        currentevent = sender;
       
        JCssHappeningLater *jc = [segue destinationViewController];
        jc.currentevent = currentevent;
    }
}






@end
