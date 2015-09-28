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




@interface JCInbox ()<RSDFDatePickerViewDelegate,RSDFDatePickerViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *receivedMessages;
@property (nonatomic,strong) NSArray *messages;
@property (nonatomic,strong) PFObject *selectedMessage;

//calender view
@property (weak, nonatomic) IBOutlet UIView *UIviewCallender;


@end

@implementation JCInbox


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    
    //creat the calender view and add it to them main view hierchy
    JCDatePickerView *datePickerView = [[JCDatePickerView alloc] initWithFrame: CGRectMake(0.0f,self.navigationController.navigationBar.frame.size.height + 20, self.view.bounds.size.width, self.view.bounds.size.height/2)];
    datePickerView.delegate = self;
    datePickerView.dataSource = self;
    [self.view addSubview:datePickerView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewDidAppear:animated];


    PFQuery *query = [PFQuery queryWithClassName:@"Messages"];
    
    //only look at the recipent list and where selfs id is equaled that means this message was meant for me
    [query whereKey:@"recipientIds" equalTo:[[PFUser currentUser] objectId]];
    //order messages via createed at
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@ error receving messages",error);
        }else{
            NSLog(@"we found messages");
            self.messages = objects;
            [self.receivedMessages reloadData];
            NSLog(@"recived %lu messages",(unsigned long)[self.messages count]);
        }
    }];
    
}

#pragma - TableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.messages.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"forIndexPath:indexPath];
    PFObject *message = [self.messages objectAtIndex:indexPath.row];
    cell.textLabel.text = [message objectForKey:@"senderName"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selectedMessage = [self.messages objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"showDetailedView" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"showDetailedView"]) {
            JCInboxDetail *destinationVC = (JCInboxDetail*) segue.destinationViewController;
            destinationVC.message = self.selectedMessage;
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
    // The date is an `NSDate` object without time components.
    // So, we need to use dates without time components.
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    
    NSDateComponents *todayComponents = [calendar components:unitFlags fromDate:[NSDate date]];
    NSDate *today = [calendar dateFromComponents:todayComponents];
    
    return [date isEqual:today];
}

// Returns the color of the default mark image for the specified date.
- (UIColor *)datePickerView:(RSDFDatePickerView *)view markImageColorForDate:(NSDate *)date
{
    if (arc4random() % 2 == 0) {
        return [UIColor grayColor];
    } else {
        return [UIColor greenColor];
    }
}

// Returns the mark image for the specified date.
- (UIImage *)datePickerView:(RSDFDatePickerView *)view markImageForDate:(NSDate *)date
{
    if (arc4random() % 2 == 0) {
        return [UIImage imageNamed:@"img_gray_mark"];
    } else {
        return [UIImage imageNamed:@"img_green_mark"];
    }
}


@end
