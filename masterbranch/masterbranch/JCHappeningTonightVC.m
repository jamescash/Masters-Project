//
//  JCHappeningTonightVC.m
//  masterbranch
//
//  Created by james cash on 18/08/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "JCHappeningTonightVC.h"
#import "JCHappeningTonightHeaderVC.h"


@interface JCHappeningTonightVC ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UITableView *TableView;

//@property (nonatomic, strong) UIImageView *blurredImageView;
@property (nonatomic, assign) CGFloat screenHeight;


- (IBAction)BackButton:(id)sender;



@end

@implementation JCHappeningTonightVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    

    self.screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    //TODO make this be a UIImage
    
    self.backgroundImageView.image = self.currentEvent.photoDownload.image;
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    //[self.view addSubview:self.backgroundImageView];
    
    
    //self.blurredImageView = [[UIImageView alloc] init];
    //self.blurredImageView.contentMode = UIViewContentModeScaleAspectFill;
    //self.blurredImageView.alpha = 0;
    //[self.blurredImageView setImageToBlur:background blurRadius:10 completionBlock:nil];
    //[self.view addSubview:self.blurredImageView];
    
    // 4
    //self.TableView = [[UITableView alloc] init];
    self.TableView.backgroundColor = [UIColor clearColor];
    self.TableView.delegate = self;
    self.TableView.dataSource = self;
    self.TableView.separatorColor = [UIColor colorWithWhite:1 alpha:0.2];
    self.TableView.pagingEnabled = YES;
    //[self.view addSubview:self.TableView];
    
    CGRect headerFrame = [[UIScreen mainScreen] bounds];
    UIView *header = [[UIView alloc] initWithFrame:headerFrame];
    header.backgroundColor = [UIColor clearColor];
    
    UIViewController *HeaderView =[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"JCHappeningTonightHeader"];
    
    [self addChildViewController:HeaderView];
    
    HeaderView.view.frame = headerFrame;
    
    [header addSubview:HeaderView.view];
    
    [HeaderView didMoveToParentViewController:self];
    
    
    
    self.TableView.tableHeaderView = header;
    
    
  
    
    
    
    
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    //CGRect bounds = self.view.bounds;
    
    //self.backgroundImageView.frame = bounds;
    //self.blurredImageView.frame = bounds;
    //self.TableView.frame = bounds;
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
    return 0;
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
    
    // TODO: Setup the cell
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Determine cell height based on screen
    return 44;
}



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
