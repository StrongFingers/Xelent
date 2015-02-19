//
//  UIColor+BBSColor.m
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 2/2/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "UIColor+BBSColor.h"

@implementation UIColor (BBSColor)

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

@end
