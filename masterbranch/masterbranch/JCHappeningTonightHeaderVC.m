//
//  JCHappeningTonightHeaderVC.m
//  masterbranch
//
//  Created by james cash on 23/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "JCHappeningTonightHeaderVC.h"
#import "JCSelectFriends.h"
#import "JCParseQuerys.h"
#import "JCSearchPageHTTPClient.h"



@interface JCHappeningTonightHeaderVC ()

- (IBAction)SendMessage:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *topBackGround;
@property (weak, nonatomic) IBOutlet MKMapView *EventLocation;
@property (weak, nonatomic) IBOutlet UILabel *ArtistNameAndVenue;
@property (weak, nonatomic) IBOutlet UILabel *EventLoactionLable;
@property (nonatomic,strong) PFUser *currentUser;
- (IBAction)followArtist:(id)sender;
@property (strong,nonatomic) JCAnnotation *eventannotation;
@property (nonatomic,strong) JCSearchPageHTTPClient *searchUpcomingGigs;


@property (nonatomic,strong) JCParseQuerys *JCParseQuerys;
@end

@implementation JCHappeningTonightHeaderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.JCParseQuerys = [JCParseQuerys sharedInstance];
    
    self.searchUpcomingGigs = [[JCSearchPageHTTPClient alloc]init];
    
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
    
    
        self.currentUser = [PFUser currentUser];

    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)buildannotations:(eventObject*)currentgig{

CLLocationCoordinate2D location;


        NSString *latitude = self.currentEvent.LatLong[@"lat"];
        NSString *Long = self.currentEvent.LatLong[@"long"];
        location.latitude = [latitude doubleValue];
        location.longitude = [Long doubleValue];
        self.eventannotation = [[JCAnnotation alloc]init];
        self.eventannotation.coordinate = location;
   
}


#pragma - Buttons

- (IBAction)SendMessage:(id)sender {
    
    
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
     NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"SelectFriends"]) {
        
        
        UINavigationController *SelectFriendsNav = (UINavigationController*)segue.destinationViewController;
        JCSelectFriends *SelectFreindsVC = [SelectFriendsNav viewControllers][0];
        //pass the senderVC a referance to the current event that need to be sent 
        SelectFreindsVC.currentEvent = self.currentEvent;
        
        NSLog(@"%@",SelectFreindsVC.currentEvent.eventTitle);
        
    }
    
}

- (IBAction)followArtist:(id)sender {

    //TODO set the button to following if the users already following the artist
    
    [self.JCParseQuerys UserFollowedArtist:self.currentEvent complectionBlock:^(NSError *error) {
       
        if (error) {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"There was a problem follwing that artist try again" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
            
        };
        
    }];
    
   [sender setTitle:@"Following" forState:UIControlStateNormal];
    
    
    
    
}//end of methid

#pragma - HelperMethods



-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@end
