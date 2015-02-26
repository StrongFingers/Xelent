//
//  UIColor+BBSColor.h
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 2/2/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (BBSColor)

+ (UIColor *)mainDarkColor;
+ (UIColor *)additionalColor;
+ (UIColor *)priceColor;
+ (UIColor *)sideMenuBackground;
+ (UIColor *)sideMenuSubBackground;
+ (UIColor *)sideMenuExpandedHeaderTitle;
+ (UIColor *)sideMenuCategorySeparator;
+ (UIColor *)sideMenuSubcategorySeparator;
+ (UIColor *)colorFromHexString:(NSString *)hexString;
+ (UIColor *)customDarkGrayColor;
+ (UIColor *)detailCellBackgroundColor;

@end
