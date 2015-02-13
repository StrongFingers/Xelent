//
//  BBSCategorySet.m
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 2/12/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "BBSCategorySet.h"

@implementation BBSCategorySet

- (instancetype)init {
    if (self = [super init]) {
        self.categoryId = @"";
        self.name = @"";
    }
    return self;
}

@end
