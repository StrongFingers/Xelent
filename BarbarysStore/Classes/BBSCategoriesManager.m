//
//  BBSCategoryManager.m
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 2/10/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "BBSCategoriesManager.h"


@implementation BBSCategoriesManager

+ (NSArray *)loadCategories {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"categories" ofType:@"plist" inDirectory:nil];
    NSAssert(path, @"not found categories");
    NSDictionary *plist = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray * list = [plist objectForKey:@"items"];
    NSMutableArray * ar = [NSMutableArray arrayWithCapacity:plist.count];
    for (NSDictionary * dic in list) {
        BBSCategorySet *categorySet = [[BBSCategorySet alloc] init];
        categorySet.name = dic[@"name"];
        NSArray *tmpCategories = dic[@"subcategories"];
        NSMutableArray *categories = [[NSMutableArray alloc] init];
        for (NSDictionary *item in tmpCategories) {
            BBSCategorySet *category = [[BBSCategorySet alloc] init];
            category.categoryId = item[@"id"];
            category.name = item[@"name"];
            NSArray *tmpSubcategories = item[@"subcategories"];
            NSMutableArray *subcategories = [[NSMutableArray alloc] init];
            for (NSDictionary *subItem in tmpSubcategories) {
                BBSCategory *subcategory = [[BBSCategory alloc] init];
                subcategory.categoryId = subItem[@"id"];
                subcategory.name = subItem[@"name"];
                [subcategories addObject:subcategory];
            }
            category.subcategories = subcategories;
            [categories addObject:category];
        }
        categorySet.subcategories = categories;
        [ar addObject:categorySet];
    }
    return ar;
}

@end
