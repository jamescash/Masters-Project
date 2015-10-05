//
//  JCInbox.m
//  PreAmp
//
//  Created by james cash on 19/09/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCInbox.h"
#import "JCInboxDetail.h"
//standered calander
#import "RSDFDatePickerView.h"

//my one
#import "JCDatePickerView.h"
#import <Parse/Parse.h>
#import "JCParseQuerys.h"
#import <UIKit/UIKit.h>








@interface JCInbox ()<RSDFDatePickerViewDelegate,RSDFDatePickerViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *receivedMessages;
@property (nonatomic,strong) NSArray *myInvites;
@property (nonatomic,strong) NSArray *myArtist;

@property (nonatomic,strong) PFObject *selectedInvite;

//calender view
@property (nonatomic,strong)JCDatePickerView *datePickerView;
@property (nonatomic,strong) JCParseQuerys *JCParseQuery;
@property (nonatomic,strong) NSMutableArray *UpcomingGigDates;
@property (nonatomic,strong) NSSet *dateSet;

@property (nonatomic,strong) UIImage *testImage;

@end

@implementation JCInbox{
    int UpcomingGigsLoopCounter;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.testImage = [self shouldResizeImage:[UIImage imageNamed:@"artist.png"]];

    _JCParseQuery = [JCParseQuerys sharedInstance];
    
    
    [self.JCParseQuery getMyAtritsUpComingGigs:^(NSError *error, NSMutableArray *response) {
        self.UpcomingGigDates = [[NSMutableArray alloc]init];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-LL-dd HH:mm:ss"];
        for (id event in response) {
            NSString *objectdate = [event objectForKey:@"datetime"];
            NSString *dateformatted = [objectdate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
            NSDate *date = [dateFormat dateFromString:dateformatted];
            NSCalendar *calendar = [NSCalendar currentCalendar];
            unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
            NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:date];
            NSDate *FormattedDate = [calendar dateFromComponents:dateComponents];
            [self.UpcomingGigDates addObject:FormattedDate];
           }
         self.dateSet = [NSSet setWithArray:self.UpcomingGigDates];
        [self.datePickerView reloadData];
    }];
    
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    
    //creat the calender view and add it to them main view hierchy
    self.datePickerView = [[JCDatePickerView alloc] initWithFrame: CGRectMake(0.0f,self.navigationController.navigationBar.frame.size.height + 20, self.view.bounds.size.width, self.view.bounds.size.height/2)];
    self.datePickerView.delegate = self;
    self.datePickerView.dataSource = self;
    [self.view addSubview:self.datePickerView];
    
    
    [self.JCParseQuery getMyInvites:^(NSError *error, NSArray *response) {
        
        self.myInvites = response;
        [self.receivedMessages reloadData];
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewDidAppear:animated];


    
    
}

#pragma - TableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.myInvites.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"forIndexPath:indexPath];
    PFObject *eventInvite = [self.myInvites objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [eventInvite objectForKey:@"eventHostName"];
    
    PFFile *imageFile = [eventInvite objectForKey:@"eventPhoto"];
    NSURL *imageFileURL = [[NSURL alloc]initWithString:imageFile.url];
    NSData *imageData = [NSData dataWithContentsOfURL:imageFileURL];
    cell.imageView.image = [UIImage imageWithData:imageData];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selectedInvite = [self.myInvites objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"showDetailedView" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"showDetailedView"]) {
            JCInboxDetail *destinationVC = (JCInboxDetail*) segue.destinationViewController;
            destinationVC.userEvent = self.selectedInvite;
     }
}

#pragma - Calender Delagets

// Returns YES if the date should be highlighted or NO if it should not.
- (BOOL)datePickerView:(RSDFDatePickerView *)view shouldHighlightDate:(NSDate *)date
{
    
    return YES;
}

// Returns YES if the date should be selected or NO if it should not.
- (BOOL)datePickerView:(RSDFDatePickerView *)view shouldSelectDate:(NSDate *)date
{
    return YES;
}

// Prints out the selected date.
- (void)datePickerView:(RSDFDatePickerView *)view didSelectDate:(NSDate *)date
{
    NSLog(@"%@", [date description]);
}

#pragma - Calender DataSource

// Returns YES if the date should be marked or NO if it should not.
- (BOOL)datePickerView:(RSDFDatePickerView *)view shouldMarkDate:(NSDate *)date
{
    
    if ([self.dateSet containsObject:date])
    {
        return YES;
    }else{
       return NO;
    }
}

// Returns the color of the default mark image for the specified date.
- (UIColor *)datePickerView:(RSDFDatePickerView *)view markImageColorForDate:(NSDate *)date
{
    if (arc4random() % 2 == 0) {
        return [UIColor yellowColor];
    } else {
        return [UIColor purpleColor];
    }
}

// Returns the mark image for the specified date.
- (UIImage *)datePickerView:(RSDFDatePickerView *)view markImageForDate:(NSDate *)date
{
    if (arc4random() % 2 == 0) {
        return self.testImage;
    } else {
        return self.testImage;
    }
}


#pragma - Helper Methods

- (UIImage*)shouldResizeImage:(UIImage *)anImage {
    
    UIImage *thumbnail = [UIImage imageWithCGImage:(__bridge CGImageRef _Nonnull)(anImage)
                                             scale:0.2
                                       orientation:anImage.imageOrientation];
    return thumbnail;
}







@end
