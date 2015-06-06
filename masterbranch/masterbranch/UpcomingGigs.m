//
//  UpcomingGigs.m
//  Second_Prototype
//
//  Created by james cash on 01/06/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "UpcomingGigs.h"


@interface UpcomingGigs ()

@end

@implementation UpcomingGigs

- (void)viewDidLoad {
    [super viewDidLoad];
    [self songKickApiCall];

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   // #warning Incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.eventObjects count];
}

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
     
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UpcomingGigs" forIndexPath:indexPath];
 
     eventObject *object = [self.eventObjects objectAtIndex:indexPath.row];
     cell.textLabel.text = [object eventTitle];
     cell.detailTextLabel.text = [object venueName];
     return cell;
 }


-(void) buildEventObjectArray {
    
    self.eventObjects = [[NSMutableArray alloc]init];
   
    eventObject *event = [[eventObject alloc]init];


    
    for (NSDictionary *object in self.upcomingDublinGigs) {
        
        
        NSDictionary *artistdic = object [@"artists"];
        
        
        if ([artistdic count] > 1 ) {
           
           //gig with multiple performers, while loop and i counter to itterate each sningle artist in returened json event
           
            int i = 0;
            while ( i < [artistdic count] )
            {
                
                event = [[eventObject alloc]init];
                
                
                
                //retreving event title to be the artist name
                NSArray *artists = object [@"artists"];
                //i counter in the while loop to choose a diffrent artist everytime for the event object
                NSDictionary *artistinfo = artists [i];
                event.eventTitle = artistinfo[@"name"];
                
                //retreving venue details
                NSDictionary *venue = object [@"venue"];
                event.venueName = venue [@"name"];
                event.LatLong = @{ @"lat" : venue[@"latitude"],
                                   @"long": venue[@"longitude"]
                                   };
                
                //retreving event date
                event.eventDate = object [@"datetime"];
                
                //setting twitter search query 1
                NSMutableString *artistNameHashtag = [[NSMutableString alloc]init];
                [artistNameHashtag appendString:@"#"];
                NSMutableString *venueHashtag = [[NSMutableString alloc]init];
                [venueHashtag appendString:@" #"];
                [artistNameHashtag appendString:artistinfo[@"name"]];
                [venueHashtag appendString:venue [@"name"]];
               // [artistNameHashtag appendString:venueHashtag];
                NSString *encodedrequest = [artistNameHashtag stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];

                event.twitterSearchQuery = encodedrequest;
                
                
                //setup insta search query
                NSString *A = event.eventTitle;
                //remove any white space  //TAKE OUT ANY " OR ' OR ANYTHING THAT PEOPLE WOULDNT NORMALY HASHTAG
                
                NSString *b = [A stringByReplacingOccurrencesOfString:@" " withString:@""];
                NSString *c = [b stringByReplacingOccurrencesOfString:@"'" withString:@""];
                event.InstaSearchQuery = c;
               
                
                [self.eventObjects addObject:event];
                i++;
            
            
            };
        }else {
        
       
            
            //int i = 0;
            //gigs with only one act
           // NSLog(@"this shit is fucked up");
        event = [[eventObject alloc]init];
      
        
            //retreving event title to be the artist name
        NSArray *artists = object [@"artists"];
       
        
            if ([artists count]>0) {
                NSDictionary *artistinfo = artists [0];
                event.eventTitle = artistinfo[@"name"];
            } else {
                event.eventTitle = @"NO EVENT TITLE ****FIX*** ";
            }
            
            
           //retreving venue details
        NSDictionary *venue = object [@"venue"];
        event.venueName = venue [@"name"];
        event.LatLong = @{ @"lat" : venue[@"latitude"],
                           @"long": venue[@"longitude"]
                          };
            
        //retreving event date
        event.eventDate = object [@"datetime"];
            
        //setting twitter search query 1
        NSMutableString *artistNameHashtag = [[NSMutableString alloc]init];
        [artistNameHashtag appendString:@"#"];
        NSMutableString *venueHashtag = [[NSMutableString alloc]init];
        [venueHashtag appendString:@" #"];
       // [artistNameHashtag appendString:artistinfo[@"name"]];
       [artistNameHashtag appendString:event.eventTitle];
       [venueHashtag appendString:venue [@"name"]];
        //[artistNameHashtag appendString:venueHashtag];
        NSString *encodedrequest = [artistNameHashtag stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
            
        event.twitterSearchQuery = encodedrequest;
        
        //setup insta search query
            NSString *A = event.eventTitle;
            //remove any white space  //TAKE OUT ANY " OR ' OR ANYTHING THAT PEOPLE WOULDNT NORMALY HASHTAG

            NSString *b = [A stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSString *c = [b stringByReplacingOccurrencesOfString:@"'" withString:@""];
            event.InstaSearchQuery = c;
            
            //self.i++;
            
        [self.eventObjects addObject:event];
        
        
        

            
        }
//                    NSString *stringRep = [NSString stringWithFormat:@"%@",[] ];
//                    NSLog(@"%@",stringRep);
   
    
    };
    
    [self.tableView reloadData];

    eventObject *object = [self.eventObjects objectAtIndex:1];
            NSString *stringRep = [NSString stringWithFormat:@"%@", [object InstaSearchQuery]];
            NSLog(@"%@",stringRep);
};

- (void) songKickApiCall {
    
    NSURL *url = [NSURL URLWithString:@"http://api.bandsintown.com/events/search.json?api_version=2.0&app_id=YOUR_APP_ID&location=Dublin,Ireland"];
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            NSLog(@"error");
        } else {
            
            self.upcomingDublinGigs = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];

    
            
            
            [self buildEventObjectArray];
            
            
           
            
        }
    }];
}




//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    SocialStream *svc = [segue destinationViewController];
//    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
//    eventObject *s = [self.eventObjects objectAtIndex:path.row];
//    svc.currentevent = s;
//}


@end
