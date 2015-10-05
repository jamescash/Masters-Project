//
//  JCHappeningTonightHeaderVC.m
//  masterbranch
//
//  Created by james cash on 23/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "JCHappeningTonightHeaderVC.h"
#import "JCSelectFriends.h"
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
@end

@implementation JCHappeningTonightHeaderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
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
    
    //1.first query the database to see if the artist exists
    //2.if we found an artist matching add that as a relation to the current user
    //3. if there was no artist save a new artist object to the backend and relat it to the current user
    
    [sender setTitle:@"Following" forState:UIControlStateNormal];
    PFQuery *query = [PFQuery queryWithClassName:@"Artist"];
    [query whereKey:@"artistName" equalTo:self.currentEvent.eventTitle];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@ error receving messages",error);
        }else{

            if ([objects count]>0) {
                //that artist exist so add it as a reation the current user.
                PFRelation *ArtistRelation = [self.currentUser relationForKey:@"ArtistRelation"];
                //add the artist to the users relation.
                [ArtistRelation addObject:objects[0]];
                [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if (error){
                        
                        NSLog(@"Error: %@ %@", error, [error localizedDescription]);
                    }else{
                        NSLog(@"artist already existed new relation saved");
                    }
                    
                }];//end of save current user in BG
                
            }else{
                
                //creat a new aritst object and save it to the backend and relat the user
                [self saveArtistToBackendAndAddRelationToUser];

            }
        }
    }];
    
}//end of methid

#pragma - HelperMethods

-(void)saveArtistToBackendAndAddRelationToUser{
    
    //1. save image file to database
    //2. go to bandsintown and get upcoming json
    //3. save artist object to backend with relation to the image and json sting of upcoming gigs
    NSData *fileData;
    NSString *fileName;
    //NSString *fileType;
    
    //static const CGSize size = {110, 240};
    //get current artsit image and resize it for fast upload and down loads
    //UIImage *artistImage = [self imageWithImage:self.currentEvent.photoDownload.image scaledToSize:size];
    
    if (self.currentEvent.photoDownload.image) {
        fileData = UIImagePNGRepresentation(self.currentEvent.photoDownload.image);
        fileName = @"artistImage.png";
    }else{
        fileData = UIImagePNGRepresentation([UIImage imageNamed:@"Placeholder.png"]);
        fileName = @"artistImage.png";
    }
    
    PFFile *file = [PFFile fileWithName:fileName data:fileData];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        
        //chaning the two asynrons upplaods to bacckend so users doesnt have to wait and only the second one happens if the first one
        //is sucesful
        
        if (error) {
            //show alert view and get user to start agin
            NSLog(@"Error: %@ %@", error, [error localizedDescription]);
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error :(" message:@"Please try to follow that artist again" delegate:self cancelButtonTitle:@"okay" otherButtonTitles:nil];
            [alert show];
        }else{
            
            //getind the upcoming gigs for that artist from cusomtom made class
            //TODO chin this api call save json results as a file and add it as a relation to the artist object
//            
//            [self.searchUpcomingGigs GetJsonForArtistUpcomingEvents:self.currentEvent.eventTitle andArtistMbid:self.currentEvent.mbidNumber completionblock:^(NSError *error, NSData *response) {
            
//                if (error) {
//                    NSLog(@"Error: %@ %@", error, [error localizedDescription]);
//                    
//                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error :(" message:@"Please try to follow that artist again" delegate:self cancelButtonTitle:@"okay" otherButtonTitles:nil];
//                    [alert show];
//                }else{
            
                    
                    
//                    NSString *jsonString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
                    
                    
                            
                            PFObject *artist = [PFObject objectWithClassName:@"Artist"];
                            [artist setObject:file forKey:@"atistImage"];
                            //[artist setObject:jsonString forKey:@"upcomingGigs"];
                            [artist setObject:self.currentEvent.eventTitle forKey:@"artistName"];
                            [artist setObject:self.currentEvent.mbidNumber forKey:@"mbidNumber"];
                    
//                     [PFCloud callFunctionInBackground:@"SaveArtistUpcomingGigsRelation"
//                                       withParameters:@{@"ID":artist.objectId}
//                                                block:^(NSString *result, NSError *error) {
//                                                    if (!error) {
//                                                        // result is @"Hello world!"
//                                                    
//                                                     }
//                                                }];
            
                    
                    
                        [artist saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                                
                                if (error) {
                                    
                                    NSLog(@"Error: %@ %@", error, [error localizedDescription]);
                                    
                                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oh no :(!" message:@"There was a problem saving that artist plaese try again" delegate:self cancelButtonTitle:@"okay" otherButtonTitles:nil];
                                    [alert show];
                                }else{
                                    
                                    
                                    NSLog(@"New artist saved");
                                    
                                    //now that we saved that artist to the data base we can relat it to the current user
                                    PFRelation *ArtistRelation = [self.currentUser relationForKey:@"ArtistRelation"];
                                    [ArtistRelation addObject:artist];
                                    
                                    
                                    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                                        if (error){
                                            
                                            NSLog(@"Error: %@ %@", error, [error localizedDescription]);
                                        }else{
                                            NSLog(@"artist relation should be saved");
                                        }
                                        
                                    }];//end of save current user in BG
                                    
                                }//save artist if/else
                                
                            }];//save artit in BG
                            
                        //}//save json if/else
                        
                    //}];//saving JSON file in backround
                    
               // }//search for upcoming gigs if/else
                
            //}];//searh for upcoming gigs call
            
        }//save image file to backend if/else
        
    }];//sava image file to backend
}

-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@end
