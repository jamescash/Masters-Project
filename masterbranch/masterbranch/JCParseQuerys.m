//
//  JCParseQuerys.m
//  PreAmp
//
//  Created by james cash on 03/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCParseQuerys.h"
#import "UIImage+Resize.h"
#import "JCMusicDiaryArtistObject.h"

#import "JCConstants.h"



@interface JCParseQuerys ()
@property (nonatomic,strong) PFRelation *artistRelations;
@property (nonatomic,strong) PFRelation *upComingGigsRelation;
@property (nonatomic,strong) PFRelation *FriendRelations;
@property (nonatomic,strong) PFUser   *currentUser;

@property (nonatomic,strong) NSString *going;
@property (nonatomic,strong) NSString *maybe;
@property (nonatomic,strong) NSString *notGoing;
@property (nonatomic,strong) NSString *gotTickets;



@property (nonatomic,strong) NSMutableDictionary *artistImages;




@end

@implementation JCParseQuerys{
    int UpcomingGigsLoopCounter;
}


+ (JCParseQuerys*)sharedInstance
{
    static JCParseQuerys *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[JCParseQuerys alloc] init];
    });
    return _sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        self.MyArtist =             [[NSMutableArray alloc]init];
        self.artistImages =         [[NSMutableDictionary alloc]init];
        self.currentUser =          [PFUser currentUser];
        self.MyArtistUpcomingGigs = [[NSMutableArray alloc]init];
        self.going = JCUserEventUserGoing;
        self.gotTickets = JCUserEventUserGotTickets;
        self.maybe = JCUserEventUserMaybeGoing;
        self.notGoing =JCUserEventUserNotGoing;
    
    }
    return self;
}



-(void)getMyAtrits:(void(^)(NSError* error,NSArray* response))finishedGettingMyAtrits{
    
   //get my artist from local data storage
    //if there not there get them from the server and save them ready to be got from local data storage the nect time.
    
    [self getMyAtritsfromLocalDataStorage:^(NSError *error, NSArray *response) {
       
       if (error) {
           NSLog(@"error getting artist locally %@",error);
       }else if ([response count]==0){
           [self getMyAtritsfromTheServer:^(NSError *error, NSArray *response) {
               if (error) {
                   NSLog(@"error getting artist from server %@",error);
                   finishedGettingMyAtrits(error,nil);
               }else{
                   NSLog(@"get artist from server");
                   finishedGettingMyAtrits(nil,response);
               }
               
           }];
           
       }else{
           NSLog(@"get artist from local data storage");
           finishedGettingMyAtrits(nil,response);
       }
       
   }];
}
-(void)getMyAtritsfromLocalDataStorage:(void(^)(NSError* error,NSArray* response))finishedGettingMyAtritsfromLocalDataStorage{
    
    
    PFQuery *myAtritsfromLocalDataStorage  = [PFQuery queryWithClassName:@"Artist"];
    [myAtritsfromLocalDataStorage orderByAscending:@"artistName"];
    [myAtritsfromLocalDataStorage fromLocalDatastore];
    [myAtritsfromLocalDataStorage findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"Error coming form inside loaca data get artist relations %@",error);
            
            finishedGettingMyAtritsfromLocalDataStorage(error,nil);
        }else{
            finishedGettingMyAtritsfromLocalDataStorage(nil,objects);
        }
    }];
    
    
    
}
-(void)getMyAtritsfromTheServer:(void(^)(NSError* error,NSArray* response))finishedgetMyAtritsfromTheServer{
    
    PFRelation *artistRelation = [[PFUser currentUser] objectForKey:@"ArtistRelation"];
    PFQuery *myAtritsfromTheServer  = [artistRelation query];
    [myAtritsfromTheServer orderByAscending:@"artistName"];
    [myAtritsfromTheServer findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"Error coming form inside get my artist relations %@",error);
            
            finishedgetMyAtritsfromTheServer(error,nil);
        }else{
            //save my artist locally
            [PFObject pinAllInBackground:objects withName:@"MyArtist"];
            finishedgetMyAtritsfromTheServer(nil,objects);
        }
    }];
}


