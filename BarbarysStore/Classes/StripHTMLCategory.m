//
//  StripHTMLCategory.m
//  BarbarysStore
//
//  Created by Владислав Сидоренко on 7/4/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "StripHTMLCategory.h"

@implementation NSString (StripHTMLCategory)
-(NSString *) stringByStrippingHTML:(NSString *)stringWithHTML {
    NSMutableString *outputString;
    if (stringWithHTML) {
        outputString = [[NSMutableString alloc] initWithString:stringWithHTML];
        if (outputString.length > 0) {
            NSRange range;
            while ((range = [outputString rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound) {
                [outputString deleteCharactersInRange:range];
            };
        }
    
    
    }
    return outputString;
};
@end
