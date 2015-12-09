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
#import "JCToastAndAlertView.h"



@interface JCParseQuerys ()
@property (nonatomic,strong) PFRelation *artistRelations;
@property (nonatomic,strong) PFRelation *upComingGigsRelation;
@property (nonatomic,strong) PFRelation *FriendRelations;
//@property (nonatomic,strong) PFUser   *currentUser;

@property (nonatomic,strong) NSString *going;
@property (nonatomic,strong) NSString *maybe;
@property (nonatomic,strong) NSString *notGoing;
@property (nonatomic,strong) NSString *gotTickets;



@property (nonatomic,strong) NSMutableDictionary *artistImages;




@end

@implementation JCParseQuerys{
    int UpcomingGigsLoopCounter;
    BOOL methodUserIsFollowingArtist;
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
        //self.currentUser =          [PFUser currentUser];
        self.MyArtistUpcomingGigs = [[NSMutableArray alloc]init];
        self.going = JCUserEventUserGoing;
        self.gotTickets = JCUserEventUserGotTickets;
        self.maybe = JCUserEventUserMaybeGoing;
        self.notGoing =JCUserEventUserNotGoing;
    
    }
    return self;
}


#pragma - Get artist / Friends 

//get user firend from either server or local data storage
-(void)getMyAtrits:(void(^)(NSError* error,NSArray* response))finishedGettingMyAtrits{
    
    //get my artist from local data storage
    //if there not there get them from the server and save them ready to be got from local data storage the nect time.
    
    //anytime I need the suers artist i ask this method and it decided weather to get them from local data storge or form the server
    
    [self getMyAtritsfromLocalDataStorage:^(NSError *error, NSArray *response) {
              if (error) {
           [self getMyAtritsfromTheServer:^(NSError *error, NSArray *response) {
               if (error) {
                   //NSLog(@"error getting artist from server %@",error);
                   finishedGettingMyAtrits(error,nil);
               }else{
                   //NSLog(@"get artist from server");
                   finishedGettingMyAtrits(nil,response);
               }
               
           }];
       }else if ([response count]<2){
           //when user follows artist or when the user unfollows artist I update the backend and clear the loaca data storage
           //making this functuin go the server when local data storage is 0 or 1 means the loaca data storage automaticaly
           //be updated from the server everytime the user unfollows or follows an artist
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
    
    //look in local data storge for users artist
    PFQuery *myAtritsfromLocalDataStorage  = [PFQuery queryWithClassName:JCParseClassArtist];
    [myAtritsfromLocalDataStorage orderByAscending:JCArtistArtistName];
    [myAtritsfromLocalDataStorage fromLocalDatastore];
    [myAtritsfromLocalDataStorage findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (error) {
             //NSLog(@"Error coming form inside loaca data get artist relations %@",error);
            finishedGettingMyAtritsfromLocalDataStorage(error,nil);
        }else{
            finishedGettingMyAtritsfromLocalDataStorage(nil,objects);
        }
    }];
    
    
    
}

-(void)getMyAtritsfromTheServer:(void(^)(NSError* error,NSArray* response))finishedgetMyAtritsfromTheServer{
    
    //look on the server for users artist

    PFRelation *artistRelation = [[PFUser currentUser] objectForKey:@"ArtistRelation"];
    
    //if artist relation is null is means the user is new and they are not following an artist yet
    if (artistRelation == NULL) {
        NSArray *objects = [[NSArray alloc]init];
        finishedgetMyAtritsfromTheServer(nil,objects);
    }
    
    PFQuery *myAtritsfromTheServer  = [artistRelation query];
    [myAtritsfromTheServer orderByAscending:@"artistName"];

    
        [myAtritsfromTheServer findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            
            //NSLog(@"Get artist from server callback");
            
            if (error) {
                finishedgetMyAtritsfromTheServer(error,nil);
            }else{
                //when artist are got form server store them localy to user later on
                [PFObject pinAllInBackground:objects withName:@"MyArtist"];
                finishedgetMyAtritsfromTheServer(nil,objects);
            }
        }];
}

//Get firends works the same as get artist metod/ explained above
-(void)getMyFriends:(void (^)(NSError *, NSArray *))finishedGettingMyFriends{
    
    [self getMyFriendsfromLocalDataStorage:^(NSError *error, NSArray *response) {
        
        if (error) {
            finishedGettingMyFriends(error,nil);
            NSLog(@"error getting friends locally %@",error);

        }else if ([response count]<2){

            [self getMyFriendsfromTheServer:^(NSError *error, NSArray *response) {
                if (error) {
                    NSLog(@"3");

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
    [MyFriendsfromLocalDataStorage orderByAscending:JCUserRealName];
    [MyFriendsfromLocalDataStorage whereKey:@"objectId" notEqualTo:[[PFUser currentUser]objectId]];
    [MyFriendsfromLocalDataStorage findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (error) {
            
             finishedGettingMyFriendsfromLocalDataStorage(error,nil);
            
        }else{
            finishedGettingMyFriendsfromLocalDataStorage(nil,objects);
        }
        
    }];
};

-(void)getMyFriendsfromTheServer:(void (^)(NSError *error, NSArray *response))finishedGettingMyFriendsfromTheServer{
    
    PFRelation *friendsRelation = [[PFUser currentUser] objectForKey:@"FriendsRelation"];
    PFQuery *myFriendsfromTheServer  = [friendsRelation query];
    [myFriendsfromTheServer orderByAscending:JCUserRealName];
   
    if (friendsRelation == NULL) {
        NSArray *objects = [[NSArray alloc]init];
        finishedGettingMyFriendsfromTheServer(nil,objects);
    }


    [myFriendsfromTheServer findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {

        if (error) {
            
            finishedGettingMyFriendsfromTheServer(error,nil);
            
        }else{

            [PFObject pinAllInBackground:objects withName:@"MyFriends"];
            finishedGettingMyFriendsfromTheServer(nil,objects);
        }
        
    }];
};


#pragma - Get 

//get intives to the users inbox
-(void)getMyInvitesforType:(NSString*)userEventsType completionblock:(void(^)(NSError* error,NSArray* response))finishedGettingMyInvites{

    //1. This mothod is user to find the users upcoming/sent/past gigs.
    //2. Works off current time (now)
    
      NSDate *now = [NSDate date];
      PFQuery *getMyInvites = [PFQuery queryWithClassName:JCParseClassUserEvents];
   
      [getMyInvites whereKey:JCUserEventUsersInvited equalTo:[[PFUser currentUser]objectId]];
    
    
       //if upcomig get greater then NOW
       if ([userEventsType isEqualToString:JCUserEventUsersTypeUpcoming]) {
         [getMyInvites whereKey:JCUserEventUsersTheEventDate greaterThanOrEqualTo:now];
         [getMyInvites orderByAscending:JCUserEventUsersTheEventDate];

       //if past get less then NOW
       }else if ([userEventsType isEqualToString:JCUserEventUsersTypePast]){
           [getMyInvites whereKey:JCUserEventUsersTheEventDate lessThan:now];
           [getMyInvites orderByDescending:JCUserEventUsersTheEventDate];

       //else get ones im hosting and order by created at
       }else if ([userEventsType isEqualToString:JCUserEventUsersTypeSent]){
           [getMyInvites whereKey:JCUserEventUsersEventHostNameUserName equalTo:[[PFUser currentUser]username]];
           [getMyInvites orderByDescending:JCParseGeneralKeyCreatedAt];
       }
    
        [getMyInvites findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            //self.MyInvties = [[NSArray alloc]init];
            
            if (error) {
                NSString *codeString = [NSString stringWithFormat:@"%d", [error code]];
                [PFAnalytics trackEvent:@"error" dimensions:@{ @"code": codeString }];
                finishedGettingMyInvites(error,nil);

            }else{
                finishedGettingMyInvites(nil,objects);
            }
          }];

};

//Get all the data for the disvoery screen Main View Controller
-(void)getMyAtritsUpComingGigs:(BOOL)onlyIrishGigs comletionblock:(void (^)(NSError*, NSMutableArray*))finishedGettingMyAtritsUpcomingGigs{
    
    ///1 Get all of the users artist
    ///2 For each artist get all there upcoming gigs where venue is either in Ireland or UK, decision made baes on bool
    ///3 For each upcoming gig build a JCMusicDiaryArtistObject object to be used later in formatting the desocery screen
    
    //we need to go get our artist relation
    [self getMyAtrits:^(NSError *error, NSArray *response) {
        

        
        if (error) {
            NSString *codeString = [NSString stringWithFormat:@"%ld", (long)[error code]];
            [PFAnalytics trackEvent:@"error" dimensions:@{ @"code": codeString }];
            NSLog(@"error getmyartist %@",error);
            finishedGettingMyAtritsUpcomingGigs(error,nil);
        }else{
            

            //If the users not following any artist return emty arrray so we can show an emoty screen
            if ([response count]==0) {
                NSMutableArray *returnArray = [[NSMutableArray alloc]init];
                [returnArray addObjectsFromArray:response];
                finishedGettingMyAtritsUpcomingGigs(nil,returnArray);

            }
            
            NSMutableArray *myartist = [[NSMutableArray alloc]init];
            [myartist addObjectsFromArray:response];
            UpcomingGigsLoopCounter = 0;
            
            NSMutableArray *unsortedDiaryObjects = [[NSMutableArray alloc]init];
  
            //loop thought the artist and get all there upvoming gig
            for (PFObject *artist in myartist) {
                
                PFRelation *upcomingGigRelation = [artist objectForKey:@"upComingGigsRel"];
 
                if (!upcomingGigRelation) {
                    UpcomingGigsLoopCounter ++;
                }
                
                PFQuery *query  = [upcomingGigRelation query];
                
                if (onlyIrishGigs) {
                    [query whereKey:@"venueCounty" equalTo:@"Ireland"];
                }else{
                    [query whereKey:@"venueCounty" equalTo:@"United Kingdom"];
                }
                //do a query to pull down all the users artist objects
                [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                    
                    if (error) {
                        NSString *codeString = [NSString stringWithFormat:@"%d", [error code]];
                        [PFAnalytics trackEvent:@"error" dimensions:@{ @"code": codeString }];
                        //NSLog(@"upComingGigsRel error %@",error);
                        finishedGettingMyAtritsUpcomingGigs(error,nil);

                    }else{

                        //TODO save objects count in the music diary here so we can dispy the amount of gigs that
                        //artist is playing that moth
                        
                        //Using blocks to enumer the results and Intstatiate all the diary objects
                        [objects  enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {

                            JCMusicDiaryArtistObject *diaryObject = [[JCMusicDiaryArtistObject alloc]initWithArtits:artist andupComingGig:obj];
                            
                            if (diaryObject != nil){
                                [unsortedDiaryObjects addObject:diaryObject];
                            };
                        
                          }];//end of enum using block loop
                        

                        UpcomingGigsLoopCounter ++;
                       //When were finished looping through all the artist retun the array of diary objects with no duplicats
                        if (UpcomingGigsLoopCounter == ([myartist count])) {
                                                                        //see helper methods
                            NSMutableArray *arrayWithDuplicatsRemoved = [self RemoveDuplicatsfromArray:unsortedDiaryObjects];
                            finishedGettingMyAtritsUpcomingGigs(nil,arrayWithDuplicatsRemoved);
                        };
                        
                       }
                    }];
            }//end of every artist in myartist loop
        
         }
    }];
    
}

//Get upcoming gigs for artist on desocery Screen Detailed View
-(void)getUpcomingGigsforAartis:(PFObject*) artist onMonthIndex: (int)monthIndex isIrishQuery: (BOOL) isIrishQuery complectionblock: (void(^)(NSError* error,NSArray* response))getUpcomingGigsforAartis{
    
   //1. Get all the upcoming gigs related to that artist
   //2. [[[monthIndex = monthIndex]VenueCounty = Ireland]orderAscending]/or Uk based on Bool
   //3 return aray of Parse Event Objects
    
    PFRelation *upcomingGigd = [artist objectForKey:@"upComingGigsRel"];
    PFQuery *query  = [upcomingGigd query];
    [query whereKey:@"monthIndex" equalTo:[NSNumber numberWithInteger:(monthIndex-1)]];
    
    if (isIrishQuery) {
        
        [query whereKey:@"venueCounty" equalTo:@"Ireland"];
        
    }else{
        [query whereKey:@"venueCounty" equalTo:@"United Kingdom"];
        
    }
    
    [query orderByAscending:@"datetime"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (error) {
            NSString *codeString = [NSString stringWithFormat:@"%d", [error code]];
            [PFAnalytics trackEvent:@"error" dimensions:@{ @"code": codeString }];
            NSLog(@"upComingGigsRel error %@",error);
        }else{
            getUpcomingGigsforAartis(nil,objects);
        };
    }];
    
}


//Get comment for user event
-(void)getEventComments:(PFObject *)event complectionBlock:(void (^)(NSError *, NSMutableArray *))finishedgettingEventComments{
    
    //1. Query Activity class for [type: usercomment,]To This Event]
    //2. Inculde key: FromUser = download the actul object inseated of just the pointer.
    
    PFQuery *getEventCommentsActivitys = [PFQuery queryWithClassName:JCParseClassActivity];
    [getEventCommentsActivitys whereKey:JCUserActivityType equalTo:JCUActivityTypeUserComment];
    [getEventCommentsActivitys whereKey:JCUserActivityToEvent equalTo:event];
    [getEventCommentsActivitys orderByAscending:JCParseGeneralKeyCreatedAt];
    [getEventCommentsActivitys includeKey:JCUserActivityFromUser];
    
    [getEventCommentsActivitys findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (error) {
            NSString *codeString = [NSString stringWithFormat:@"%d", [error code]];
            [PFAnalytics trackEvent:@"error" dimensions:@{ @"code": codeString }];
            NSLog(@"%@ error receving messages",error);
            finishedgettingEventComments(error,nil);
            
        }else{
        
            NSMutableArray *commentActivitys = [[NSMutableArray alloc]init];
            [commentActivitys addObjectsFromArray:objects];
            
            finishedgettingEventComments(nil,commentActivitys);

           
        }
    
    }];
    
    
    
}

////Unused Old Method
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
            NSString *codeString = [NSString stringWithFormat:@"%d", [error code]];
            [PFAnalytics trackEvent:@"error" dimensions:@{ @"code": codeString }];
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

//Get Preamp users that match array of FB ids
-(void)getPreAmpUsersThatMatchTheseFBids:(NSMutableArray*)FBIds completionblock:(void(^)(NSError* error,NSArray* response))finishedGettingPreAmpUser{
    //Match the FBis from the uers friends list and return an array of preamp users so current user can add FB friends

    
            PFQuery *getPreAmpUsersThatMatchFBid = [PFUser query];
            [getPreAmpUsersThatMatchFBid whereKey:@"facebookId" containedIn:FBIds];
 
    
            [getPreAmpUsersThatMatchFBid findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                
                if (error) {
                    NSString *codeString = [NSString stringWithFormat:@"%d", [error code]];
                    [PFAnalytics trackEvent:@"error" dimensions:@{ @"code": codeString }];
                    finishedGettingPreAmpUser(error,nil);
                }else{
                    finishedGettingPreAmpUser(nil,objects);
                }
                
            }];
    
}

//Get arary of preamp user objects that match array of object Id's
-(void)getPFUserObjectsForParseUserIds:(NSArray*)userIds completionblock:(void(^)(NSError* error,NSArray* response))finishedGettingPreAmpUsers{
    
    PFQuery *getPFUserObjectsForIds = [PFUser query];
    [getPFUserObjectsForIds whereKey:JCParseGeneralKeyObjectId containedIn:userIds];
    
    
    [getPFUserObjectsForIds findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (error) {
            NSString *codeString = [NSString stringWithFormat:@"%d", [error code]];
            [PFAnalytics trackEvent:@"error" dimensions:@{ @"code": codeString }];
            finishedGettingPreAmpUsers(error,nil);
        }else{
            finishedGettingPreAmpUsers(nil,objects);
        }
        
    }];
}