-(void)getMyFriends:(void (^)(NSError *, NSArray *))finishedGettingMyFriends{
    
    [self getMyFriendsfromLocalDataStorage:^(NSError *error, NSArray *response) {
        
        if (error) {
            finishedGettingMyFriends(error,nil);
            NSLog(@"error getting friends locally %@",error);

        }else if ([response count]==0){
            [self getMyFriendsfromTheServer:^(NSError *error, NSArray *response) {
                if (error) {
                    NSLog(@"error getting friends from server %@",error);
                    finishedGettingMyFriends(error,nil);
                }else{
                    NSLog(@"get friends from server");
                    finishedGettingMyFriends(nil,response);

                }
                
            }];
                
        }else{
            NSLog(@"get friends from local data storage");
            finishedGettingMyFriends(nil,response);
        }
    }];
    
};
-(void)getMyFriendsfromLocalDataStorage:(void (^)(NSError *error, NSArray *response))finishedGettingMyFriendsfromLocalDataStorage{
    
     PFQuery *MyFriendsfromLocalDataStorage  = [PFUser query];
    [MyFriendsfromLocalDataStorage fromLocalDatastore];
    [MyFriendsfromLocalDataStorage orderByAscending:@"username"];
    //TODO uncomment line so that users cant see themselfs in frineds list
    //[MyFriendsfromLocalDataStorage whereKey:@"objectId" notEqualTo:[[PFUser currentUser]objectId]];
    [MyFriendsfromLocalDataStorage findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"Error coming form insode get my firends relations %@",error);
            finishedGettingMyFriendsfromLocalDataStorage(error,nil);
            
        }else{
            finishedGettingMyFriendsfromLocalDataStorage(nil,objects);
        }
        
    }];
};
-(void)getMyFriendsfromTheServer:(void (^)(NSError *error, NSArray *response))finishedGettingMyFriendsfromTheServer{
    
    PFRelation *friendsRelation = [[PFUser currentUser] objectForKey:@"FriendsRelation"];
    PFQuery *myFriendsfromTheServer  = [friendsRelation query];
    [myFriendsfromTheServer orderByAscending:@"username"];
    [myFriendsfromTheServer findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"Error coming form insode get my firends relations %@",error);
            finishedGettingMyFriendsfromTheServer(error,nil);
            
        }else{
            [PFObject pinAllInBackground:objects withName:@"MyFriends"];
            finishedGettingMyFriendsfromTheServer(nil,objects);
        }
        
    }];
};


-(void)getMyInvitesforType:(NSString*)userEventsType completionblock:(void(^)(NSError* error,NSArray* response))finishedGettingMyInvites{

     NSDate *now = [NSDate date];
   
    //TODO return nill here if userEventType is empy cused a crash!!! 
    
       PFQuery *getMyInvites = [PFQuery queryWithClassName:JCParseClassUserEvents];
       [getMyInvites whereKey:JCUserEventUsersInvited equalTo:[[PFUser currentUser]objectId]];
    
    
       if ([userEventsType isEqualToString:JCUserEventUsersTypeUpcoming]) {
         [getMyInvites whereKey:JCUserEventUsersTheEventDate greaterThanOrEqualTo:now];
         [getMyInvites orderByAscending:JCUserEventUsersTheEventDate];

       
       }else if ([userEventsType isEqualToString:JCUserEventUsersTypePast]){
           [getMyInvites whereKey:JCUserEventUsersTheEventDate lessThan:now];
           [getMyInvites orderByDescending:JCUserEventUsersTheEventDate];

       
       }else if ([userEventsType isEqualToString:JCUserEventUsersTypeSent]){
           [getMyInvites whereKey:JCUserEventUsersEventHostNameUserName equalTo:self.currentUser.username];
           [getMyInvites orderByDescending:JCParseGeneralKeyCreatedAt];
       }
    
        [getMyInvites findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) { self.MyInvties = [[NSArray alloc]init];
              self.MyInvties = objects;
              finishedGettingMyInvites(nil,objects);
          }];

};
-(void)getMyAtritsUpComingGigs:(BOOL)onlyIrishGigs comletionblock:(void (^)(NSError*, NSMutableArray*))finishedGettingMyAtritsUpcomingGigs{
    
    
    //UpcomingGigsLoopCounter = 0;

    
    
    //we need to go get our artist relation
    [self getMyAtrits:^(NSError *error, NSArray *response) {
        
        if (error) {
            NSLog(@"error getmyartist %@",error);
        }else{
            NSMutableArray *myartist = [[NSMutableArray alloc]init];
            [myartist addObjectsFromArray:response];
            UpcomingGigsLoopCounter = 0;
            
            NSMutableArray *unsortedDiaryObjects = [[NSMutableArray alloc]init];
  
            
            for (PFObject *artist in myartist) {
                
                PFRelation *upcomingGigRelation = [artist objectForKey:@"upComingGigsRel"];
 
                if (!upcomingGigRelation) {
                    UpcomingGigsLoopCounter ++;
                }
                
                //TO irish english gigs coming back odd something wrong with this query
                PFQuery *query  = [upcomingGigRelation query];
                if (onlyIrishGigs) {
                    [query whereKey:@"venueCounty" equalTo:@"Ireland"];
                }else{
                    [query whereKey:@"venueCounty" equalTo:@"United Kingdom"];
                }
                 //[query orderByAscending:@"datetime"];
                [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                    
                    if (error) {
                        NSLog(@"upComingGigsRel error %@",error);
                    }else{


                        [objects  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {

                            JCMusicDiaryArtistObject *diaryObject = [[JCMusicDiaryArtistObject alloc]initWithArtits:artist andupComingGig:obj];
                            
                            if (diaryObject != nil){
                                [unsortedDiaryObjects addObject:diaryObject];
                            };
                        
                          }];//end of enum using block loop
                        

                        UpcomingGigsLoopCounter ++;
                        
                        
                        if (UpcomingGigsLoopCounter == ([myartist count])) {

                            
                            NSMutableArray *arrayWithDuplicatsRemoved = [self RemoveDuplicatsfromArray:unsortedDiaryObjects];
                            finishedGettingMyAtritsUpcomingGigs(nil,arrayWithDuplicatsRemoved);
                        };
                        
                       }
                    }];
            }//end of every artist in myartist loop
        
         }
    }];
    
}

