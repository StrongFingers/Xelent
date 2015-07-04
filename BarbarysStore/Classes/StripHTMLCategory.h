//
//  StripHTMLCategory.h
//  BarbarysStore
//
//  Created by Владислав Сидоренко on 7/4/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (StripHTMLCategory)
-(NSString *) stringByStrippingHTML:(NSString *)stringWithHTML;
@end
