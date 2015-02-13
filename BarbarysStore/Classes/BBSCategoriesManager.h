//
//  BBSCategoryManager.h
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 2/10/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BBSCategorySet.h"
#import "BBSCategory.h"

@interface BBSCategoriesManager : NSObject

+ (NSArray *)loadCategories;

@end
