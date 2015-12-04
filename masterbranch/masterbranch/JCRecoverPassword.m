//
//  JCRecoverPassword.m
//  PreAmp
//
//  Created by james cash on 03/12/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "JCRecoverPassword.h"
#import <Parse/Parse.h>
#import "JCToastAndAlertView.h"

@interface JCRecoverPassword ()
@property (weak, nonatomic) IBOutlet UIImageView *UIImageBG;

@property (weak, nonatomic) IBOutlet UITextField *UITextFieldEmailAddress;
@property (nonatomic,strong)JCToastAndAlertView *alert;
@end

@implementation JCRecoverPassword
- (IBAction)dissmiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.UIImageBG.image = [UIImage imageNamed:@"backgroundLogin"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)recoverPassword:(id)sender {
    
    
    NSString *userEmail = self.UITextFieldEmailAddress.text;
    
    BOOL isValidEmail = [self NSStringIsValidEmail:userEmail];
    
    if (isValidEmail) {
        [PFUser requestPasswordResetForEmailInBackground:userEmail block:^(BOOL succeeded, NSError * _Nullable error) {
            
            if (error) {
                NSLog(@"error %@",error);
            }else{
                
                self.alert = [[JCToastAndAlertView alloc]init];
                NSString *message = [NSString stringWithFormat:@"Password reset link sent to %@",userEmail];
                [self.alert showUserUpDateToastWithMessage:message];
            }
        }];
    }else{
        
        NSLog(@"enter a valid email address");
        
    }
    
    
    
    
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
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
