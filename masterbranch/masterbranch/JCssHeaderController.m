//
//  JCssHeaderController.m
//  masterbranch
//
//  Created by james cash on 30/06/2015.
//  Copyright (c) 2015 com.james.www. All rights reserved.
//

#import "JCssHeaderController.h"

#define BUFFERX 10 //distance from side to the card (higher makes thinner card)
#define BUFFERY 20 //distance from top to the card (higher makes shorter card)

@interface JCssHeaderController ()

@end

@implementation JCssHeaderController

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    
      self.view.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    
    
   //JCssHeadObject *cardView= [[JCssHeadObject alloc]initWithFrame:CGRectMake(BUFFERX, BUFFERY, self.view.frame.size.width-2*BUFFERX, self.view.frame.size.height-2*BUFFERY)];
    
    JCssHeadObject *cardView = [[JCssHeadObject alloc]initWithFrame:CGRectMake(BUFFERX, BUFFERY, self.view.frame.size.width-2*BUFFERX, self.view.frame.size.height-2*BUFFERY) andCurrentEvent:self.currentEvent];
  
 
    
//    
//NSString *stringRep = [NSString stringWithFormat:@"%f",self.view.frame.size.width];
//    
//   // NSLog(@"%@ self.view.bounds.size.width",stringRep);
//    
//    NSString *stringRep1 = [NSString stringWithFormat:@"%f",self.view.frame.size.height];
//    
//    
//    
//    NSLog(@"%@ self.view.bounds.size.height",stringRep1);
    

    
    
//    cardView.ArtistName.text = self.currentEvent.eventTitle;
//    cardView.Location.text = self.currentEvent.venueName;
//    //self.dateAndTime.text = self.currentEvent.eventDate;
//    cardView.profilePic.image = self.currentEvent.coverpic.image;
//    cardView.coverPic.image = self.currentEvent.coverpic.image;

    [self.view addSubview:cardView];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