-(void)getEventComments:(PFObject *)event complectionBlock:(void (^)(NSError *, NSMutableArray *))finishedgettingEventComments{
    
    PFQuery *getEventCommentsActivitys = [PFQuery queryWithClassName:@"Activity"];
    [getEventCommentsActivitys whereKey:@"type" equalTo:@"userComment"];
    [getEventCommentsActivitys whereKey:@"toEvent" equalTo:event];
    [getEventCommentsActivitys orderByAscending:@"createdAt"];
    
    
    [getEventCommentsActivitys findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"%@ error receving messages",error);
            finishedgettingEventComments(error,nil);
            
        }else{
        
            NSMutableArray *commentActivitys = [[NSMutableArray alloc]init];
            [commentActivitys addObjectsFromArray:objects];
            
            finishedgettingEventComments(nil,commentActivitys);

           
        }
    
    }];
    
    
    
}
-(void)getUpcomingGigsforAartis:(PFObject *)artist onMonthIndex:(int)monthIndex complectionblock:(void (^)(NSError *, NSArray *))getUpcomingGigsforAartis{
    
    
                PFRelation *upcomingGigd = [artist objectForKey:@"upComingGigsRel"];
                PFQuery *query  = [upcomingGigd query];
                [query whereKey:@"monthIndex" equalTo:[NSNumber numberWithInteger:(monthIndex-1)]];
                [query whereKey:@"venueCounty" equalTo:@"Ireland"];
                [query orderByAscending:@"datetime"];
                [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                    
                    if (error) {
                        NSLog(@"upComingGigsRel error %@",error);
                    }else{
                         getUpcomingGigsforAartis(nil,objects);
                        };
                 }];
    
}



// Use/Filling Artist Images Dictionary
-(void)DownloadImageForArtist:(NSString*)artistName completionBlock:(void(^)(NSError*error,UIImage* image))finishedDownloadingImag
{
    
    //if we already downloaded the image then re-use it here
    if ([self.artistImages objectForKey:artistName]) {
        
        UIImage *artistImage = [self.artistImages objectForKey:artistName];
        finishedDownloadingImag(nil,artistImage);
    }else{
    
        //else go and download it and store it for use later on

    PFQuery *getArtistImage = [PFQuery queryWithClassName:@"Artist"];
    [getArtistImage whereKey:@"artistName" equalTo:artistName];
    
    [getArtistImage findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (error) {
            finishedDownloadingImag(error,nil);
            
        }else{
            
            PFObject *aritstObject = objects[0];
            
            PFFile *artistImage = [aritstObject objectForKey:@"thmbnailAtistImage"];
            
            [artistImage getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
                if (!error) {
                    UIImage *eventImage = [UIImage imageWithData:data];

                    if (![self.artistImages objectForKey:artistName]) {
                        
                        [self.artistImages setObject:eventImage forKey:artistName];
                    }
                    
                    
                    finishedDownloadingImag(nil,eventImage);
                } else {
                    finishedDownloadingImag( error,nil);
                }
            }];
            
        }
    }];

   }
}
-(void)getPreAmpUsersThatMatchTheseFBids:(NSMutableArray*)FBIds completionblock:(void(^)(NSError* error,NSArray* response))finishedGettingPreAmpUser{
    
    
            PFQuery *getPreAmpUsersThatMatchFBid = [PFUser query];
            [getPreAmpUsersThatMatchFBid whereKey:@"facebookId" containedIn:FBIds];
 
    
            [getPreAmpUsersThatMatchFBid findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                
                if (error) {
                    finishedGettingPreAmpUser(error,nil);
                }else{
                    finishedGettingPreAmpUser(nil,objects);
                }
                
            }];
    
}
//posting



