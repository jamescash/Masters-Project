//
//  JCSortButtonsCell.h
//  PreAmp
//
//  Created by james cash on 15/11/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JCSortButtonsCellDelagate;


@interface JCSortButtonsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISegmentedControl *UIsegmentControlDistanceDate;

//-(void)buttonSortByDateClicked;
-(void)formateCellWithBool:(BOOL)sortedByDistanceFromIreland;
@property (weak, nonatomic) id<JCSortButtonsCellDelagate>JCSortButtonsCellDelagate;
@end

@protocol JCSortButtonsCellDelagate <NSObject>

-(void)segmentedControlClicked;

@end