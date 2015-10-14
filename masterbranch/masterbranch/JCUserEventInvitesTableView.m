//
//  JCUserEventInvitesTableView.m
//  PreAmp
//
//  Created by james cash on 09/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCUserEventInvitesTableView.h"
#import <Parse/Parse.h>
#import "JCParseQuerys.h"
#import "JCInboxDetail.h"
#import <UIKit/UIKit.h>
#import "JCInvitationCell.h"



@interface JCUserEventInvitesTableView ()
//UI elements
//@property (weak, nonatomic) IBOutlet UITableView *MyGigInvitesTable;
//Properties
@property (nonatomic,strong) PFObject *selectedInvite;
@property (nonatomic,strong) UIImage *selectedInviteImage;
@property (nonatomic,strong) NSArray *myInvites;
@property (nonatomic,strong) NSString *className;

//classes
@property (nonatomic,strong) JCParseQuerys *JCParseQuery;


@end

@implementation JCUserEventInvitesTableView

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    self = [super initWithClassName:@"UserEvent"];

    if (self) {
        // Customize the table
        // The className to query on
        self.className = @"UserEvent";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"text";
        
        // Uncomment the following line to specify the key of a PFFile on the PFObject to display in the imageView of the default cell style
        // self.imageKey = @"image";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 25;
    }
    return self;
}
//- (instancetype)initWithClassName:(PFUI_NULLABLE NSString *)className{
//    self = [super initWithClassName:className];
//    
//    if (self) {
//    
//    self.className = @"UserEvent";
//    
//    }
//    
//    return self;
//    
//};


- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.className = @"UserEvent";

    //[self.tableView registerClass:[JCInvitationCell class] forCellReuseIdentifier:@"Cell1"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - TableView

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query whereKey:@"invited" equalTo:[[PFUser currentUser]objectId]];
    [query orderByDescending:@"createdAt"];

    return query;
}



//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 1;
//}

//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    
//    return self.myInvites.count;
//}

//-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
  //  [super tableView:tableView didSelectRowAtIndexPath:indexPath];

//
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"forIndexPath:indexPath];
//    PFObject *eventInvite = [self.myInvites objectAtIndex:indexPath.row];
//    
//    cell.textLabel.text = [eventInvite objectForKey:@"eventHostName"];
//    
//    PFFile *imageFile = [eventInvite objectForKey:@"eventPhoto"];
//    NSURL *imageFileURL = [[NSURL alloc]initWithString:imageFile.url];
//    NSData *imageData = [NSData dataWithContentsOfURL:imageFileURL];
//    //add it to a class property so we can pass it to the events page Class
//    cell.imageView.image = [UIImage imageWithData:imageData];
//    return cell;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object {
    
    //[super tableView:tableView cellForRowAtIndexPath:indexPath object:object];
    
    static NSString *cellIdentifier = @"Cell1";
    

    JCInvitationCell *cell = (JCInvitationCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    ///if (cell == nil) {
        
        //cell = [[JCInvitationCell alloc] init];
        
    //}
    
    // Configure the cell to show todo item with a priority at the bottom
    //cell.ArtistName.text = object[@"eventHostName"];
    cell.ArtistName.text = @"eventHostName";
    //cell.backroundImage.image = [UIImage imageNamed:@"artist.png"];
    
    NSLog(@"%@",cell.ArtistName.text);
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //self.selectedInvite = [self.myInvites objectAtIndex:indexPath.row];
    //UITableViewCell *cellatindex = [[UITableViewCell alloc]init];
    //cellatindex = [tableView cellForRowAtIndexPath:indexPath];
    //self.selectedInviteImage = cellatindex.imageView.image;
    [self performSegueWithIdentifier:@"showEvent" sender:self];
    
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"showEvent"]) {
        
        
        
        JCInboxDetail *destinationVC = (JCInboxDetail*) segue.destinationViewController;
        NSInteger row = [[self tableView].indexPathForSelectedRow row];
        
        //NSLog(@"object to pass %@",[self.objects objectAtIndex:row]);
        
        destinationVC.userEvent = [self.objects objectAtIndex:row];
        //destinationVC.selectedInviteImage =
      }
}



@end
