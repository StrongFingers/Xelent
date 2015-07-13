//
//  XLNCommonMethods.m
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 2/16/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "XLNCommonMethods.h"

@implementation XLNCommonMethods

+ (CGSize)findHeightForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font {
    CGSize size = CGSizeZero;
    if (text) {
        //iOS 7
        CGRect frame = [text boundingRectWithSize:CGSizeMake(widthValue, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:font } context:nil];
        size = CGSizeMake(frame.size.width, frame.size.height + 5);
    }
    return size;
}

@end