//Get - Users that recently added me
-(void)getPeopleThatRecentlyAddedMe:(void (^)(NSError *, NSArray *))finishedGettingPeopleThatRecentlyAddedMe{
    
    
    PFQuery *whoRecentlyAddedMe = [PFQuery queryWithClassName:JCParseClassActivity];
    [whoRecentlyAddedMe whereKey:JCUserActivityType equalTo:JCUserActivityTypeAddFriend];
    [whoRecentlyAddedMe whereKey:JCUserActivityToUser equalTo:[PFUser currentUser]];
    [whoRecentlyAddedMe orderByDescending:JCParseGeneralKeyCreatedAt];
    [whoRecentlyAddedMe includeKey:JCUserActivityFromUser];
    
    
    
    [whoRecentlyAddedMe findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (error) {
            
            NSString *codeString = [NSString stringWithFormat:@"%d", [error code]];
            [PFAnalytics trackEvent:@"error" dimensions:@{ @"code": codeString }];
            finishedGettingPeopleThatRecentlyAddedMe(error,nil);
        }else{
            
            
            NSMutableArray *users = [[NSMutableArray alloc]init];
            
            for (PFObject *activity in objects) {
                PFUser *user = [activity objectForKey:JCUserActivityFromUser];
                if (user != nil) {
                    [users addObject:user];
                }
            }
            
            
            finishedGettingPeopleThatRecentlyAddedMe(nil,users);
            
        }
        
    }];
    
    
    
}

