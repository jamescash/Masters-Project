//
//  JCInboxDetail.m
//  PreAmp
//
//  Created by james cash on 20/09/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCInboxDetail.h"
#import "HeaderViewWithImage.h"
#import "HeaderView.h"
#import "JCHomeMainScreenVC.h"
#import "JCCommentCell.h"
#import "JCParseQuerys.h"
#import "JCTimeDateLocationTableViewCell.h"
#import "JCUserAttendingGigCell.h"
#import "JCConstants.h"






@interface JCInboxDetail ()
//UIElements
@property (weak, nonatomic) IBOutlet UIView *addCommentView;
@property (weak, nonatomic) IBOutlet UITableView *tableViewVC;
@property (weak, nonatomic) IBOutlet UIView *tableviewFooter;
@property (weak, nonatomic) IBOutlet UITextView *addCommentTextfield;
- (IBAction)postComment:(id)sender;
- (IBAction)buttonAreYouGoing:(id)sender;

//Classes
@property (nonatomic,strong) JCParseQuerys *parseQuerys;
//properties
@property (nonatomic,strong) NSMutableArray *userCommentActivies;
@property (nonatomic,strong) NSString *eventId;
@property (nonatomic,strong) NSString *going;
@property (nonatomic,strong) NSString *maybe;
@property (nonatomic,strong) NSString *notGoing;
@property (nonatomic,strong) NSString *gotTickets;
@property (nonatomic,strong) NSMutableDictionary *userAttendingEvent;



@end

@implementation JCInboxDetail{
   //for resiging first responder
   UITapGestureRecognizer *tapRecognizer;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    //set placeholdertext for comment box and set up boreder
    self.going = @"going";
    self.gotTickets = @"gotTickets";
    self.maybe = @"maybe";
    self.notGoing = @"notGoing";
    
    
    [self addCustomButtonOnNavBar];
    
    self.addCommentTextfield.text = @"Add comment here...";
    self.addCommentTextfield.textColor = [UIColor lightGrayColor];
    self.addCommentTextfield.clipsToBounds = YES;
    self.addCommentTextfield.layer.cornerRadius = 5.0f;
    self.addCommentTextfield.layer.borderWidth = 1.0f;
    self.addCommentTextfield.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    //Init parse backend class
    self.parseQuerys = [JCParseQuerys sharedInstance];
    self.eventId = self.userEvent.objectId;
    self.tableViewVC.allowsSelection = NO;
    
    [self.parseQuerys getEventComments:self.eventId complectionBlock:^(NSError *error, NSMutableArray *response) {
        
        self.userCommentActivies = response;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableViewVC reloadData];
        });
        
        
    }];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardOnScreen:) name:UIKeyboardDidShowNotification object:nil];
    //add tap recongiser that will resign first responder while keybord is up and user taps anywhere
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                            action:@selector(didTapAnywhere:)];

    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    HeaderViewWithImage *headerView = [HeaderViewWithImage instantiateFromNib];
    headerView.HeaderImageView.image = self.selectedInviteImage;
    headerView.ArtistName.text = [self.userEvent objectForKey:@"eventTitle"];
    [self.tableViewVC setParallaxHeaderView:headerView
                                          mode:VGParallaxHeaderModeFill
                                        height:200];
    
    self.tableViewVC.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.addCommentTextfield.delegate = self;
    [self getUserAttendingEvent];


}




- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.tableViewVC shouldPositionParallaxHeader];
}
#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"Section %@", @(section)];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *CellIdentifier = @"timeDateLocationCell";
    JCTimeDateLocationTableViewCell *headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [headerView formatCellwithParseEventObject:self.userEvent];
    if (headerView == nil){
        [NSException raise:@"headerView == nil.." format:@"No cells with matching CellIdentifier loaded from your storyboard"];
    }
    return headerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 145;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return ([self.userCommentActivies count] + 1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row == 0) {
        JCUserAttendingGigCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SectionHeader"];
        if (self.userAttendingEvent) {
            [cell formatCell:self.userAttendingEvent andMyStatus:nil];

        }else{
            [cell formatCell:nil andMyStatus:nil];

        }
        return cell;
        
    }else{
    
    JCCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JCCommentCell"];
    PFObject *commentActivity = [self.userCommentActivies objectAtIndex:(indexPath.row-1)];
    [cell formatcell:commentActivity];
    
    return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 100;
        
    }else{
    
    JCCommentCell *cell = [[JCCommentCell alloc]init];
    PFObject *commentActivity = [self.userCommentActivies objectAtIndex:(indexPath.row - 1)];
    NSString *comment = [commentActivity objectForKey:@"content"];
    return ([cell getCommentHeight:comment Width:self.tableViewVC.frame.size.width - 70] + 100);
    }
}

#pragma - TextField Delagte 

//TODO create a keyboard helper class

- (void)textViewDidChange:(UITextView *)textView
{
    
    if(self.addCommentTextfield.text.length == 0){
        self.addCommentTextfield.textColor = [UIColor lightGrayColor];
        self.addCommentTextfield.text = @"Add comment here...";
        [self.addCommentTextfield resignFirstResponder];
    }
    
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    self.addCommentTextfield.text = @"";
    self.addCommentTextfield.textColor = [UIColor blackColor];
    return YES;
}

#pragma mark - Helper Methods - Keyboard

-(void)keyboardOnScreen:(NSNotification *)notification
{
    NSDictionary *info  = notification.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    
    //[self replaceConstraintOnView:self.view withConstant:keyboardFrame.size.height];
    [self replaceConstraintOnView:self.view withIdentifiyer:@"TextFieldBottomLayout" withConstant:keyboardFrame.size.height];
    [self replaceConstraintOnView:self.view withIdentifiyer:@"footerHeight" withConstant:keyboardFrame.size.height];

    //[self replaceConstraintOnView:self.view withConstant:keyboardFrame.size.height];

    [self.view addGestureRecognizer:tapRecognizer];

}


