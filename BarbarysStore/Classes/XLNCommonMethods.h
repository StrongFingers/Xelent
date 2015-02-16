//
//  XLNCommonMethods.h
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 2/16/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLNCommonMethods : NSObject

+ (CGSize)findHeightForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font;

@end
