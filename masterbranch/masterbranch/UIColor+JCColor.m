//
//  UIColor+JCColor.m
//  PreAmp
//
//  Created by james cash on 08/12/2015.
//  Copyright © 2015 com.james.www. All rights reserved.
//

#import "UIColor+JCColor.h"

@implementation UIColor (JCColor)

+ (UIColor *)JCPink {
    return [self colorFromHexString:@"#FF0081"];

}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1];
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

@end