//Get - User current event status for event
-(void)getUserEventStatus:(PFObject *)eventobject completionBlock:(void (^)(NSError *, PFObject *))finishedgetActivtyForUser{
    
    PFQuery *getUserEventStatus = [PFQuery queryWithClassName:JCParseClassActivity];
    [getUserEventStatus whereKey:@"type" equalTo:@"eventStatus"];
    [getUserEventStatus whereKey:@"toEvent" equalTo:eventobject];
    [getUserEventStatus whereKey:@"fromUser" equalTo:[PFUser currentUser]];
    
    [getUserEventStatus findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (error) {
            NSString *codeString = [NSString stringWithFormat:@"%d", [error code]];
            [PFAnalytics trackEvent:@"error" dimensions:@{ @"code": codeString }];
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

#pragma - Save

//Save user comment
-(void)saveCommentToBackend:(NSDictionary*)userInfo complectionBlock: (void(^)(NSError* error))finishedsavingComment{
    //comment has already being validated.
    
    //1. Get ceoment text and Event Id for where it has being posted
    //2. Save comment in the activity class toEvent = Event, Content = Comment, FromUser = User.
    //3. Saving comment as activities alows cloud code to prefrom an after save that send a push notifcation
    //to everyone in the event. - See main.js for could code.
    
    NSString *commentText = [userInfo objectForKey:@"comment"];
    PFObject *eventObject = [userInfo objectForKey:@"eventId"];
    
    if (commentText && commentText.length != 0) {

        PFObject *comment = [PFObject objectWithClassName:JCParseClassActivity];
        [comment setObject:JCUActivityTypeUserComment forKey:JCUserActivityType];
        [comment setObject:[PFUser currentUser] forKey:JCUserActivityFromUser];
        //[comment setObject:[PFUser currentUser] forKey:JCUserActivityCommentOwner];
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

//Save a userEvent using eventObject
-(void)creatUserEvent:(eventObject*)currentEvent invitedUsers: (NSArray*)recipientIds complectionBlock:(void(^)(NSError* error))finishedCreatingUserEvent{
    
    //Method saves new UserEvents
    //- coming from homescress/Gig more info - using Bandintown data to creat user event
    //Nested
    //1. save event photo as a file on Backend
    //2. then save userEvent object and attach Photofile
    //3. - Upload
    
    
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
            NSString *codeString = [NSString stringWithFormat:@"%d", [error code]];
            [PFAnalytics trackEvent:@"error" dimensions:@{ @"code": codeString }];
            finishedCreatingUserEvent(error);
            
        }else{
            //file saved sucessfully now lets link it with a PFobject so we can send it
            PFObject *UserEvent = [PFObject objectWithClassName:JCParseClassUserEvents];
            [UserEvent setObject:file forKey:JCUserEventUsersEventPhoto];
            [UserEvent setObject:currentEvent.eventTitle forKey:JCUserEventUsersEventTitle];
            [UserEvent setObject:[[PFUser currentUser]username] forKey:JCUserEventUsersEventHostNameUserName];
            [UserEvent setObject:[[PFUser currentUser]objectForKey:JCUserRealName] forKeyedSubscript:JCUserEventUsersEventHostNameRealName];
            [UserEvent setObject:[self formatDateStringIntoNSDate:currentEvent.eventDate] forKey: JCUserEventUsersTheEventDate];
            [UserEvent setObject:currentEvent.venueName forKey:JCUserEventUsersEventVenue];
            [UserEvent setObject:[[PFUser currentUser]objectId] forKey:JCUserEventUsersEventHostId];
            [UserEvent setObject:currentEvent.county forKey:JCUserEventUsersEventCity];
            [UserEvent setObject:recipientIds forKey:JCUserEventUsersInvited];
            [UserEvent setObject:recipientIds forKey:JCUserEventUsersSubscribedForNotifications];
            //set this value so that notifications are only sent out to the invited array the first time the event is created
            [UserEvent setObject:@NO forKey:JCUserEventUsersEventIsBeingUpDated];
            
            NSLog(@"%@",recipientIds);
            
            [UserEvent saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                
                if (error) {
                    NSString *codeString = [NSString stringWithFormat:@"%d", [error code]];
                    [PFAnalytics trackEvent:@"error" dimensions:@{ @"code": codeString }];
                    finishedCreatingUserEvent(error);
                    

                }else{
                    finishedCreatingUserEvent(nil);
                }
                
            }];
            
        }
        
    }];
    
    
}

//save a userEvent using a PFobject
-(void)creatUserEventForParseEventObjct:(PFObject*)eventObjct witheventImage:(UIImage*)eventImage invitedUsers: (NSArray*)recipientIds complectionBlock:(void(^)(NSError* error))finishedCreatingUserEvent{
    
    //- coming from discory screen - using our own data to build userEvent
    //method works as above
    
    NSData *fileData;
    NSString *fileName;
    NSString *fileType;
    
    fileData = UIImagePNGRepresentation(eventImage);
    fileName = @"image.png";
    fileType = @"EventImage";
    
    PFFile *file = [PFFile fileWithName:fileName data:fileData];
    
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        
        //chaning the two asynrons upplaods to parse so users dont have to wait and only the second one happens if the first one
        //is sucesful
        
        
        if (error) {
            NSString *codeString = [NSString stringWithFormat:@"%d", [error code]];
            [PFAnalytics trackEvent:@"error" dimensions:@{ @"code": codeString }];
            finishedCreatingUserEvent(error);
            
        }else{
            //file saved sucessfully now lets link it with a PFobject so we can send it
            PFObject *UserEvent = [PFObject objectWithClassName:JCParseClassUserEvents];
            [UserEvent setObject:file forKey:JCUserEventUsersEventPhoto];
            [UserEvent setObject:[eventObjct objectForKey:JCUpcomingEventArtistName] forKey:JCUserEventUsersEventTitle];
            [UserEvent setObject:[[PFUser currentUser]username] forKey:JCUserEventUsersEventHostNameUserName];
            [UserEvent setObject:[[PFUser currentUser]objectForKey:JCUserRealName] forKeyedSubscript:JCUserEventUsersEventHostNameRealName];
            
             NSDate *dateTime = [self formatDateStringIntoNSDate:[eventObjct objectForKey:JCUpcomingEventDateTimeString]];
            
            [UserEvent setObject:dateTime forKey:JCUserEventUsersTheEventDate];
            
            [UserEvent setObject:[eventObjct objectForKey:JCUpcomingEventVenueName] forKey:JCUserEventUsersEventVenue];
            [UserEvent setObject:[[PFUser currentUser]objectId] forKey:JCUserEventUsersEventHostId];
            [UserEvent setObject:[eventObjct objectForKey:JCUpcomingEventVenueCity] forKey:JCUserEventUsersEventCity];
            [UserEvent setObject:recipientIds forKey:JCUserEventUsersInvited];
            [UserEvent setObject:recipientIds forKey:JCUserEventUsersSubscribedForNotifications];
            //set this value so that notifications are only sent out to the invited array the first time the event is created
            [UserEvent setObject:@NO forKey:JCUserEventUsersEventIsBeingUpDated];
            
            [UserEvent saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                
                if (error) {
                    NSString *codeString = [NSString stringWithFormat:@"%d", [error code]];
                    [PFAnalytics trackEvent:@"error" dimensions:@{ @"code": codeString }];
                    finishedCreatingUserEvent(error);
                    
                    
                }else{
                    finishedCreatingUserEvent(nil);
                }
                
            }];
            
        }
        
    }];
    
    
}