-(void)saveCommentToBackend:(NSDictionary*)userInfo complectionBlock: (void(^)(NSError* error))finishedsavingComment{
    
    
    NSString *commentText = [userInfo objectForKey:@"comment"];
    PFObject *eventObject = [userInfo objectForKey:@"eventId"];
    
    if (commentText && commentText.length != 0) {

        PFObject *comment = [PFObject objectWithClassName:JCParseClassActivity];
        [comment setObject:JCUActivityTypeUserComment forKey:JCUserActivityType];
        [comment setObject:[PFUser currentUser] forKey:JCUserActivityFromUser];
        [comment setObject:[PFUser currentUser] forKey:JCUserActivityCommentOwner];
        [comment setObject:eventObject forKey:@"toEvent"];
        [comment setObject:commentText forKey:JCUserActivityContent];
        
        PFACL *ACL = [PFACL ACLWithUser:[PFUser currentUser]];
        [ACL setPublicReadAccess:YES];
        comment.ACL = ACL;
        
        
        [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            
            if (error) {
                
                finishedsavingComment(error);
            }else{
                
                finishedsavingComment(nil);
                NSLog(@"comment posted");
            }
        }];
    }
    
}




-(void)creatUserEvent:(eventObject*)currentEvent invitedUsers: (NSArray*)recipientIds complectionBlock:(void(^)(NSError* error))finishedCreatingUserEvent{
    
    
    //In the middel of saving UserEvent
    
    //1. event photo
    //2. save userEvent
    //3. Save user activity
    //4. Upload and create NSNotification
    
    // going to try sending and story at full res to see what its like, we will need full res images to make the events UI work well
    //static const CGSize thumbnialSize = {110, 240};
    
    //UIImage *EventThumbnail = [self.currentEvent.photoDownload.image resizedImageToSize:thumbnialSize];
    
    NSData *fileData;
    NSString *fileName;
    NSString *fileType;
    
    fileData = UIImagePNGRepresentation(currentEvent.photoDownload.image);
    fileName = @"image.png";
    fileType = @"EventImage";
    
    PFFile *file = [PFFile fileWithName:fileName data:fileData];
    
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        
        //chaning the two asynrons upplaods to parse so users dont have to wait and only the second one happens if the first one
        //is sucesful
        
        
        if (error) {
           
            finishedCreatingUserEvent(error);
            
        }else{
            //file saved sucessfully now lets link it with a PFobject so we can send it
            PFObject *UserEvent = [PFObject objectWithClassName:JCParseClassUserEvents];
            [UserEvent setObject:file forKey:JCUserEventUsersEventPhoto];
            [UserEvent setObject:currentEvent.eventTitle forKey:JCUserEventUsersEventTitle];
            [UserEvent setObject:[[PFUser currentUser]username] forKey:JCUserEventUsersEventHostNameUserName];
            [UserEvent setObject:[self formatDateStringIntoNSDate:currentEvent.eventDate] forKey: JCUserEventUsersTheEventDate];
            [UserEvent setObject:currentEvent.venueName forKey:JCUserEventUsersEventVenue];
            [UserEvent setObject:[[PFUser currentUser]objectId] forKey:JCUserEventUsersEventHostId];
            [UserEvent setObject:currentEvent.county forKey:JCUserEventUsersEventCity];
            [UserEvent setObject:recipientIds forKey:JCUserEventUsersInvited];
            [UserEvent setObject:recipientIds forKey:JCUserEventUsersSubscribedForNotifications];
            
            NSLog(@"%@",recipientIds);
            
            [UserEvent saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                
                if (error) {
                    finishedCreatingUserEvent(error);

                }else{
                    finishedCreatingUserEvent(nil);
                }
                
            }];
            
        }
        
    }];
    
    
}

