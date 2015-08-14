//
//  MapView.m
//  masterbranch
//
//  Created by james cash on 06/06/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "MapView.h"
//top buttons in the nav bar
#import "MMDrawerBarButtonItem.h"
//framework for moving leftside viewcontroler
#import "UIViewController+MMDrawerController.h"


//#import "MMNavigationController.h"

#import "JCSocailStreamController.h"




//#import "MMDrawerController.h"

#import <QuartzCore/QuartzCore.h>




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
    [super viewDidAppear:animated];
    
    //work around for nav bar
    self.navigationController.navigationBar.translucent = NO;

    
//close any open annotations befoure the view opens again
for (NSObject<MKAnnotation> *annotation in [self.MkMapViewOutLet selectedAnnotations]) {
        [self.MkMapViewOutLet deselectAnnotation:(id <MKAnnotation>)annotation animated:NO];
    }
};


-(void)viewDidAppear:(BOOL)animated{
    self.navigationController.navigationBar.translucent = YES;

};


- (void)viewDidLoad {
    

    [super viewDidLoad];
    annotations = [[NSMutableArray alloc]init];
    self.MkMapViewOutLet = [[MKMapView alloc] initWithFrame:self.view.bounds];
    [self.MkMapViewOutLet setDelegate:self];
   

    
    [self.view addSubview:self.MkMapViewOutLet];
    
    //go to bandsintown and build a single array of parsed events
    eventbuilder  = [JCEventBuilder sharedInstance];
    eventbuilder.delegate = self;
    
    //add a loading wheel for user feedback
    av = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    av.frame=CGRectMake(145, 160, 100, 100);
    av.tag  = 1;
    [self.MkMapViewOutLet addSubview:av];
    [av startAnimating];
    
    
    
    
    [self setupLeftMenuButton];
    
    UIColor * barColor = [UIColor
                          colorWithRed:247.0/255.0
                          green:249.0/255.0
                          blue:250.0/255.0
                          alpha:1.0];
   
    [self.navigationController.navigationBar setBarTintColor:barColor];
    [self.navigationController.view.layer setCornerRadius:10.0f];
     self.navigationController.title = @"PreAmp";
    
 

    
    
}//end of view did load

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


//delegate method thats called when all the events are laoded and parsed into the main array
-(void)LoadMapView{
    
    
    allEvents = [eventbuilder getEvent];
    [self buildannotations:allEvents];
    
    
    //make sure the annotations are added to the mapview on the main thread
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
    
    
   // UIViewController* ViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginViewController"];
    
    [self.MapViewDelegate userDidSelectAnnotation:currentannoation.currentEvent];
    
    //JCSocailStreamController *socialstream = [[JCSocailStreamController alloc]initWithTitle:currentannoation.currentEvent];

    //[self presentViewController:socialstream animated:YES completion:nil];
    
    //[[UIStoryboard storyboardWithName:@"storyboard name" bundle:nil] instantiateViewControllerWithIdentifier:@"vc identifier"];

    //[self performSegueWithIdentifier:@"socialStream" sender:currentannoation.currentEvent];
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




-(void)setupLeftMenuButton{
    
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
   
    
    [self.navigationItem setLeftBarButtonItem:leftDrawerButton animated:YES];
}



-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    
}




@end
