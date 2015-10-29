//
//  JCDropDownMenu.m
//  PreAmp
//
//  Created by james cash on 28/10/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCDropDownMenu.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreImage/CoreImage.h>


@interface JCDropDownMenu()

//ButtonViews
@property (strong ,nonatomic) UIView *contextMenuButtonFirst;
@property (strong ,nonatomic) UIView *contextMenuButtonSecond;
@property (strong ,nonatomic) UIView *contextMenuButtonThird;
//BottonLables
@property (strong ,nonatomic) UILabel *contextMenuLableForButtonFirst;
@property (strong ,nonatomic) UILabel *contextMenuLableForButtonSecond;
@property (strong ,nonatomic) UILabel *contextMenuLableForButtonThird;


//UIDynamics
@property (nonatomic, strong) UIDynamicAnimator *animator;
@end

@implementation JCDropDownMenu{
    
    BOOL contextMenuDown;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
        
        //self.backgroundColor = [UIColor orangeColor];
        
        CGRect  viewRect = CGRectMake(self.bounds.size.width-56 ,(self.bounds.size.height-(self.bounds.size.height-21)), 40, 40);
         [self layoutUI:viewRect];
        
        [self animatContextMenu];

        
    }
    return self;
}

-(void)animatContextMenu{
    
    if (contextMenuDown) {
        [self animatContextMenuUp];
        double delayInSeconds = .4;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            self.hidden =YES;
        });
    }else{
        self.hidden = NO;
        [self animatContextMenuDown];
    }
}

-(void)layoutUI:(CGRect)frame{
           //Botton 3
            UITapGestureRecognizer *contextMenuButtonThird =
            [[UITapGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(contextMenuButtonThirdTapped)];
            contextMenuButtonThird.numberOfTapsRequired = 1;
            contextMenuButtonThird.numberOfTouchesRequired = 1;
    
            self.contextMenuButtonThird = [[UIView alloc]initWithFrame:frame];
    
    
    
    
    
            self.contextMenuButtonThird.backgroundColor = [UIColor purpleColor];
    
    
            //Lable 3
            self.contextMenuLableForButtonThird = [[UILabel alloc] init];
            [self.contextMenuLableForButtonThird setFrame:CGRectMake(-55,10,100,22)];
            self.contextMenuLableForButtonThird.backgroundColor=[UIColor clearColor];
            self.contextMenuLableForButtonThird.textColor=[UIColor whiteColor];
            self.contextMenuLableForButtonThird.userInteractionEnabled=YES;
            [self.contextMenuButtonThird addSubview:self.contextMenuLableForButtonThird];
            [self.contextMenuLableForButtonThird setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    
    
            [self.contextMenuButtonThird addGestureRecognizer:contextMenuButtonThird];
            contextMenuButtonThird.delegate = self;
    
            [self addSubview:self.contextMenuButtonThird];
    
    
    //Botton 2
    self.contextMenuButtonSecond = [[UIView alloc]initWithFrame:frame];
    self.contextMenuButtonSecond.backgroundColor = [UIColor greenColor];
    UITapGestureRecognizer *contextMenuButtonSecond =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(contextMenuButtonSecondTapped)];
    //Lable 2
    self.contextMenuLableForButtonSecond = [[UILabel alloc] init];
    [self.contextMenuLableForButtonSecond setFrame:CGRectMake(-55,10,100,22)];

    self.contextMenuLableForButtonSecond.backgroundColor=[UIColor clearColor];
    self.contextMenuLableForButtonSecond.textColor=[UIColor whiteColor];
    self.contextMenuLableForButtonSecond.userInteractionEnabled=YES;
    [self.contextMenuButtonSecond addSubview:self.contextMenuLableForButtonSecond];
    [self.contextMenuLableForButtonSecond setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    [self.contextMenuButtonSecond addGestureRecognizer:contextMenuButtonSecond];
    contextMenuButtonSecond.delegate = self;
    [self addSubview:self.contextMenuButtonSecond];
    
    
    //Button 1
    self.contextMenuButtonFirst = [[UIView alloc]initWithFrame:frame];
    self.contextMenuButtonFirst.backgroundColor = [UIColor yellowColor];
    UITapGestureRecognizer *contextMenuButtonFirst =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(contextMenuButtonFirstTapped)];
    //Lable 1
    self.contextMenuButtonFirst.userInteractionEnabled = YES;
    self.contextMenuLableForButtonFirst = [[UILabel alloc] init];
    [self.contextMenuLableForButtonFirst setFrame:CGRectMake(-105,10,100,23)];
    self.contextMenuLableForButtonFirst.backgroundColor=[UIColor clearColor];
    self.contextMenuLableForButtonFirst.textColor=[UIColor whiteColor];
    self.contextMenuLableForButtonFirst.userInteractionEnabled=YES;
    [self.contextMenuButtonFirst addSubview:self.contextMenuLableForButtonFirst];
    [self.contextMenuLableForButtonFirst setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    
    [self.contextMenuButtonFirst addGestureRecognizer:contextMenuButtonFirst];
    contextMenuButtonFirst.delegate = self;
    [self addSubview:self.contextMenuButtonFirst];
    
    
    UITapGestureRecognizer *contextMenuButtonCover =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(contextMenuButtonCoverTapped)];
    
    self.contextMenuButtonCover = [[UIView alloc]initWithFrame:frame];
    //self.contextMenuButtonCover.center = CGPointMake(self.bounds.size.width  / 2,
      //                               self.bounds.size.height / 2);
    self.contextMenuButtonCover.backgroundColor = [UIColor grayColor];
    [self.contextMenuButtonCover addGestureRecognizer:contextMenuButtonCover];


    [self addSubview:self.contextMenuButtonCover];
    
}

-(void)animatContextMenuDown{

    contextMenuDown = YES;
    self.hidden = NO;
    [self.animator removeAllBehaviors];
    
    
  

    UIDynamicItemBehavior *elasticityBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.contextMenuButtonFirst,self.contextMenuButtonSecond,self.contextMenuButtonThird]];
    elasticityBehavior.elasticity = 0.2f;
    
    UISnapBehavior *buttonSnapFirst = [[UISnapBehavior alloc] initWithItem:self.contextMenuButtonFirst snapToPoint:CGPointMake(self.contextMenuButtonCover.center.x , self.contextMenuButtonCover.center.y+60)];
    buttonSnapFirst.damping = 0.9f;
    
    
    UISnapBehavior *buttonSnapSecond = [[UISnapBehavior alloc] initWithItem:self.contextMenuButtonSecond snapToPoint:CGPointMake(self.contextMenuButtonCover.center.x , self.contextMenuButtonCover.center.y+120)];
    buttonSnapSecond.damping = 0.9f;
    
    UISnapBehavior *buttonSnapThird = [[UISnapBehavior alloc] initWithItem:self.contextMenuButtonThird snapToPoint:CGPointMake(self.contextMenuButtonCover.center.x , self.contextMenuButtonCover.center.y+180)];
    buttonSnapThird.damping = 0.9f;
    
    self.contextMenuLableForButtonThird.text= @"Past";
    self.contextMenuLableForButtonSecond.text= @"Sent";
    self.contextMenuLableForButtonFirst.text= @"Upcoming";



    [self.animator addBehavior:buttonSnapFirst];
    [self.animator addBehavior:buttonSnapSecond];
    [self.animator addBehavior:buttonSnapThird];
    [self.animator addBehavior:elasticityBehavior];
    
   
    
}

