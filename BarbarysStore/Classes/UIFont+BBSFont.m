//
//  UIFont+BBSFont.m
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 2/25/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "UIFont+BBSFont.h"

@implementation UIFont (BBSFont)

+ (UIFont *)mediumFont:(CGFloat)size {
    return [UIFont fontWithName:@"HelveticaNeue-Medium" size:size];
}

+ (UIFont *)lightFont:(CGFloat)size {
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:size];
}

@end
