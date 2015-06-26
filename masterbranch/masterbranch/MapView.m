//
//  MapView.m
//  masterbranch
//
//  Created by james cash on 06/06/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "MapView.h"
//#import "Annotation.h"
//#import "eventObject.h"


@interface MapView (){
  
    dispatch_queue_t APIcalls;
    dispatch_queue_t imageLoad;
    
}


@end

@implementation MapView



- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.MkMapViewOutLet setDelegate:self];

    if (!APIcalls) {
        APIcalls = dispatch_queue_create("fmapView.BandsintownAPI.1", NULL);
    }
    
    
    
    
    
    eventObject *event = [[eventObject alloc]init];
   
    dispatch_async(APIcalls, ^{
        
        
        
        [event buildmasterarray:^{
            
            
            self.annotations = [[NSMutableArray alloc]init];
           
            
            [self buildannotations:event.allEvents];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{[self.MkMapViewOutLet addAnnotations:self.annotations];});
            
        }];//end of songkick API call + Data parsing
    
    
    
    });
    
    




}//end of view did load

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
        
            dispatch_queue_t me = dispatch_get_current_queue();
            NSString *stringRep = [NSString stringWithFormat:@"%s",dispatch_queue_get_label(me)];
            NSLog(@"%@",stringRep);

        [self.annotations addObject:ann];

        
        

   }
    
    
}


- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    //create the annotation view
    
    MKPinAnnotationView *view = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"pin"];
    Annotation *currentAnnotaion = [[Annotation alloc]init];
    currentAnnotaion = annotation;
    
    eventObject *event = [[eventObject alloc]init];
    
    event = currentAnnotaion.currentEvent;
    

    
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
    view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
//    
//    if (!imageLoad) {
//        imageLoad = dispatch_queue_create("com.APIcall.annotationImages", NULL);
//    }
//
//
//    

//    dispatch_async(imageLoad, ^{
//        
//
//        
//        if ([event.mbidNumber isEqualToString:@"empty"]) {
//            
//            event.coverpic = [event getArtistInfoByName:event.InstaSearchQuery];
//            
//            
//            dispatch_async(dispatch_get_main_queue(), ^{view.leftCalloutAccessoryView = event.coverpic;  NSLog(@"IMAGES ADDED");});
//          
//            
//        }else{
//            
//            
//            //UIImageView *annoationThumb = [[UIImageView alloc]init];
//            
//            event.coverpic = [event getArtistInfoByMbidNumuber:event.mbidNumber];
//     
//            
//            dispatch_async(dispatch_get_main_queue(), ^{view.leftCalloutAccessoryView = event.coverpic; NSLog(@"IMAGES ADDED");});
//            
//            
//        }
//        
//        
//    });



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
         //   NSString *stringRep = [NSString stringWithFormat:@"%@",event.coverpic];
        //    NSLog(@"%@",stringRep);
        
       // view.leftCalloutAccessoryView = event.coverpic;
        
        dispatch_async(dispatch_get_main_queue(), ^{view.leftCalloutAccessoryView = event.coverpic;});

        
    }else{
        
        
        //UIImageView *annoationThumb = [[UIImageView alloc]init];

        event.coverpic = [event getArtistInfoByMbidNumuber:event.mbidNumber];
       
      //  NSString *stringRep = [NSString stringWithFormat:@"%@",event.coverpic];
      //  NSLog(@"%@",stringRep);


        dispatch_async(dispatch_get_main_queue(), ^{view.leftCalloutAccessoryView = event.coverpic;});

        
      }
     
     //view.leftCalloutAccessoryView = event.coverpic;

});
    
//view.leftCalloutAccessoryView = event.coverpic;
    
//    event.coverpictureURL = [event getArtistInfoByName:event.InstaSearchQuery];
//    
//    NSLog(@"%@",event.coverpictureURL);
    
    //getArtistInfo *getartistinfo = [[getArtistInfo alloc]init];
    
    
   // (id)[NSNull null]
   
    //NSString *coverpictureURL = [getartistinfor getArtistInfoByMbidNumuber:event.mbidNumber completionBolock:^{NSLog(@"it worked");} ];
    //NSString *url = [getartistinfo ]
    
   // NSLog(@"%@",coverpictureURL);
    
    //int indexpath = currentannoation.eventObjectIndex;
   // [self performSegueWithIdentifier:@"socialStream" sender:self.todaysGigs[indexpath]];
}




   //view.leftCalloutAccessoryView = event.coverpic;


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
