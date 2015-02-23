//
//  UIImage+Alpha.h
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 2/9/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Alpha)

+ (UIImage *)imageWithColor:(UIColor *)color;
- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha;

@end