//Save - adding users to existing events
-(void)addUsersToExistingParseUserEvent:(PFObject *)userEvent UsersToadd:(NSArray *)users completionBlock:(void (^)(NSError *))finishedAddingUsers{
    
    //1. get all users invited
    //2. Add new user to array
    //3. replace old array
    //4. resave event
    //5. creat intived activity for the purpos of sending out push notifiaction
    
    NSMutableArray *userInvited = [[NSMutableArray alloc]init];
    [userInvited addObjectsFromArray:[userEvent objectForKey:JCUserEventUsersEventInvited]];
    [userInvited addObjectsFromArray:users];
    
    NSMutableArray *userSubscribbed = [[NSMutableArray alloc]init];
    [userSubscribbed addObjectsFromArray:[userEvent objectForKey:JCUserEventUsersSubscribedForNotifications]];
    [userSubscribbed addObjectsFromArray:users];
    
    
    [userEvent setObject:userInvited forKey:JCUserEventUsersEventInvited];
    [userEvent setObject:userSubscribbed forKey:JCUserEventUsersSubscribedForNotifications];
    [userEvent setObject:@YES forKey:JCUserEventUsersEventIsBeingUpDated];
    [userEvent saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        
        if (error) {
            finishedAddingUsers(error);
        }else{
         
            PFObject *intivedFriendsActivity = [PFObject objectWithClassName:JCParseClassActivity];
            [intivedFriendsActivity setObject:userEvent forKey:JCUserActivityToEvent];
            [intivedFriendsActivity setObject:JCUserActivityTypeInvitedFriendsToUserEvent forKey:JCUserActivityType];
            [intivedFriendsActivity setObject:[PFUser currentUser] forKey:JCUserActivityFromUser];
            [intivedFriendsActivity setObject:users forKey:JCUserActivityInvitedUsers];
            [intivedFriendsActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {

                
                
                NSLog(@"%@",userEvent);

                if (error) {
                    finishedAddingUsers(error);

                }else{
                    
                    finishedAddingUsers(nil);

                }
                
            }];
            
        }
        
        
    }];
    
    
}

