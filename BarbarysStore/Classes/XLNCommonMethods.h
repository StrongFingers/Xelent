//
//  XLNCommonMethods.h
//  BarbarysStore
//
//  Created by Владислав Сидоренко on 8/26/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLNCommonMethods : NSObject

+ (CGSize)findHeightForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font;
+ (CGSize)findHeightForMutableAttributedText:(NSAttributedString *)text havingWidth:(CGFloat)widthValue;
+ (NSAttributedString *)convertToBoldedString:(NSString *)notBoldString fontSize:(float)sizeFont;
@end
