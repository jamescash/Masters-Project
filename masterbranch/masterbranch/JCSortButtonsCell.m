//
//  JCSortButtonsCell.m
//  PreAmp
//
//  Created by james cash on 15/11/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCSortButtonsCell.h"

@interface JCSortButtonsCell ()




@end

@implementation JCSortButtonsCell

-(void)formateCellWithBool:(BOOL)sortedByDistanceFromIreland{
    
    if (sortedByDistanceFromIreland) {
        self.UIsegmentControlDistanceDate.selectedSegmentIndex = 0;
    }else{
       self.UIsegmentControlDistanceDate.selectedSegmentIndex = 1;
    }
    
}

-(void)buttonSortByDateClicked{
    
        //self.buttonSortDate.backgroundColor = [UIColor whiteColor];
}
- (IBAction)UIsegmentedControlDistaceDate:(id)sender {

    if (self.JCSortButtonsCellDelagate && [self.JCSortButtonsCellDelagate respondsToSelector:@selector(segmentedControlClicked)])
    {

        [self.JCSortButtonsCellDelagate segmentedControlClicked];
        
   }
    
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