-(void) keyboardWillHide:(NSNotification *) note
{
    [self.view removeGestureRecognizer:tapRecognizer];
}


-(void)didTapAnywhere: (UITapGestureRecognizer*) recognizer {
    [self.addCommentTextfield resignFirstResponder];
    [self replaceConstraintOnView:self.view withIdentifiyer:@"TextFieldBottomLayout" withConstant:0];

}


#pragma mark - Helper Methods -  Animation

- (void)addCustomButtonOnNavBar
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage im];
    //imageView.alpha = 0.5; //Alpha runs from 0.0 to 1.0
    
    [backButton setImage:[UIImage imageNamed:@"iconBack.png"] forState:UIControlStateNormal];
    backButton.adjustsImageWhenDisabled = NO;
    //set the frame of the button to the size of the image (see note below)
    backButton.frame = CGRectMake(0, 0, 40, 40);
    backButton.opaque = YES;
    
    [backButton addTarget:self action:@selector(BackButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    //create a UIBarButtonItem with the button as a custom view
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.navigationItem.leftBarButtonItem = customBarItem;
}

-(void)BackButtonPressed{
[self.navigationController popViewControllerAnimated:YES];
}

- (void)replaceConstraintOnView:(UIView *)view withIdentifiyer: (NSString*)Identifyer withConstant:(float)constant{
    
    
    [self.view.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
        // animating the constrain for the text field
        if ([constraint.identifier isEqualToString:Identifyer]) {
            constraint.constant = constant;
            [self animateConstraints];
        };
        
        
    }];
}

- (void)animateConstraints
{
    
    [UIView animateWithDuration:0.15 animations:^{
        [self.view layoutIfNeeded];
    }];
}


-(IBAction)postComment:(id)sender {
    
    //Trim comment and save it in a dictionary
    NSDictionary *userInfo = [NSDictionary dictionary];
    NSString *trimmedComment = [self.addCommentTextfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (trimmedComment.length != 0) {
        userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                    trimmedComment,@"comment",
                    self.eventId,@"eventId",
                    nil];
    }
    
    //userInfo might contain any caption which might have been posted by the uploader
    if (userInfo) {
        
        //go off to the parse class and save the comment to the backend
        [self.parseQuerys saveCommentToBackend:userInfo complectionBlock:^(NSError *error)
         {
             if(error){
                 //show alert view
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Ooops!" message:@"Please try sending that message again there was an error" delegate:self cancelButtonTitle:@"okay" otherButtonTitles:nil];
                 [alert show];
             }else{
                 dispatch_async(dispatch_get_main_queue(), ^{
                     NSLog(@"table view reloaded");
                     [self refreshTableViewAfterUserCommented];
                 });
             }
            
        }];
        
       
    }

     self.addCommentTextfield.textColor = [UIColor lightGrayColor];
     self.addCommentTextfield.text = @"Add comment here...";
    [self.addCommentTextfield resignFirstResponder];
    [self replaceConstraintOnView:self.view withIdentifiyer:@"TextFieldBottomLayout" withConstant:0];




}

-(IBAction)buttonAreYouGoing:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Are you attending?" delegate:self cancelButtonTitle:@"Cancle" destructiveButtonTitle:nil otherButtonTitles:@"I'm Going", @"I'm Going and I have my ticket",@"Maybe", @"I cant make it", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    actionSheet.destructiveButtonIndex = 1;
    [actionSheet showInView:self.view];
    
}

-(void)refreshTableViewAfterUserCommented{
    
    
    [self.parseQuerys getEventComments:self.eventId complectionBlock:^(NSError *error, NSMutableArray *response) {
        
        self.userCommentActivies = response;
        dispatch_async(dispatch_get_main_queue(), ^{
           [self.tableViewVC reloadData];
        });
    }];
}


-(void)performSegueToPeopleAttendingPage{
    NSLog(@"tap");
}
#pragma - ActionSheet Delagate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self userChagnedStatus:self.going];
    }
    else if (buttonIndex == 1)
    {
        [self userChagnedStatus:self.gotTickets];
    }
    
    else if (buttonIndex == 2)
    {
        [self userChagnedStatus:self.maybe];
    }
    else if (buttonIndex == 3)
    {
        [self userChagnedStatus:self.notGoing];
    }
}

-(void)userChagnedStatus:(NSString*)userStatus{
    
    [self.parseQuerys updateUserEventStatus:userStatus eventobjectId:self.userEvent.objectId completionBlock:^(NSError *error) {
        if (error) {
            NSLog(@"error updateUserEventStatus %@",error);
        }else {
            [self getUserAttendingEvent];
        
        }
        
    }];
}



-(void)getUserAttendingEvent{
    
    [self.parseQuerys getUsersAttendingUserEvent:self.userEvent.objectId completionBlock:^(NSError *error, NSMutableDictionary *usersAttending) {
        
        
        
        self.userAttendingEvent = usersAttending;
        NSArray *userInvited = [self.userEvent objectForKey:JCUserEventUsersInvited];
        [self.userAttendingEvent setObject:userInvited forKey:JCUserEventUsersInvited];
       
        dispatch_async(dispatch_get_main_queue(), ^{
            NSIndexPath* indexPath1 = [NSIndexPath indexPathForRow:0 inSection:0];
            NSArray* indexArray = [NSArray arrayWithObjects:indexPath1, nil];
            [self.tableViewVC reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
            });
    }];
    
}






@end
