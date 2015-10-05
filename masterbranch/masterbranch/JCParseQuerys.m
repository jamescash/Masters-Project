//
//  JCParseQuerys.m
//  PreAmp
//
//  Created by james cash on 03/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCParseQuerys.h"
#import <Parse/Parse.h>


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
   

    
    PFQuery *getMtInviteActivitys = [PFQuery queryWithClassName:@"Activity"];
    [getMtInviteActivitys whereKey:@"type" equalTo:@"userEvent"];
    [getMtInviteActivitys whereKey:@"toUser" equalTo:[[PFUser currentUser]objectId]];
    [getMtInviteActivitys orderByDescending:@"createdAt"];
    
    [getMtInviteActivitys findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
                if (error) {
                        NSLog(@"%@ error receving messages",error);
                        finishedGettingMyInvites(error,nil);
            
                    }else{
                        NSMutableArray *eventIds = [[NSMutableArray alloc]init];
                        
                        //get all the ids of the events
                        for (PFObject *activity in objects) {
                            [eventIds addObject:[activity objectForKey:@"relatedObjectId"]];
                         };
                        
                        PFQuery *getMyInvites = [PFQuery queryWithClassName:@"UserEvent"];
                        [getMyInvites whereKey:@"objectId" containedIn:eventIds];
                        
                        
                        if (error) {
                            NSLog(@"%@ error receving messages",error);
                            finishedGettingMyInvites(error,nil);
                            
                        }else{
                        
                          [getMyInvites findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) { self.MyInvties = [[NSArray alloc]init];
                                self.MyInvties = objects;
                                finishedGettingMyInvites(nil,objects);
                             }];
                        }
                        
                    }

        
    }];

    
};

-(void)getMyAtritsUpComingGigs:(void (^)(NSError*, NSMutableArray*))finishedGettingMyAtritsUpcomingGigs{
    
    
   //TODO make this dynamic so when you fav a new artist the while thing update
    
    if (self.upComingGigsRelation) {
    
      finishedGettingMyAtritsUpcomingGigs(nil,self.MyArtistUpcomingGigs);

    
    }else if (self.MyArtist) {
    
        self.MyArtistUpcomingGigs = [[NSMutableArray alloc]init];
        
        
        UpcomingGigsLoopCounter = 0;
        
        for (PFObject *artist in self.MyArtist) {
            UpcomingGigsLoopCounter ++;
            
            self.upComingGigsRelation = [artist objectForKey:@"upComingGigsRel"];
            PFQuery *query  = [self.upComingGigsRelation query];
            [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                
                if (error) {
                    NSLog(@"upComingGigsRel error %@",error);
                }else{
                    
                    //NSArray *aritstUpcomingGigs = objects;
                    [self.MyArtistUpcomingGigs addObjectsFromArray:objects];
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
            UpcomingGigsLoopCounter ++;
                
             self.upComingGigsRelation = [artist objectForKey:@"upComingGigsRel"];
             PFQuery *query  = [self.upComingGigsRelation query];
             [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                 
                 if (error) {
                     NSLog(@"upComingGigsRel error %@",error);
                 }else{
                 
                     //NSArray *aritstUpcomingGigs = objects;
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




@end
