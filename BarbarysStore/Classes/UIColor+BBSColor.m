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
    return [UIColor colorWithRed:0.24 green:0.26 blue:0.27 alpha:1];
}

+ (UIColor *)sideMenuSubBackground {
    return [UIColor colorWithRed:0.18 green:0.18 blue:0.19 alpha:1];
}

+ (UIColor *)sideMenuExpandedHeaderTitle {
    return [UIColor colorWithRed:1 green:0.32 blue:0.1 alpha:1];
}

+ (UIColor *)sideMenuCategorySeparator {
    return [UIColor colorWithRed:0.28 green:0.3 blue:0.31 alpha:1];
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

+ (UIColor *) colorFromHexString: (NSString *) hexString {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 1];
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
            red   = [self colorComponentFrom: colorString start: 1 length: 1];
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
            red   = [self colorComponentFrom: colorString start: 2 length: 2];
            green = [self colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self colorComponentFrom: colorString start: 6 length: 2];
            break;
        default:
            [NSException raise:@"Invalid color value" format: @"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
            break;
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

@end
