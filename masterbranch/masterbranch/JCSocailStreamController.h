//
//  JCSocailStreamController.h
//  masterbranch
//
//  Created by james cash on 28/06/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "eventObject.h"
#import "JCHttpFacade.h"
#import "JCEndpointConstructor.h"





@interface JCSocailStreamController : UITableViewController <JCHttpFacadedelegate>;



@property (nonatomic,strong) JCEndpointConstructor *JCEndpointdelegate;
@property (nonatomic) eventObject *currentevent;

//This is the socialstream view contoller.
//This class connects to the data source and constructs the tableView. It is the VC from the MVC.


//This method goes to facebook with a venue name and Lat Long and finds a facebook ID for the venue in question
//-(void)getFbPlaceID:(NSString*)venueName location:(NSString*)location;


//This method takes the facebook ID to instagram and exchanges it for an instagram ID and then makes an EndPoint than can be sent
//to the connectToInstagramWithCorrectEndPoint method
//-(void)getInstagramPlaceIDfromFBplaceID: (NSString*) FBplaceIDstring;

//this method conntects to instagram with any given endpoint finds the data and then gives it to the JCFeedObject class to constuct
 //an array of social stream feedobjects:(prototypeEntitiesFromJSON) that are then haned to the tableView cellForRowAtIndexPath method that constructs a JCsocialStramCell object for each JCFeedObject in the array prototypeEntitiesFromJSON
-(void)connectToInstagramWithCorrectEndPoint: (NSString*)endpoint then: (void (^)(void))then;

@end
