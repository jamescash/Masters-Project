//
//  JCTutorialRootVC.m
//  PreAmp
//
//  Created by james cash on 03/12/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCTutorialRootVC.h"
#import "LogginScreenOne.h"

@interface JCTutorialRootVC ()
@property (nonatomic,strong) LogginScreenOne *logginScreenVC;
@end

@implementation JCTutorialRootVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.UIImageBG.image = [UIImage imageNamed:@"backgroundLogin"];
    self.UIImageBG.contentMode = UIViewContentModeScaleAspectFill;
    
    _pageTitles = @[@"Welcome to Preamp",@"Browse", @"Invite", @"Discover",@"loggin Screen"];
    //_pageTitles = @[@"Welcome to Preamp",@"", @"", @"",@"loggin Screen"];

    _pageImages = @[@"welcomeScreen",@"tutorial1",@"tutorial2",@"tutorial3"];
    _textDiscription = @[@"Swipe through for a quick tutorial         >>>>",@"See what gigs are happening around your current location",@"Ask your firends to attend upcoming gigs with you",@"Discover when your favorite artists are palying in Ireland"];
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    JCTutorialPageViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    //self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    
    NSUInteger index = ((JCTutorialPageViewController*) viewController).pageIndex;
    

    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((JCTutorialPageViewController*) viewController).pageIndex;
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    
    if (index == 4) {
        return [self returnLoginVC:index];
    }
    
    if (index == [self.pageTitles count]) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageTitles count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}


- (JCTutorialPageViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    JCTutorialPageViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    pageContentViewController.titleText = self.pageTitles[index];
    pageContentViewController.imageFile = self.pageImages[index];
    pageContentViewController.LableDescription = self.textDiscription[index];
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}

-(UIViewController *)returnLoginVC:(NSUInteger)index{
  
    LogginScreenOne *logginScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    logginScreen.pageIndex = index;
    return logginScreen;
    
};
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