//Save - Follow artist
-(void)UserFollowedArtist:(eventObject *)currentEvent complectionBlock:(void (^)(NSError *))finishedSavingArtist{
    
    //This method is when I user follows an artist
    //1. Query backend to see if artist already exisit
    //2. If artist does already exist then add them as a realtion to the user
    //3. If artist doesnt already exist on the backend then save a new artist object
    //4. This artist object will then be avilible for future users
    
    NSLog(@"Follow artist");
    
    PFQuery *query = [PFQuery queryWithClassName:JCParseClassArtist];
    //this is artist name, bad varible naming.
    [query whereKey:JCArtistArtistName equalTo:currentEvent.eventTitle];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
       
        if (error) {
            NSString *codeString = [NSString stringWithFormat:@"%d", [error code]];
            [PFAnalytics trackEvent:@"error" dimensions:@{ @"code": codeString }];
            NSLog(@"%@ error receving messages",error);
        }else{
            
            if ([objects count]>0) {
                //that artist exist so add it as a reation the current user.
                PFRelation *ArtistRelation = [[PFUser currentUser] relationForKey:JCUserArtistRelation];
                //add the artist to the users relation.
                
                [ArtistRelation addObject:[objects firstObject]];
                [[objects firstObject] pinInBackgroundWithName:@"MyArtist"];
                
                [[PFUser currentUser] saveInBackground];
                
                finishedSavingArtist(nil);
            }else{
                
                //creat a new aritst object and save it to the backend and relat the user
                [self saveArtistToBackendAndAddRelationToUser:currentEvent complectionBlock:^(NSError *error) {
                    if (error) {
                        finishedSavingArtist(error);
                    }else{
                        finishedSavingArtist(nil);
                       
                    }
                    
                }];
                
            }
        }
    }];
};

