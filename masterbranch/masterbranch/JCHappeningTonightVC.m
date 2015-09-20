//
//  JCHappeningTonightVC.m
//  masterbranch
//
//  Created by james cash on 18/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "JCHappeningTonightVC.h"


@interface JCHappeningTonightVC ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UITableView *TableView;
@property (weak, nonatomic) IBOutlet UIView *TableViewHeaderVC;

//@property (nonatomic, strong) UIImageView *blurredImageView;
@property (nonatomic, assign) CGFloat screenHeight;


- (IBAction)BackButton:(id)sender;



@end

@implementation JCHappeningTonightVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.screenHeight = [UIScreen mainScreen].bounds.size.height;
    self.backgroundImageView.image = self.currentEvent.photoDownload.image;
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    
    //self.blurredImageView = [[UIImageView alloc] init];
    //self.blurredImageView.contentMode = UIViewContentModeScaleAspectFill;
    //self.blurredImageView.alpha = 0;
    //[self.blurredImageView setImageToBlur:background blurRadius:10 completionBlock:nil];
    //[self.view addSubview:self.blurredImageView];
    
    self.TableView.backgroundColor = [UIColor clearColor];
    self.TableView.separatorColor = [UIColor colorWithWhite:1 alpha:1];
    self.TableView.pagingEnabled = YES;
    


}




- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"tableviewheader"]) {
        
        JCHappeningTonightHeaderVC * childViewController = (JCHappeningTonightHeaderVC *) [segue destinationViewController];
        childViewController.currentEvent = self.currentEvent;
        childViewController.JCHappeningTonightHearderVCDelegate = self;
    }

}

- (void) displayContentController: (UIViewController*) content;
{
    [self addChildViewController:content];
    //content.view.frame = [[UIScreen mainScreen]bounds]; // 2
    //[self.TableViewHeaderVC addSubview:content.view];
    [content didMoveToParentViewController:self];// 3
}


- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
     static NSString *CellIdentifier = @"HappeningTonightCell1";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (! cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    // 3
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = @"Test";
    return cell;
}

#pragma mark - UITableViewDelegate

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    // TODO: Determine cell height based on screen
//    return 44;
//}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}



- (IBAction)BackButton:(id)sender {
    
    [self.JCHappeningTonightVCDelegate JCHappeningTonightDidSelectDone:self];
}
@end
