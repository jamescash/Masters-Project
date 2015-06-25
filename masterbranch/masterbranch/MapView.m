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


@interface MapView (){
  
    dispatch_queue_t APIcalls;
    
}


@end

@implementation MapView



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (!APIcalls) {
        APIcalls = dispatch_queue_create("com.APIcall.Bandsintown", NULL);
    }
    
   
    
    [self.MkMapViewOutLet setDelegate:self];
    
    //create event object and then call the main buld master array method
    //this method builds an array of parsed event objects that represents all the event happening in ireland on todays date
    
    
    
    
    eventObject *event = [[eventObject alloc]init];
   
    
    dispatch_async(APIcalls, ^{
    
        [event buildmasterarray:^{
            
            self.arrayOfGigs = [[NSMutableArray alloc]init];
            //
            self.arrayOfGigs = event.allEvents;
            
            self.annotations = [[NSMutableArray alloc]init];
            [self buildannotations:self.arrayOfGigs];
            
            
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
        // NSLog(@"%@",ann.imageURL);

        
        

   }
    
    
}


- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    //create the view
    
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
    
    //enable annimation
    view.enabled = YES;
    view.animatesDrop = YES;
    view.canShowCallout = YES;
    view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    
    
    eventObject *currentevent = currentAnnotaion.currentEvent;
    
    
    NSString *pictureurl =currentevent.coverpictureURL;
   // NSLog(@"%@",pictureurl);
    NSURL *pic = [NSURL URLWithString:pictureurl];
    NSData *data = [NSData dataWithContentsOfURL:pic];
    UIImage *img = [[UIImage alloc] initWithData:data];
    
    //UIImage *actualImage = [UIImage imageWithData:imageData];
    UIGraphicsBeginImageContext(CGSizeMake(img.size.width/5, img.size.height/5));
                                [img drawInRect:CGRectMake(0,0,img.size.width/5, img.size.height/5)];
                                UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
                                UIGraphicsEndImageContext();
                                NSData *smallData = UIImagePNGRepresentation(newImage);
    
    UIImage *newimage = [[UIImage alloc] initWithData:smallData];

    
    
    UIImageView *imageview = [[UIImageView alloc] initWithImage:newimage];
    
    
    view.leftCalloutAccessoryView = imageview;
    
    return view;
    
    
};


//here trying to call the get artist cover picture API method when annotation is selected

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{

    
    //Annotation *currentannoation = view.annotation;
    
    //getArtistInfo *getartistinfo = [[getArtistInfo alloc]init];
    
    //eventObject *event = [[eventObject alloc]init];
    
    //event = currentannoation.currentEvent;
   // (id)[NSNull null]
   
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