//Save If we need to save a new artist
-(void)saveArtistToBackendAndAddRelationToUser:(eventObject*)currentEvent complectionBlock:(void (^)(NSError *))finishedfollowingArtist {
    
    //1. save image file to database
    //2. go to bandsintown and get upcoming json
    //3. save artist object to backend with relation to the image and json sting of upcoming gigs
    NSData *fileData;
    NSString *fileName;
    //NSString *fileType;
    
    
    NSLog(@"%@",currentEvent.eventTitle);
    NSLog(@"%@",currentEvent.photoDownload.image);
    NSLog(@"%@",currentEvent.mbidNumber);
    
    
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
            finishedfollowingArtist(error);
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
                    finishedfollowingArtist(error);
                }else{
                    
                    
                    
                    PFObject *artist = [PFObject objectWithClassName:@"Artist"];
                    [artist setObject:FullSizeArtistPhoto forKey:@"atistImage"];
                    [artist setObject:thumbnailArtistImage forKey:@"thmbnailAtistImage"];
                    [artist setObject:currentEvent.eventTitle forKey:@"artistName"];
                    [artist setObject:currentEvent.mbidNumber forKey:@"mbidNumber"];
                    
                    
                    
                    [artist saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                        
                        if (error) {
                            NSLog(@"error save artist in BG with block");
                            finishedfollowingArtist(error);
                        }else{
                            [artist pinInBackgroundWithName:@"MyArtist"];
                            //now that we saved that artist to the data base we can relat it to the current user
                            PFRelation *ArtistRelation = [[PFUser currentUser] relationForKey:@"ArtistRelation"];
                            [ArtistRelation addObject:artist];
                            
                            PFUser *currentUser = [PFUser currentUser];
                            
                            [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                                if (error){
                                    finishedfollowingArtist(error);
                                }else{
                                    finishedfollowingArtist(nil);
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

//Save - Unfollow artist
-(void)UserUnfollowedArtist:(eventObject *)currentEvent complectionBlock:(void (^)(NSError *))finishedUnfollowingArtist{
    
    //1. get users artist
    //2. removw artist
    //3. Resave user
    
    PFRelation *artistRelation = [[PFUser currentUser]objectForKey:JCUserArtistRelation];
    
    PFQuery *query = [artistRelation query];

    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        
        for (PFObject *artist in objects) {
            NSString *artistName = [artist objectForKey:JCArtistArtistName];
            NSString *mbidNumber = [artist objectForKey:JCArtistArtistMbidNumber];
            
            if ([artistName isEqualToString:currentEvent.eventTitle]&&[mbidNumber isEqualToString:currentEvent.mbidNumber]) {
                [artistRelation removeObject:artist];
                [PFObject unpinAllObjectsInBackgroundWithName:@"MyArtist"];

                [[PFUser currentUser]saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if (error) {
                        NSLog(@"error removing artist");
                    }else{
                        
                        NSLog(@"user saved");
                    }
                    
                }];
                
                finishedUnfollowingArtist(nil);
                break;
            }

        }
        
    }];
}

//As above
-(void)UserUnfollowedArtistWithArtistObject:(PFObject*)artist complectionBlock:(void(^)(NSError* error))finishedUnfollowingArtist{
    
    PFRelation *artistRelation = [[PFUser currentUser]objectForKey:JCUserArtistRelation];

    [artistRelation removeObject:artist];
    
    [PFObject unpinAllObjectsInBackgroundWithName:@"MyArtist"];

    [[PFUser currentUser]saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error) {
            NSLog(@"error removing artist");
        }else{
            finishedUnfollowingArtist(nil);
        }
        
    }];
    
    
    
}

//Save - User chaged event status
-(void)postActivtyForUserActionEventStatus:(NSString*)usersStauts eventobject:(PFObject*) eventobject completionBlock: (void(^)(NSError* error))finishedpostActivtyForUser{
    
    //1. Save new activity to notify everyone in that event
    
    PFObject *userEventStatus = [PFObject objectWithClassName:JCParseClassActivity];
    [userEventStatus setObject:JCUserActivityTypeEventStatus forKey:JCUserActivityType];
    [userEventStatus setObject:[PFUser currentUser] forKey:JCUserActivityFromUser];
    [userEventStatus setObject:eventobject forKey:JCUserActivityToEvent];
    [userEventStatus setObject:usersStauts forKey:JCUserActivityContent];
    
    
    
    [userEventStatus saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        
        if (error) {
            NSString *codeString = [NSString stringWithFormat:@"%d", [error code]];
            [PFAnalytics trackEvent:@"error" dimensions:@{ @"code": codeString }];
            finishedpostActivtyForUser(error);
        }else{
            
            finishedpostActivtyForUser(nil);
        }
    }];
    
}

