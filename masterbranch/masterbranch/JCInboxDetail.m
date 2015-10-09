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





@interface JCInboxDetail ()
//UIElements
@property (weak, nonatomic) IBOutlet UIView *addCommentView;
@property (weak, nonatomic) IBOutlet UITableView *tableViewVC;
@property (weak, nonatomic) IBOutlet UITextView *addCommentTextfield;
- (IBAction)postComment:(id)sender;

//Classes
@property (nonatomic,strong) JCParseQuerys *parseQuerys;
//properties
@property (nonatomic,strong) NSMutableArray *userCommentActivies;
@property (nonatomic,strong) NSString *eventId;

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
    self.addCommentTextfield.text = @"Add comment here...";
    self.addCommentTextfield.textColor = [UIColor lightGrayColor];
    self.addCommentTextfield.clipsToBounds = YES;
    self.addCommentTextfield.layer.cornerRadius = 5.0f;
    self.addCommentTextfield.layer.borderWidth = 1.0f;
    self.addCommentTextfield.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    //Init parse backend class
    self.parseQuerys = [JCParseQuerys sharedInstance];
    self.eventId = self.userEvent.objectId;
    
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
    
//    UILabel *stickyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//    stickyLabel.backgroundColor = [UIColor colorWithRed:1 green:0.749 blue:0.976 alpha:1];
//    stickyLabel.textAlignment = NSTextAlignmentCenter;
//    stickyLabel.text = [self.userEvent objectForKey:@"eventHostName"];;

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
    static NSString *CellIdentifier = @"SectionHeader";
    UITableViewCell *headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (headerView == nil){
        [NSException raise:@"headerView == nil.." format:@"No cells with matching CellIdentifier loaded from your storyboard"];
    }
    return headerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 130;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.userCommentActivies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JCCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JCCommentCell"];
    PFObject *commentActivity = [self.userCommentActivies objectAtIndex:indexPath.row];
    NSString *comment = [commentActivity objectForKey:@"content"];
    cell.commentText.text = comment;
    CGRect  rect=cell.frame;
    rect.size.height = [cell getCommentHeight:comment Width:self.tableViewVC.frame.size.width];
    cell.frame=rect;
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    //TODO https://github.com/forkingdog/UITableView-FDTemplateLayoutCell
    JCCommentCell *cell = [[JCCommentCell alloc]init];
    PFObject *commentActivity = [self.userCommentActivies objectAtIndex:indexPath.row];
    NSString *comment = [commentActivity objectForKey:@"content"];
    return ([cell getCommentHeight:comment Width:self.tableViewVC.frame.size.width] + 40);
    
}

#pragma - TextField Delagte 

//TODO add tap anywhere to dissmiss the keyboad here
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
    
    [self replaceConstraintOnView:self.view withConstant:keyboardFrame.size.height];

    [self.view addGestureRecognizer:tapRecognizer];

}


-(void) keyboardWillHide:(NSNotification *) note
{
    [self.view removeGestureRecognizer:tapRecognizer];
}


-(void)didTapAnywhere: (UITapGestureRecognizer*) recognizer {
    [self.addCommentTextfield resignFirstResponder];
    [self replaceConstraintOnView:self.view withConstant:0];

}


#pragma mark - Helper Methods -  Animation


- (void)replaceConstraintOnView:(UIView *)view withConstant:(float)constant
{
    
        [self.view.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
        //animating the constrain for the text field
        if ([constraint.identifier isEqualToString:@"TextFieldBottomLayout"]) {
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






- (IBAction)postComment:(id)sender {
    
    
   
    
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
    [self replaceConstraintOnView:self.view withConstant:0];




}

-(void)refreshTableViewAfterUserCommented{
    
    
    [self.parseQuerys getEventComments:self.eventId complectionBlock:^(NSError *error, NSMutableArray *response) {
        
        
        self.userCommentActivies = response;
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
           [self.tableViewVC reloadData];
        });
    }];
}












@end
