//
//  JCTerm&ConditionsVC.h
//  PreAmp
//
//  Created by james cash on 03/12/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCTerm_ConditionsVC : UIViewController
@property (nonatomic,strong)NSString *webviewAddress;
-(void)LoadWebViewWithaddress:(NSString*)webAddress;
@property (nonatomic,strong)NSString *url;
@end