-(void)UserFollowedArtist:(eventObject *)currentEvent complectionBlock:(void (^)(NSError *))finishedSavingArtist{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Artist"];
                                            //this is artist name, bad varible naming.
    [query whereKey:@"artistName" equalTo:currentEvent.eventTitle];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@ error receving messages",error);
        }else{
            
            if ([objects count]>0) {
                //that artist exist so add it as a reation the current user.
                PFRelation *ArtistRelation = [self.currentUser relationForKey:@"ArtistRelation"];
                //add the artist to the users relation.
                
                [ArtistRelation addObject:[objects firstObject]];
                [[objects firstObject] pinInBackgroundWithName:@"MyArtist"];
                
                [self.currentUser saveInBackground];
                
                
            }else{
                
                //creat a new aritst object and save it to the backend and relat the user
                [self saveArtistToBackendAndAddRelationToUser:currentEvent];
                
            }
        }
    }];
};

-(void)saveArtistToBackendAndAddRelationToUser:(eventObject*)currentEvent {
    
    //1. save image file to database
    //2. go to bandsintown and get upcoming json
    //3. save artist object to backend with relation to the image and json sting of upcoming gigs
    NSData *fileData;
    NSString *fileName;
    //NSString *fileType;
    


    
    if (currentEvent.photoDownload.image) {
        fileData = UIImagePNGRepresentation(currentEvent.photoDownload.image);
        fileName = @"artistImage.png";
    }else{
        fileData = UIImagePNGRepresentation([UIImage imageNamed:@"Placeholder.png"]);
        fileName = @"artistImage.png";
    }
    
    PFFile *FullSizeArtistPhoto = [PFFile fileWithName:fileName data:fileData];
    [FullSizeArtistPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        
        //chaning the two asynrons upplaods to bacckend so users doesnt have to wait and only the second one happens if the first one
        //is sucesful
        
        if (error) {
            //show alert view and get user to start agin
            NSLog(@"Error: %@ %@", error, [error localizedDescription]);
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error :(" message:@"Please try to follow that artist again" delegate:self cancelButtonTitle:@"okay" otherButtonTitles:nil];
            [alert show];
        }else{
            
            NSData *fileData;
            NSString *fileName;
            
            //resize the image and save a thumbnail
            CGSize size = {150, 150};
            UIImage *thumbArtistImage = [currentEvent.photoDownload.image resizedImageToFitInSize:size scaleIfSmaller:YES];
            
                fileData = UIImagePNGRepresentation(thumbArtistImage);
                fileName = @"thumbnailartistImage.png";
         
            PFFile *thumbnailArtistImage = [PFFile fileWithName:fileName data:fileData];

            [thumbnailArtistImage saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                
                
                if (error) {
                    //show alert view and get user to start agin
                    NSLog(@"Error: %@ %@", error, [error localizedDescription]);
                    
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error :(" message:@"Please try to follow that artist again" delegate:self cancelButtonTitle:@"okay" otherButtonTitles:nil];
                    [alert show];
                }else{
                    
                    
                    
                    PFObject *artist = [PFObject objectWithClassName:@"Artist"];
                    [artist setObject:FullSizeArtistPhoto forKey:@"atistImage"];
                    [artist setObject:thumbnailArtistImage forKey:@"thmbnailAtistImage"];
                    [artist setObject:currentEvent.eventTitle forKey:@"artistName"];
                    [artist setObject:currentEvent.mbidNumber forKey:@"mbidNumber"];
                    
                    
                    
                    [artist saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                        
                        if (error) {
                            
                            NSLog(@"Error: %@ %@", error, [error localizedDescription]);
                            
                            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oh no :(!" message:@"There was a problem saving that artist plaese try again" delegate:self cancelButtonTitle:@"okay" otherButtonTitles:nil];
                            [alert show];
                        }else{
                            [artist pinInBackgroundWithName:@"MyArtist"];
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
                
                
                
                }
                
            
            }];
            
          
            
            
        }//save image file to backend if/else
        
    }];//sava image file to backend
}

-(void)postActivtyForUserActionEventStatus:(NSString*)usersStauts eventobject:(PFObject*) eventobject completionBlock: (void(^)(NSError* error))finishedpostActivtyForUser{
    
    PFObject *userEventStatus = [PFObject objectWithClassName:@"Activity"];
    [userEventStatus setObject:@"eventStatus" forKey:@"type"];
    [userEventStatus setObject:[PFUser currentUser] forKey:@"fromUser"];
    [userEventStatus setObject:eventobject forKey:@"toEvent"];
    [userEventStatus setObject:usersStauts forKey:@"content"];
    
    
    
    [userEventStatus saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        
        if (error) {
            
            finishedpostActivtyForUser(error);
        }else{
            
            finishedpostActivtyForUser(nil);
        }
    }];
    
}

-(void)getUserEventStatus:(PFObject *)eventobject completionBlock:(void (^)(NSError *, PFObject *))finishedgetActivtyForUser{
    
    PFQuery *getUserEventStatus = [PFQuery queryWithClassName:@"Activity"];
    [getUserEventStatus whereKey:@"type" equalTo:@"eventStatus"];
    [getUserEventStatus whereKey:@"toEvent" equalTo:eventobject];
    [getUserEventStatus whereKey:@"fromUser" equalTo:self.currentUser];
     
    [getUserEventStatus findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (error) {
            finishedgetActivtyForUser(error,nil);
        }else {
            
            if ([objects count]!=0) {
                PFObject *activity = [objects firstObject];
                finishedgetActivtyForUser(nil,activity);
            }else{
                finishedgetActivtyForUser(nil,nil);

            }
            
        }
        
    }];
}

-(void)updateUserEventStatus:(NSString *)usersStauts eventobject:(PFObject*) eventobject completionBlock:(void (^)(NSError *))finishedupdatingUserEventStatus{
    
    
    //See if the user has a current event status for this event if they do update it
    //if they dont creat a new one
    [self getUserEventStatus:eventobject completionBlock:^(NSError *error, PFObject *userEventStatusActivity) {
        
        if (error) {
            NSLog(@"error getting user event stauts %@",error);
            finishedupdatingUserEventStatus(error);
            
        }else {
            
            if (userEventStatusActivity) {
                [userEventStatusActivity setObject:usersStauts forKey:@"content"];
                [userEventStatusActivity saveInBackground];
                finishedupdatingUserEventStatus(nil);

            }else{
                
                [self postActivtyForUserActionEventStatus:usersStauts eventobject:eventobject completionBlock:^(NSError *error) {
                    
                    if (error) {
                        NSLog(@"error changing event status");
                    }else{
                        finishedupdatingUserEventStatus(nil);
                        }
                    
                }];
                
            }
        }
    }];
}

-(void)getUsersAttendingUserEvent:(PFObject *)eventobject completionBlock:(void (^)(NSError *, NSMutableDictionary *))finishedgettingUsersAttendingUserEvent{
    
    PFQuery *getUserEventStatus = [PFQuery queryWithClassName:JCParseClassActivity];
    [getUserEventStatus whereKey:JCUserActivityType equalTo:@"eventStatus"];
    [getUserEventStatus whereKey:@"toEvent" equalTo:eventobject];

    [getUserEventStatus findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (error) {
            finishedgettingUsersAttendingUserEvent(error,nil);
        }else {
            
                NSMutableArray *going = [[NSMutableArray alloc]init];
                NSMutableArray *notGoing = [[NSMutableArray alloc]init];
                NSMutableArray *maybe = [[NSMutableArray alloc]init];
                NSMutableArray *gotTickets = [[NSMutableArray alloc]init];
                NSMutableDictionary *returnDic = [[NSMutableDictionary alloc]init];

            
            for (PFObject *activity in objects) {
                
                NSString *status = [activity objectForKey:@"content"];
                if ([status isEqualToString:JCUserEventUserGoing]) {
                    [going addObject:[activity objectForKey:@"fromUser"]];
                }else if ([status isEqualToString:JCUserEventUserNotGoing]){
                    [notGoing addObject:[activity objectForKey:@"fromUser"]];
                }else if ([status isEqualToString:JCUserEventUserMaybeGoing]){
                    [maybe addObject:[activity objectForKey:@"fromUser"]];
                }else if ([status isEqualToString:JCUserEventUserGotTickets]){
                    [gotTickets addObject:[activity objectForKey:@"fromUser"]];
                };
             }
            
            [returnDic setObject:going forKey:JCUserEventUserGoing];
            [returnDic setObject:notGoing forKey:JCUserEventUserNotGoing];
            [returnDic setObject:maybe forKey:JCUserEventUserMaybeGoing];
            [returnDic setObject:gotTickets forKey:JCUserEventUserGotTickets];

           
            finishedgettingUsersAttendingUserEvent(nil,returnDic);
        }
        
    }];
    
}