//Save - User Added Friend
-(void)postActivtyForUserActionAddFriend:(PFUser*)UserAdded completionBlock: (void(^)(NSError* error))finishedpostActivtyForAddFriends{
    
    //1. Save new activity to notify other users
    
    [self findoutIfAddFriendsActivityAlreadyExistst:UserAdded completionBlock:^(NSError *error, bool activityDoesExists) {
        
        if (error) {
            NSString *codeString = [NSString stringWithFormat:@"%ld", (long)[error code]];
            [PFAnalytics trackEvent:@"error" dimensions:@{ @"code": codeString }];
            finishedpostActivtyForAddFriends(error);
        }else{
            
            if (activityDoesExists) {
                
                NSLog(@"activity does axist %d",activityDoesExists);
                finishedpostActivtyForAddFriends(nil);
                
            }else{
                //ACTIVITY did not exist so lets make a new one and save it
                NSLog(@"activity does NOT axist %d",activityDoesExists);
                
                PFObject *addFriendActivity = [PFObject objectWithClassName:JCParseClassActivity];
                [addFriendActivity setObject:JCUserActivityTypeAddFriend forKey:JCUserActivityType];
                [addFriendActivity setObject:[PFUser currentUser] forKey:JCUserActivityFromUser];
                [addFriendActivity setObject:UserAdded forKeyedSubscript:JCUserActivityToUser];
                
                
                [addFriendActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    
                    if (error) {
                        NSString *codeString = [NSString stringWithFormat:@"%d", [error code]];
                        [PFAnalytics trackEvent:@"error" dimensions:@{ @"code": codeString }];
                        finishedpostActivtyForAddFriends(error);
                    }else{
                        
                        finishedpostActivtyForAddFriends(nil);
                    }
                }];
            }
        }
    }];
}

//Find out if user
-(void)findoutIfAddFriendsActivityAlreadyExistst:(PFUser*)UserBeingAdded completionBlock: (void(^)(NSError* error,bool activityDoesExists))finishedpostActivtyForAddFriends{
    
    
    PFQuery *doesActivityExist = [PFQuery queryWithClassName:JCParseClassActivity];
    [doesActivityExist whereKey:JCUserActivityType equalTo:JCUserActivityTypeAddFriend];
    [doesActivityExist whereKey:JCUserActivityFromUser equalTo:[PFUser currentUser]];
    [doesActivityExist whereKey:JCUserActivityToUser equalTo:UserBeingAdded];
    
    [doesActivityExist findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (error) {
            finishedpostActivtyForAddFriends(error,nil);
        }else{
            
            if ([objects count]>0) {
                //ACTIVITY already exists to return YES
                //and save it so it updates on the backend
                
                PFObject *activity = [objects firstObject];
                //NSLog(@"%@",activity);
                //NSDate *now = [NSDate date];
                // [activity setValue:now forKey:JCParseGeneralKeyCreatedAt];
                [activity saveInBackground];
                finishedpostActivtyForAddFriends(nil,YES);
            }else{
                //ACTIVITY donesnt exists to return NO
                finishedpostActivtyForAddFriends(nil,NO);
            }
        }
        
    }];
}