-(void)animatContextMenuUp{
    

    contextMenuDown = NO;
    [self.animator removeAllBehaviors];

    
    UIDynamicItemBehavior *elasticityBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.contextMenuButtonFirst,self.contextMenuButtonSecond,self.contextMenuButtonThird]];
    elasticityBehavior.elasticity = 0.2f;
    
    UISnapBehavior *firstButtonSnap = [[UISnapBehavior alloc] initWithItem:self.contextMenuButtonFirst snapToPoint:CGPointMake(self.contextMenuButtonCover.center.x , self.contextMenuButtonCover.center.y)];
    firstButtonSnap.damping = 0.9f;
    UISnapBehavior *secondButtonSnap = [[UISnapBehavior alloc] initWithItem:self.contextMenuButtonSecond snapToPoint:CGPointMake(self.contextMenuButtonCover.center.x , self.contextMenuButtonCover.center.y)];
    secondButtonSnap.damping = 0.9f;
    UISnapBehavior *thirdButtonSnap = [[UISnapBehavior alloc] initWithItem:self.contextMenuButtonThird snapToPoint:CGPointMake(self.contextMenuButtonCover.center.x , self.contextMenuButtonCover.center.y)];
    thirdButtonSnap.damping = 0.9f;
    self.contextMenuLableForButtonThird.text= @"";
    self.contextMenuLableForButtonSecond.text= @"";
    self.contextMenuLableForButtonFirst.text= @"";
    
    [self.animator addBehavior:firstButtonSnap];
    [self.animator addBehavior:secondButtonSnap];
    [self.animator addBehavior:thirdButtonSnap];
    [self.animator addBehavior:elasticityBehavior];
}



-(void)contextMenuButtonCoverTapped{
    [self.JCDropDownMenuDelagte contextMenuButtonCoverClicked];
}

-(void)contextMenuButtonThirdTapped{
    [self.JCDropDownMenuDelagte contextMenuButtonThirdClicked];
}

-(void)contextMenuButtonSecondTapped{
    [self.JCDropDownMenuDelagte contextMenuButtonSecondClicked];
}
-(void)contextMenuButtonFirstTapped{
    [self.JCDropDownMenuDelagte contextMenuButtonFirstClicked];
}

@end
