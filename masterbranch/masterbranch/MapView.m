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
    [self.MkMapViewOutLet setDelegate:self];

    if (!APIcalls) {
        APIcalls = dispatch_queue_create("com.APIcall.Bandsintown", NULL);
    }
    
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
    
    
    

    dispatch_async(APIcalls, ^{
    
    eventObject *currentevent = currentAnnotaion.currentEvent;
    
    
//    if ([currentevent.mbidNumber isEqualToString:@"empty"]) {
//        currentevent.coverpictureURL = [currentevent getArtistInfoByName:currentevent.InstaSearchQuery];
//
//    }else{
//        
//        currentevent.coverpictureURL = [currentevent getArtistInfoByMbidNumuber:currentevent.mbidNumber];
//    }
    
    

    NSString *pictureurl =currentevent.coverpictureURL;
    NSLog(@"%@",pictureurl);
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
    
    
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            view.leftCalloutAccessoryView = imageview;
        
           // view.image = newimage;
        
        
        
        });
   
    
    });
    
    
        
    return view;
    
    
};


//here trying to call the get artist cover picture API method when annotation is selected

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{

   
//    eventObject *event = [[eventObject alloc]init];
     //Annotation *currentannoation = view.annotation;
    
//    event = currentannoation.currentEvent;
//
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
