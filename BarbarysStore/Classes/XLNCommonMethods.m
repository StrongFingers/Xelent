//
//  XLNCommonMethods.m
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 2/16/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "XLNCommonMethods.h"

@interface XLNCommonMethods ()

@end

@implementation XLNCommonMethods

+ (NSRange) rangeOfStringBetweenString:(NSString*)start andString:(NSString*)end in:(NSMutableString*)inputString {
    NSRange notFoundRangeExpression = NSMakeRange(0, 0);
    NSRange startLocalRange = NSMakeRange([inputString rangeOfString:start].location, [start rangeOfString:start].length);
    if (startLocalRange.location != NSNotFound) {
        NSRange targetRange = NSMakeRange(0, 0);
        targetRange.location = startLocalRange.location + startLocalRange.length;
       // targetRange.length = [inputString length] - targetRange.location;
        NSRange endLocalRange = NSMakeRange([inputString rangeOfString:end].location, [end rangeOfString:end].length);
        if (endLocalRange.location != NSNotFound) {
            targetRange.length = endLocalRange.location - targetRange.location;
            return targetRange;
        }
    }
    return notFoundRangeExpression;
}


+ (CGSize)findHeightForText:(NSString *)text havingWidth:(CGFloat)widthValue andFont:(UIFont *)font {
    CGSize size = CGSizeZero;
    if (text) {
        //iOS 7
        CGRect frame = [text boundingRectWithSize:CGSizeMake(widthValue, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:font } context:nil];
        size = CGSizeMake(frame.size.width, frame.size.height + 5);
    }
    return size;
}
+ (CGSize)findHeightForMutableAttributedText:(NSAttributedString *)text havingWidth:(CGFloat)widthValue  {
    CGSize size = CGSizeZero;
    if (text) {
        
        //iOS 7
        
        CGRect frame = [text boundingRectWithSize:CGSizeMake(widthValue, CGFLOAT_MAX) options: NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil];
        size = CGSizeMake(frame.size.width,( frame.size.height)+[text length]/30 * 8 ) ;

        
    }
    return size;
}

+ (NSAttributedString *)convertToBoldedString:(NSString *)notBoldString fontSize:(float)sizeFont{
    NSString *start = @"<b>";
    NSRange startRange = NSMakeRange(0, start.length);
    NSString *end = @"</b>";
    NSRange endRange = NSMakeRange(0, end.length);
    NSMutableAttributedString *boldString = [[NSMutableAttributedString alloc] initWithString:notBoldString];
    NSMutableString *localString = [[NSMutableString alloc] initWithString:notBoldString];
    NSRange notFoundRangeExpression = NSMakeRange(0, 0);
    
    while (!NSEqualRanges(notFoundRangeExpression, [self rangeOfStringBetweenString:start andString:end in:localString])) {
        NSRange tmpRange = [self rangeOfStringBetweenString:start andString:end in:localString];
        //calculate valid ranges
        startRange.location = tmpRange.location - 3;
        endRange.location = tmpRange.location + tmpRange.length-3;
        //delete tags <b></b> in result and local copy
        [localString replaceCharactersInRange:startRange withString:@""];
        [localString replaceCharactersInRange:endRange withString:@""];
        
        [boldString replaceCharactersInRange:startRange withString:@""];
        [boldString replaceCharactersInRange:endRange withString:@""];
        //calculate valid tmpRange
        tmpRange.location = tmpRange.location - 3;
        [boldString addAttribute:NSFontAttributeName value:[UIFont boldLightFont:sizeFont] range:tmpRange];
       
    }

     NSAttributedString *result = [[NSAttributedString alloc] initWithAttributedString:[boldString attributedSubstringFromRange:NSMakeRange(0, [boldString length])]];


        return result;
}

@end