#pragma - helper methods

-(NSMutableArray*)RemoveDuplicatsfromArray:(NSMutableArray*) originalArray{
    
    
    NSMutableArray *duplicatesRemoved = [NSMutableArray array];
    NSMutableSet *seenComarDics = [NSMutableSet set];
    for (JCMusicDiaryArtistObject *item in originalArray) {
        
        NSString *artistname = [item.artist objectForKey:@"artistName"];
        NSString *month = [self monthforindex:item.dateComponents.month];
        
        NSDictionary *comparDic = @{@"artistname":artistname,@"month":month};
        
        if ([seenComarDics containsObject:comparDic]) {
            continue;
        }
        [seenComarDics addObject:comparDic];
        [duplicatesRemoved addObject:item];
    }
    
    return duplicatesRemoved;
    
};

-(NSString*)monthforindex:(int)monthindex{
    
    switch (monthindex) {
        case 1:
            return  @"January";
            break;
        case 2:
            return  @"February";
            break;
        case 3:
            return  @"March";
            break;
        case 4:
            return  @"Aplri";
            break;
        case 5:
             return  @"May";
            
            break;
        case 6:
           return  @"June";
            
            break;
        case 7:
            return  @"July";
            
            break;
        case 8:
            return @"August";
            
            break;
        case 9:
            return @"September";
            
            break;
        case 10:
            return  @"October";
            
            break;
        case 11:
            return @"November";
            
            break;
        case 12:
            return @"December";
            break;
        default:
            NSLog(@"default");
            break;
            
    }

    NSLog(@"month index fail");
    return nil;

}

