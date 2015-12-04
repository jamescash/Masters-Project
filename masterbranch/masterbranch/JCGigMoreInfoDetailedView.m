//
//  JCGigMoreInfoDetailedView.m
//  PreAmp
//
//  Created by james cash on 30/11/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCGigMoreInfoDetailedView.h"

@interface JCGigMoreInfoDetailedView ()
@property (weak, nonatomic) IBOutlet MKMapView *MkMapView;
@property (strong,nonatomic) JCAnnotation *mapAnnotation;
@property (weak, nonatomic) IBOutlet UIImageView *UIImageArtistImage;
@property (weak, nonatomic) IBOutlet UILabel *UILableArtistName;
@property (weak, nonatomic) IBOutlet UILabel *UILableVenueAddress;
@property (weak, nonatomic) IBOutlet UILabel *UILableTime;

@end

@implementation JCGigMoreInfoDetailedView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self formatViewControllerWithJCEventObject:self.currentEventEventObject];
    [self addCustomButtonOnNavBar];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)formatViewControllerWithJCEventObject:(eventObject*)currentEvent{
    
    [self buildannotations:currentEvent];
    self.UIImageArtistImage.image = self.currentEventEventObject.photoDownload.image;
    
    self.UILableTime.text = [self formatDateString:currentEvent.eventDate];
    NSString *venueInfo = [NSString stringWithFormat:@"%@ - %@",currentEvent.venueName,currentEvent.county];
    self.UILableVenueAddress.text = venueInfo;
    self.UILableArtistName.text = currentEvent.eventTitle;
    
}

-(void)buildannotations:(eventObject*)currentEvent{
    
    CLLocationCoordinate2D location;
    
    
    NSString *latitude = currentEvent.LatLong[@"lat"];
    NSString *Long = currentEvent.LatLong[@"long"];
    location.latitude = [latitude doubleValue];
    location.longitude = [Long doubleValue];
    self.mapAnnotation = [[JCAnnotation alloc]init];
    self.mapAnnotation.coordinate = location;
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.01;
    span.longitudeDelta = 0.01;
    region.span = span;
    region.center = location;
    
    
    [self.MkMapView addAnnotation:self.mapAnnotation];
    [self.MkMapView setRegion:region animated:TRUE];
    [self.MkMapView regionThatFits:region];
    
}

#pragma - Helper Methods

-(NSString*)formatDateString: (NSString*)date{
    
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyy-MM-dd'T'HH:mm:ss"];
    NSDate *eventDateTime = [dateFormat dateFromString:date];
    
    
    dateFormat.dateStyle = NSDateFormatterMediumStyle;
    NSString *dayMonthString = [dateFormat stringFromDate:eventDateTime];
    [dateFormat setDateFormat:@"' at 'HH:mm"];
    NSString *timeString = [dateFormat stringFromDate:eventDateTime];
    
    
    [dateFormat setDateFormat:@"EEE"];
    NSString *dayString = [dateFormat stringFromDate:eventDateTime];
    
    [dateFormat setDateFormat:@"MM-dd"];
    
    
    return [NSString stringWithFormat:@"%@ %@%@",dayString,dayMonthString,timeString];
}

- (void)addCustomButtonOnNavBar
{
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [menuButton setImage:[UIImage imageNamed:@"iconBack.png"] forState:UIControlStateNormal];
    //[menuButton setImage:[UIImage imageNamed:@"iconMenu.png"] forState:UIControlStateHighlighted];
    menuButton.adjustsImageWhenDisabled = NO;
    //set the frame of the button to the size of the image (see note below)
    menuButton.frame = CGRectMake(0, 0, 40, 40);
    menuButton.opaque = YES;
    
    [menuButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    //create a UIBarButtonItem with the button as a custom view
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    self.navigationItem.leftBarButtonItem = customBarItem;
    
    
}

-(void)backButtonPressed{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