//Save - Update users evet status eg. Going/Not going/Maybe/
-(void)updateUserEventStatus:(NSString *)usersStauts eventobject:(PFObject*) eventobject completionBlock:(void (^)(NSError *))finishedupdatingUserEventStatus{
    
    //See if the user has a current event status for this event if they do update it
    //if they dont creat a new one
    
    
    
    [self getUserEventStatus:eventobject completionBlock:^(NSError *error, PFObject *userEventStatusActivity) {
        
        if (error) {
            NSString *codeString = [NSString stringWithFormat:@"%d", [error code]];
            [PFAnalytics trackEvent:@"error" dimensions:@{ @"code": codeString }];
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
#pragma - Querys

//Query - IsUserFollowingArtist?
-(void)isUserFollowingArtist:(eventObject*)eventObject completionBlock:(void(^)(NSError* error,BOOL userIsFollowingArtist))finishedisUserFollowingArtist{
    
    //Used to determin buttons states and and weather to follow or unfollow
    
    
    methodUserIsFollowingArtist = NO;
    
    [self getMyAtrits:^(NSError *error, NSArray *response) {
        
        if (error) {
            finishedisUserFollowingArtist(error,NO);
        }else{
            
            for (PFObject *artist in response) {
               
                NSString *artistName = [artist objectForKey:JCArtistArtistName];
                NSString *mbidNumber = [artist objectForKey:JCArtistArtistMbidNumber];
                
                if ([artistName isEqualToString:eventObject.eventTitle]&&[mbidNumber isEqualToString:eventObject.mbidNumber]) {
                    methodUserIsFollowingArtist = YES;
                    break;
                }
              }
            
        
            
            if (methodUserIsFollowingArtist) {
                finishedisUserFollowingArtist(nil,YES);

            }else{
                finishedisUserFollowingArtist(nil,NO);
            }
        }
        
    }];
}

//Query - Find out if users going to event
-(void)isUserInterestedInEvent:(eventObject*)eventObject completionBlock:(void(^)(NSError* error,BOOL userIsInterestedInGoingToEvent,PFObject* JCParseuserEvent))finishedisUserInterestedInEvent{
    
    //1. See if any backend event match current event
    //2. see if user is going to anyof them
    
    PFQuery *isUserGoingToEvent = [PFQuery queryWithClassName:JCParseClassUserEvents];
    
    //is there any events created for this event?
    [isUserGoingToEvent whereKey:JCUserEventUsersEventTitle equalTo:eventObject.eventTitle];
    [isUserGoingToEvent whereKey:JCUserEventUsersEventVenue equalTo:eventObject.venueName];
    [isUserGoingToEvent whereKey:JCUserEventUsersEventCity equalTo:eventObject.county];
    [isUserGoingToEvent whereKey:JCUserEventUsersEventDate equalTo:[self formatDateStringIntoNSDate:eventObject.eventDate]];
    //[isUserGoingToEvent whereKey:JCUserEventUsersTheEventDate greaterThan:NSDate];
    //if so do any of them have the users ID in the intived list
    [isUserGoingToEvent whereKey:JCUserEventUsersInvited equalTo:[[PFUser currentUser]objectId]];
    
    [isUserGoingToEvent findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
       
        
        
        if (error) {
            finishedisUserInterestedInEvent(error,NO,nil);
        }else{
            
            
            if ([objects count]>0) {
                finishedisUserInterestedInEvent(error,YES,[objects firstObject]);

            }else{
                finishedisUserInterestedInEvent(error,NO,nil);

            }
            
        }
        
        
    }];
    
}
//Quer - Is user intered in event PFobject *as above
-(void)isUserInterestedInParseEvent:(PFObject*)eventObject completionBlock:(void(^)(NSError* error,BOOL userIsInterestedInGoingToEvent,PFObject* JCParseUserEvent))finishedisUserInterestedInEvent{
 
    PFQuery *isUserGoingToEvent = [PFQuery queryWithClassName:JCParseClassUserEvents];
    
    NSDate *now = [NSDate date];
    //take three hours away from now to allow for the threshold of sometime there is gig's displayed on the homescreen after
    //there starting time
    NSDate *NSDate = [now dateByAddingTimeInterval:-3600*3];
    
    //is there any events created for this event?
    [isUserGoingToEvent whereKey:JCUserEventUsersEventTitle equalTo:[eventObject objectForKey:JCUpcomingEventArtistName]];
    [isUserGoingToEvent whereKey:JCUserEventUsersEventVenue equalTo:[eventObject objectForKey:JCUpcomingEventVenueName]];
    [isUserGoingToEvent whereKey:JCUserEventUsersEventCity equalTo:[eventObject objectForKey:JCUpcomingEventVenueCity]];
    [isUserGoingToEvent whereKey:JCUserEventUsersTheEventDate greaterThan:NSDate];
    //if so do any of them have the users ID in the intived list
    [isUserGoingToEvent whereKey:JCUserEventUsersInvited equalTo:[[PFUser currentUser]objectId]];
    
    [isUserGoingToEvent findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (error) {
            finishedisUserInterestedInEvent(error,NO,nil);
        }else{
            
            if ([objects count]>0) {
                finishedisUserInterestedInEvent(error,YES,[objects firstObject]);
                
            }else{
                finishedisUserInterestedInEvent(error,NO,nil);
                
            }
            
        }
        
        
    }];


}


//Query - Find all the users attending this event
-(void)getUsersAttendingUserEvent:(PFObject *)eventobject completionBlock:(void (^)(NSError *, NSMutableDictionary *))finishedgettingUsersAttendingUserEvent{
    
    //1. Get all the users attending the event
    //2. Get all the avtivitys for crrent event and sort the users into there catagoys
    //3. Return a dictionary Of user - sorted (going, notgoing, maybe)
    
    
    PFQuery *getUserEventStatus = [PFQuery queryWithClassName:JCParseClassActivity];
    [getUserEventStatus whereKey:JCUserActivityType equalTo:@"eventStatus"];
    [getUserEventStatus whereKey:@"toEvent" equalTo:eventobject];

    [getUserEventStatus findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (error) {
            NSString *codeString = [NSString stringWithFormat:@"%d", [error code]];
            [PFAnalytics trackEvent:@"error" dimensions:@{ @"code": codeString }];
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

//Query - Get users for a specific event status in a specific event
-(void)getUserGoingToEvent:(PFObject*)currentEvent forEventStatus:(NSString*) UserEventStatus completionBlock:(void(^)(NSError* error,NSArray *userGoing))finishedgettingUsersGoingToEvent{
    
    if ([UserEventStatus isEqualToString:JCUserEventUsersEventInvited]) {

        NSArray *intived = [currentEvent objectForKey:JCUserEventUsersEventInvited];
        PFQuery *userQuer = [PFUser query];
        [userQuer whereKey:@"objectId" containedIn:intived];
        [userQuer findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            
            if (error) {
                NSString *codeString = [NSString stringWithFormat:@"%d", [error code]];
                [PFAnalytics trackEvent:@"error" dimensions:@{ @"code": codeString }];
                finishedgettingUsersGoingToEvent(error,nil);

            }else{
               // NSLog(@"intived %@ ",objects);
                finishedgettingUsersGoingToEvent(nil,objects);
            }
            
        }];
        
    
    }else{
   
    PFQuery *getUserEventStatus = [PFQuery queryWithClassName:JCParseClassActivity];
    [getUserEventStatus whereKey:JCUserActivityType equalTo:@"eventStatus"];
    [getUserEventStatus whereKey:JCUserActivityToEvent equalTo:currentEvent];
    [getUserEventStatus whereKey:JCUserActivityContent equalTo:UserEventStatus];
    [getUserEventStatus includeKey:JCUserActivityFromUser];
    
    
    
    [getUserEventStatus findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        if (error) {
            NSString *codeString = [NSString stringWithFormat:@"%d", [error code]];
            [PFAnalytics trackEvent:@"error" dimensions:@{ @"code": codeString }];
            finishedgettingUsersGoingToEvent(error,nil);
        }else {
            
            NSMutableArray *users = [[NSMutableArray alloc]init];
            
            for (PFObject *activity in objects) {
                PFUser *user = [activity objectForKey:JCUserActivityFromUser];
                [users addObject:user];
                
            }
            
            finishedgettingUsersGoingToEvent(nil,users);
            }
        
    }];
    
    }
    
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



