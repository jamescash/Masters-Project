//
//  JCParseQuerys.m
//  PreAmp
//
//  Created by james cash on 03/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCParseQuerys.h"
#import "UIImage+Resize.h"



@interface JCParseQuerys ()
@property (nonatomic,strong) PFRelation *artistRelations;
@property (nonatomic,strong) PFRelation *upComingGigsRelation;
@property (nonatomic,strong) PFRelation *FriendRelations;
@property (nonatomic,strong) PFUser   *currentUser;


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
        self.MyArtist = [[NSMutableArray alloc]init];
        self.artistImages = [[NSMutableDictionary alloc]init];
        self.currentUser = [PFUser currentUser];
        
    }
    return self;
}

//TODO add in an alert for when there an error time out or when theres that parse DNS issue.
//TODO add an update my artist function here so it updates artist number when you follow an artist.
//TODO if we add a artist or a friend we can add them to the mutuble array here and this is always the array we user throught the whole add.

-(void)getMyAtrits:(void(^)(NSError* error,NSArray* response))finishedGettingMyAtrits{
    
    
    //if (self.MyArtist) {
    //    finishedGettingMyAtrits(nil,self.MyArtist);
    //}else{
    
    self.artistRelations = [[PFUser currentUser] objectForKey:@"ArtistRelation"];
    PFQuery *query  = [self.artistRelations query];
    
        [query orderByAscending:@"artistName"];
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
    
            if (error) {
                NSLog(@"Error coming form inside get my artist relations %@",error);

                finishedGettingMyAtrits(error,nil);
            }else{
                [self.MyArtist addObjectsFromArray:objects];
                finishedGettingMyAtrits(nil,objects);
             }
          }];
    //}
}
-(void)getMyFriends:(void (^)(NSError *, NSArray *))finishedGettingMyFriends{
    
    self.FriendRelations = [[PFUser currentUser] objectForKey:@"FriendsRelation"];
    PFQuery *query  = [self.FriendRelations query];
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"Error coming form insode get my firends relations %@",error);
            finishedGettingMyFriends(error,nil);

        }else{
            self.MyFriends = [[NSArray alloc]init];
            self.MyFriends = objects;
            finishedGettingMyFriends(nil,objects);
        }
        
    }];
};
-(void)getMyInvites:(void (^)(NSError *, NSArray *))finishedGettingMyInvites{
   

   
                        PFQuery *getMyInvites = [PFQuery queryWithClassName:@"UserEvent"];
                        [getMyInvites whereKey:@"invited" equalTo:[[PFUser currentUser]objectId]];
                        [getMyInvites orderByDescending:@"createdAt"];
    
    
                        
                          [getMyInvites findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) { self.MyInvties = [[NSArray alloc]init];
                                self.MyInvties = objects;
                                finishedGettingMyInvites(nil,objects);
                             }];
    
    
};
-(void)getMyAtritsUpComingGigs:(BOOL)onlyIrishGigs comletionblock:(void (^)(NSError*, NSMutableArray*))finishedGettingMyAtritsUpcomingGigs{
    
    
   //TODO make this dynamic so when you fav a new artist the music diary update's
 
    UpcomingGigsLoopCounter = 0;

   

        //we need to go get our artist relation
        [self getMyAtrits:^(NSError *error, NSArray *response) {
            
            if (error) {
                NSLog(@"error getmyartist %@",error);
            }else{
            
            self.MyArtist = [[NSMutableArray alloc]init];
            [self .MyArtist addObjectsFromArray:response];
            
            self.MyArtistUpcomingGigs = [[NSMutableArray alloc]init];
            
                
            UpcomingGigsLoopCounter = 0;
                
            for (PFObject *artist in self.MyArtist) {
                
             self.upComingGigsRelation = [artist objectForKey:@"upComingGigsRel"];
             PFQuery *query  = [self.upComingGigsRelation query];
             
                
                if (onlyIrishGigs) {
                [query whereKey:@"venueCounty" equalTo:@"Ireland"];
                }
             
            
            [query orderByAscending:@"datetime"];
            [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                 
                 if (error) {
                     NSLog(@"upComingGigsRel error %@",error);
                 }else{
                 
                     //NSArray *aritstUpcomingGigs = objects;
                     UpcomingGigsLoopCounter ++;
                     [self.MyArtistUpcomingGigs addObjectsFromArray:objects];
                     //[self.MyArtistUpcomingGigs setObject:aritstUpcomingGigs forKey:[artist objectForKey:@"artistName"]];
             
                 if (UpcomingGigsLoopCounter == ([self.MyArtist count])) {
                     

                     finishedGettingMyAtritsUpcomingGigs(nil,self.MyArtistUpcomingGigs);
                 };
                }
             
             
             }];
           
            }
           }
        }];
        //}
}



-(void)getEventComments:(NSString *)eventiD complectionBlock:(void (^)(NSError *, NSMutableArray *))finishedgettingEventComments{
    
    PFQuery *getEventCommentsActivitys = [PFQuery queryWithClassName:@"Activity"];
    [getEventCommentsActivitys whereKey:@"type" equalTo:@"userComment"];
    [getEventCommentsActivitys whereKey:@"relatedObjectId" equalTo:eventiD];
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



//posting
-(void)saveCommentToBackend:(NSDictionary*)userInfo complectionBlock: (void(^)(NSError* error))finishedsavingComment{
    
    
    NSString *commentText = [userInfo objectForKey:@"comment"];
    NSString *eventId = [userInfo objectForKey:@"eventId"];
    
    if (commentText && commentText.length != 0) {
        //create and save photo caption
        PFObject *comment = [PFObject objectWithClassName:@"Activity"];
        [comment setObject:@"userComment" forKey:@"type"];
        [comment setObject:[[PFUser currentUser]objectId] forKey:@"fromUser"];
        [comment setObject:eventId forKey:@"relatedObjectId"];
        [comment setObject:commentText forKey:@"content"];
        
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
            PFObject *UserEvent = [PFObject objectWithClassName:@"UserEvent"];
            [UserEvent setObject:file forKey:@"eventPhoto"];
            [UserEvent setObject:currentEvent.eventTitle forKey:@"eventTitle"];
            [UserEvent setObject:[[PFUser currentUser]username] forKey:@"eventHostName"];
            [UserEvent setObject:currentEvent.eventDate forKey:@"eventDate"];
            [UserEvent setObject:currentEvent.venueName forKey:@"eventVenue"];
            [UserEvent setObject:[[PFUser currentUser]objectId] forKey:@"eventHostId"];
            [UserEvent setObject:recipientIds forKey:@"invited"];
            //create users going and user not going + who has tickets
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
    [query whereKey:@"artistName" equalTo:currentEvent.eventTitle];
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
                        
                        self.MyArtistUpcomingGigs = nil;

                        [self.MyArtist addObject:objects[0]];
                    }
                    
                }];//end of save current user in BG
                
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
                            
                            
                            NSLog(@"New artist saved");
                            
                            //now that we saved that artist to the data base we can relat it to the current user
                            PFRelation *ArtistRelation = [self.currentUser relationForKey:@"ArtistRelation"];
                            [ArtistRelation addObject:artist];
                            
                            
                            [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                                if (error){
                                    
                                    NSLog(@"Error: %@ %@", error, [error localizedDescription]);
                                }else{
                                    
                                    [self.MyArtist addObject:artist];
                                    self.MyArtistUpcomingGigs = nil;
                                    
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


















@end
