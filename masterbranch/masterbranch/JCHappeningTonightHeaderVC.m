//
//  JCHappeningTonightHeaderVC.m
//  masterbranch
//
//  Created by james cash on 23/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "JCHappeningTonightHeaderVC.h"
#import "JCSelectFriends.h"



@interface JCHappeningTonightHeaderVC ()

- (IBAction)SendMessage:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *topBackGround;
@property (weak, nonatomic) IBOutlet MKMapView *EventLocation;
@property (weak, nonatomic) IBOutlet UILabel *ArtistNameAndVenue;
@property (weak, nonatomic) IBOutlet UILabel *EventLoactionLable;
@property (nonatomic,strong) PFUser *currentUser;
- (IBAction)followArtist:(id)sender;
@property (strong,nonatomic) JCAnnotation *eventannotation;
@end

@implementation JCHappeningTonightHeaderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

    NSData *fileData;
    NSString *fileName;
    //NSString *fileType;
    
    //static const CGSize size = {110, 240};
    //get current artsit image and resize it for fast upload and down loads
    //UIImage *artistImage = [self imageWithImage:self.currentEvent.photoDownload.image scaledToSize:size];
    fileData = UIImagePNGRepresentation(self.currentEvent.photoDownload.image);
    fileName = @"artistImage.png";
    //fileType = @"artistImage";
    
    PFFile *file = [PFFile fileWithName:fileName data:fileData];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        
        //chaning the two asynrons upplaods to parse so users dont have to wait and only the second one happens if the first one
        //is sucesful
        
        
        if (error) {
            //show alert view
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error :(" message:@"Please try to follow that artist again" delegate:self cancelButtonTitle:@"okay" otherButtonTitles:nil];
            [alert show];
        }else{
            
            NSLog(@"event title %@", self.currentEvent.eventTitle);
            
            //file saved sucessfully now lets link it with a PFobject so we can send it
            PFObject *artist = [PFObject objectWithClassName:@"Artist"];
            [artist setObject:file forKey:@"atistImage"];
            //[artist setObject:fileType forKey:@"fileType"];
            [artist setObject:self.currentEvent.eventTitle forKey:@"artistName"];
            [artist setObject:self.currentEvent.mbidNumber forKey:@"mbidNumber"];
            //[artist setObject:[[PFUser currentUser]objectId] forKey:@"followerId"];
            //[artist setObject:[[PFUser currentUser]username] forKey:@"followerName"];
            [artist saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                
                if (error) {
                    //show alert view
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oh shit!" message:@"There was a problem saving that artist plaese try again" delegate:self cancelButtonTitle:@"okay" otherButtonTitles:nil];
                    [alert show];
                }else{
                    
                    //artist object saved now lets relate it to current user
                    
                    NSLog(@"artist saved");
                    [sender setTitle:@"Following" forState:UIControlStateNormal];
            PFRelation *ArtistRelation = [self.currentUser relationForKey:@"ArtistRelation"];
                    [ArtistRelation addObject:artist];
                    
                    
                    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                        if (error){
                            
                            NSLog(@"error saving artist relation %@",error);
                        }else{
                            NSLog(@"artist relation should be saved");
                        }
                        
                    }];

                }
                
            }];
            
        }
        

        
    }];
}

#pragma - HelperMethods

-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
