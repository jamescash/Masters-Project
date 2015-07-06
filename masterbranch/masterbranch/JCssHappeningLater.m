//
//  JCssHappeningLater.m
//  masterbranch
//
//  Created by james cash on 29/06/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "JCssHappeningLater.h"

@implementation JCssHappeningLater

-(void)viewWillAppear:(BOOL)animated{
//    
//    //JCSocailStreamController *jc = [[JCSocailStreamController alloc]init];
//   // jc.currentevent = self.currentevent;
//
//    //[self performSegueWithIdentifier:@"happeningRightNowTable" sender:self.currentevent];
//
//
//};
//
    //    JCSocailStreamController *SS = [[JCSocailStreamController alloc]init];
////    
////    
////    SS = [self.childViewControllers objectAtIndex:1];
////    
//    SS.currentevent = self.currentevent;
////
        //self.tableViewBox.subviews
//- (void)addChildViewController:(UIViewController*)childController{
    
//    NSLog(@"HELLO WORLD");
//    
//    eventObject *currentevent = [[eventObject alloc]init];
//    currentevent = self.currentevent;
//    [self performSegueWithIdentifier:@"happeningRightNowTable" sender:currentevent];
    
    //UIViewController *SS = [[JCSocailStreamController alloc]init];
    
    
    // eventObject *currentevent = [[eventObject alloc]init];
    //currentevent = sender;








};





-(void) viewDidLoad{
    
    
//JCssHeaderController *header = [[JCssHeaderController alloc]init];
  //  JCSocailStreamController *ss = [[JCSocailStreamController alloc]init];
    
    //[self displayContentController:ss];
    //[self displayContentController:header];

   
    //self.tableViewBox.view.frame = self.contentView.bounds;
    //[self.contentView addSubview:tableViewController.view];
    /*Calling the addChildViewController: method also calls
     the child’s willMoveToParentViewController: method automatically */
   // [self addChildViewController:tableViewController];
   // [tableViewController didMoveToParentViewController:self];
    
    
         // NSString *stringRep = [NSString stringWithFormat:@"%lu",(unsigned long)[self.childViewControllers description] ];
        // NSLog(@"%@",stringRep);
    
    //UIViewController *SS = [[JCSocailStreamController alloc]init];
    // = self.currentevent;
    //[self addChildViewController:SS];
    
  // JCSocailStreamController *jc = [[JCSocailStreamController alloc]init];
    
    
    //jc.currentevent = self.currentevent;
    
  //  NSLog(@"%@ this is viewdid load",[self.currentevent InstaSearchQuery]);
    
    //[self displayContentController:jc];

};


//
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"happeningRightNowTable"])
    {

      JCSocailStreamController *jc = [segue destinationViewController];

        jc.currentevent = self.currentevent;
//        [self displayContentController:jc];

    }

    if ([segue.identifier isEqualToString:@"happeningRightNowHead"])
    {
        
        JCssHeaderController *jc = [segue destinationViewController];
        
        jc.currentEvent = self.currentevent;
        
        //[self displayContentController:jc.view];
        
        
    }





}


    
    
    
//}//
//- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    NSString * segueName = segue.identifier;
//    if ([segueName isEqualToString: @"happeningRightNowTable"]) {
//        JCSocailStreamController * childViewController = (JCSocailStreamController *) [segue destinationViewController];
//        //JCSocailStreamControll * alertView = childViewController.view;
//        childViewController.currentevent = sender;
//        // do something with the AlertView's subviews here...
//    }
//}


//
//- (void) displayContentController: (UIViewController*) content;
//{
//   // JCSocailStreamController *currentstream = [[JCSocailStreamController alloc]init];
//    
//    [self addChildViewController:content];                 // 1
//    
//   // content.view.frame = self.tableViewBox.frame;
//    
//    //[self.view addSubview:cardView];
//    
//
//     [self.view addSubview:self.tableViewBox];
//    
//    [content didMoveToParentViewController:self];          // 3
//}

- (IBAction)back:(id)sender {
}
@end