-(NSDate*)formatDateStringIntoNSDate: (NSString*)date{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:BITJSONDateUnformatted];
    NSDate *eventDateTime = [dateFormat dateFromString:date];
    return eventDateTime;
}

@end



//-(void)getMyAtritsUpComingGigs:(BOOL)onlyIrishGigs comletionblock:(void (^)(NSError*, NSMutableArray*))finishedGettingMyAtritsUpcomingGigs{
//
//
//   //TODO make this dynamic so when you fav a new artist the music diary update's
//
//    UpcomingGigsLoopCounter = 0;
//
//
//         //we need to go get our artist relation
//        [self getMyAtrits:^(NSError *error, NSArray *response) {
//
//            if (error) {
//                NSLog(@"error getmyartist %@",error);
//            }else{
//
//            self.MyArtist = [[NSMutableArray alloc]init];
//            [self .MyArtist addObjectsFromArray:response];
//
//            self.MyArtistUpcomingGigs = [[NSMutableArray alloc]init];
//
//
//            UpcomingGigsLoopCounter = 0;
//
//            for (PFObject *artist in self.MyArtist) {
//
//             self.upComingGigsRelation = [artist objectForKey:@"upComingGigsRel"];
//             PFQuery *query  = [self.upComingGigsRelation query];
//
//
//                if (onlyIrishGigs) {
//                [query whereKey:@"venueCounty" equalTo:@"Ireland"];
//                }
//
//
//            [query orderByAscending:@"datetime"];
//            [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
//
//                 if (error) {
//                     NSLog(@"upComingGigsRel error %@",error);
//                 }else{
//
//                     //NSArray *aritstUpcomingGigs = objects;
//                     UpcomingGigsLoopCounter ++;
//                     [self.MyArtistUpcomingGigs addObjectsFromArray:objects];
//                     //[self.MyArtistUpcomingGigs setObject:aritstUpcomingGigs forKey:[artist objectForKey:@"artistName"]];
//
//                 if (UpcomingGigsLoopCounter == ([self.MyArtist count])) {
//
//
//                     finishedGettingMyAtritsUpcomingGigs(nil,self.MyArtistUpcomingGigs);
//                 };
//                }
//
//
//             }];
//
//            }
//           }
//        }];
//
//}

