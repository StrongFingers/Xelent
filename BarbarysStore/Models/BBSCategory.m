//
//  Category.m
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 1/29/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "BBSCategory.h"

@implementation BBSCategory

- (instancetype)init {
    if (self = [super init]) {
        self.categoryId = @"";
        self.parentId = @"";
        self.name = @"";
    }
    return self;
}

@end
