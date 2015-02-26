//
//  UIColor+BBSColor.m
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 2/2/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "UIColor+BBSColor.h"

@implementation UIColor (BBSColor)

+ (UIColor *)mainDarkColor {
    return [UIColor colorWithRed:0.14 green:0.37 blue:0.51 alpha:1];
}

+ (UIColor *)additionalColor {
    return [UIColor colorWithRed:0.5 green:0.66 blue:0.77 alpha:1];
}

+ (UIColor *)priceColor {
    return [UIColor colorWithRed:1 green:0.32 blue:0.1 alpha:1];
}

+ (UIColor *)sideMenuBackground {
    return [UIColor colorWithRed:0.23 green:0.25 blue:0.26 alpha:1];
}

+ (UIColor *)sideMenuSubBackground {
    return [UIColor colorWithRed:0.18 green:0.18 blue:0.19 alpha:1];
}

+ (UIColor *)sideMenuExpandedHeaderTitle {
    return [UIColor colorWithRed:1 green:0.32 blue:0.1 alpha:1];
}

+ (UIColor *)sideMenuCategorySeparator {
    return [UIColor colorWithRed:0.25 green:0.27 blue:0.28 alpha:1];
}

+ (UIColor *)sideMenuSubcategorySeparator {
    return [UIColor colorWithRed:0.19 green:0.2 blue:0.2 alpha:1];
}

+ (UIColor *)customDarkGrayColor {
    return [UIColor colorWithRed:0.486 green:0.482 blue:0.482 alpha:1.000];
}

+ (UIColor *)detailCellBackgroundColor {
    return [UIColor colorWithWhite:0.976 alpha:1.000];
}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

@end