//
//-(void)updateUserEventStatus:(NSString *)usersStauts eventobjectId:(NSString *)eventobjectId completionBlock:(void (^)(NSError *))finishedupdatingUserEventStatus{
//
//
//    //See if the user has a current event status for this event if they do update it
//    //if they dont creat a new one
//    //now we have a recorde of the users past event status and there future one
//    //then we can add and remove them from the nessasery array in the actul current event object
//
//
//    [self getUserEventStatus:eventobjectId completionBlock:^(NSError *error, PFObject *userEventStatusActivity) {
//
//        if (error) {
//            NSLog(@"error getting user event stauts %@",error);
//            finishedupdatingUserEventStatus(error);
//
//        }else {
//
//            if (userEventStatusActivity) {
//                NSLog(@"userEventStatusActivity %@",userEventStatusActivity);
//
//                NSString *oldEventStatus = [userEventStatusActivity objectForKey:@"content"];
//                NSLog(@"oldEventStatus %@",oldEventStatus);
//
//
//                [userEventStatusActivity setObject:usersStauts forKey:@"content"];
//
//                [userEventStatusActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
//
//
//                    PFQuery *eventQuery = [PFQuery queryWithClassName:@"UserEvent"];
//                    [eventQuery whereKey:@"objectId" equalTo:eventobjectId];
//                    [eventQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
//
//                        if (error) {
//                            finishedupdatingUserEventStatus(error);
//
//                        }else{
//
//
//                        if (oldEventStatus) {
//                            PFObject *userEvent = [objects lastObject];
//                            NSMutableArray *arrayContainingUserIdFromOldStauts = [[NSMutableArray alloc]init];
//                            arrayContainingUserIdFromOldStauts = [userEvent objectForKey:oldEventStatus];
//                            NSLog(@"arrayContainingUserIdFromOldStauts 1 %@",arrayContainingUserIdFromOldStauts);
//
//                            for (NSString *userId in arrayContainingUserIdFromOldStauts) {
//                                if (userId == self.currentUser.objectId) {
//                                    [arrayContainingUserIdFromOldStauts removeObject:userId];
//                                    break;
//                                }
//                            }
//
//                            NSLog(@"arrayContainingUserIdFromOldStauts %@",arrayContainingUserIdFromOldStauts);
//
//                            [userEvent addObject:arrayContainingUserIdFromOldStauts forKey:oldEventStatus];
//
//                            NSMutableArray *arrayForUsersNewEventStauts = [[NSMutableArray alloc]init];
//                            arrayForUsersNewEventStauts = [userEvent objectForKey:usersStauts];
//                            NSLog(@"arrayForUsersNewEventStauts 1 %@",arrayForUsersNewEventStauts);
//
//                            [arrayForUsersNewEventStauts addObject:self.currentUser.objectId];
//                            [userEvent addObject:arrayForUsersNewEventStauts forKey:usersStauts];
//                            NSLog(@"arrayForUsersNewEventStauts 2 %@",arrayForUsersNewEventStauts);
//
//                            [userEvent saveInBackground];
//                            finishedupdatingUserEventStatus(nil);
//
//
//
//                        }else{
//                            PFObject *userEvent = [objects lastObject];
//                            NSMutableArray *arrayForUsersNewEventStauts = [[NSMutableArray alloc]init];
//                            arrayForUsersNewEventStauts = [userEvent objectForKey:usersStauts];
//                            NSLog(@"arrayForUsersNewEventStauts 1.1 %@",arrayForUsersNewEventStauts);
//
//                            [arrayForUsersNewEventStauts addObject:self.currentUser.objectId];
//                            [userEvent addObject:arrayForUsersNewEventStauts forKey:usersStauts];
//                            NSLog(@"arrayForUsersNewEventStauts 2.1 %@",arrayForUsersNewEventStauts);
//
//                            [userEvent saveInBackground];
//                            finishedupdatingUserEventStatus(nil);
//
//                        }
//
//
//
//                        }
//                    }];
//
//
//
//                }];
//            }else{
//
//                [self postActivtyForUserActionEventStatus:usersStauts eventobjectId:eventobjectId completionBlock:^(NSError *error) {
//
//                    if (error) {
//                        NSLog(@"error changing event status");
//                    }else{
//
//                        PFQuery *eventQuery = [PFQuery queryWithClassName:@"UserEvent"];
//                        [eventQuery whereKey:@"objectId" equalTo:eventobjectId];
//                        [eventQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
//
//                            if (error) {
//
//                                finishedupdatingUserEventStatus(error);
//
//                            }else{
//                                PFObject *userEvent = [objects lastObject];
//                                NSMutableArray *arrayForUsersNewEventStauts = [[NSMutableArray alloc]init];
//                                [arrayForUsersNewEventStauts addObjectsFromArray:[userEvent objectForKey:usersStauts]];
//                                [arrayForUsersNewEventStauts addObject:self.currentUser.objectId];
//
//                                [userEvent addObject:arrayForUsersNewEventStauts forKey:usersStauts];
//
//                                [userEvent saveInBackground];
//                                finishedupdatingUserEventStatus(nil);
//
//                            }
//                        }];
//
//
//                    }
//
//                }];
//
//            }
//        }
//    }];
//}
//

