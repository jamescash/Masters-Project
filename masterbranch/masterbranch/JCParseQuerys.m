//
//  JCParseQuerys.m
//  PreAmp
//
//  Created by james cash on 03/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCParseQuerys.h"


@interface JCParseQuerys ()
@property (nonatomic,strong) PFRelation *artistRelations;
@property (nonatomic,strong) PFRelation *upComingGigsRelation;
@property (nonatomic,strong) PFRelation *FriendRelations;




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

//TODO add in an alert for when there an error time out or when theres that parse DNS issue

//TODO if we add a artist or a friend we can add them to the mutuble array here and this is always the array we user throught the whole add
-(void)getMyAtrits:(void(^)(NSError* error,NSArray* response))finishedGettingMyAtrits{
    
    
    self.artistRelations = [[PFUser currentUser] objectForKey:@"ArtistRelation"];
    PFQuery *query  = [self.artistRelations query];
    
        [query orderByAscending:@"artistName"];
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
    
            if (error) {
                NSLog(@"Error coming form inside get my artist relations %@",error);

                finishedGettingMyAtrits(error,nil);
            }else{

                self.MyArtist = [[NSArray alloc]init];
                self.MyArtist = objects;
                finishedGettingMyAtrits(nil,objects);
             }
          }];
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
   

    
    //PFQuery *getMtInviteActivitys = [PFQuery queryWithClassName:@"Activity"];
    //[getMtInviteActivitys whereKey:@"type" equalTo:@"userEvent"];
    //[getMtInviteActivitys whereKey:@"toUser" equalTo:[[PFUser currentUser]objectId]];
    //[getMtInviteActivitys orderByAscending:@"createdAt"];
    
    //[getMtInviteActivitys findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
               // if (error) {
                    //    NSLog(@"%@ error receving messages",error);
                    //    finishedGettingMyInvites(error,nil);
            
                    //}else{
                     //   NSMutableArray *eventIds = [[NSMutableArray alloc]init];
                     //
                        //get all the ids of the events
                      //  for (PFObject *activity in objects) {
                       //     [eventIds addObject:[activity objectForKey:@"relatedObjectId"]];
                       //  };
                        
                        PFQuery *getMyInvites = [PFQuery queryWithClassName:@"UserEvent"];
                        [getMyInvites whereKey:@"invited" equalTo:[[PFUser currentUser]objectId]];
                        [getMyInvites orderByDescending:@"createdAt"];
    
    
                        
                        //if (error) {
                        //    NSLog(@"%@ error receving messages",error);
                          //  finishedGettingMyInvites(error,nil);
                            
                        //}else{
                        
                          [getMyInvites findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) { self.MyInvties = [[NSArray alloc]init];
                                self.MyInvties = objects;
                                finishedGettingMyInvites(nil,objects);
                             }];
                        //}
                        
                    //}

        
    //}];

    
};
-(void)getMyAtritsUpComingGigs:(void (^)(NSError*, NSMutableArray*))finishedGettingMyAtritsUpcomingGigs{
    
    
   //TODO make this dynamic so when you fav a new artist the while thing update
 
    UpcomingGigsLoopCounter = 0;

    if (self.upComingGigsRelation) {
    
      finishedGettingMyAtritsUpcomingGigs(nil,self.MyArtistUpcomingGigs);

    
    }else if (self.MyArtist) {
    
        self.MyArtistUpcomingGigs = [[NSMutableArray alloc]init];
        
        
        UpcomingGigsLoopCounter = 0;
        
        for (PFObject *artist in self.MyArtist) {
            
            self.upComingGigsRelation = [artist objectForKey:@"upComingGigsRel"];
            PFQuery *query  = [self.upComingGigsRelation query];
            [query orderByAscending:@"datetime"];
            [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                
                if (error) {
                    NSLog(@"upComingGigsRel error %@",error);
                }else{
                    
                    //NSArray *aritstUpcomingGigs = objects;
                    [self.MyArtistUpcomingGigs addObjectsFromArray:objects];
                    UpcomingGigsLoopCounter ++;

                    //[self.MyArtistUpcomingGigs setObject:aritstUpcomingGigs forKey:[artist objectForKey:@"artistName"]];
                    
                    if (UpcomingGigsLoopCounter == ([self.MyArtist count])) {
                        finishedGettingMyAtritsUpcomingGigs(nil,self.MyArtistUpcomingGigs);
                    };
                }
                
                
            }];
            
        }
    
    
    
    }else{
        //we need to go get our artist relation

        [self getMyAtrits:^(NSError *error, NSArray *response) {
            
            if (error) {
                NSLog(@"error getmyartist %@",error);
            }else{
            
            self.MyArtist = [[NSArray alloc]init];
            self.MyArtist = response;
            self.MyArtistUpcomingGigs = [[NSMutableArray alloc]init];
            
                
            UpcomingGigsLoopCounter = 0;
                
            for (PFObject *artist in self.MyArtist) {
                
             self.upComingGigsRelation = [artist objectForKey:@"upComingGigsRel"];
             PFQuery *query  = [self.upComingGigsRelation query];
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
        }
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

























@end
