//
//  BBSCategoryManager.m
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 2/10/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "BBSCategoriesManager.h"

@implementation BBSCategoriesManager

- (void)loadCategories {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"categories" ofType:@"plist" inDirectory:nil];
    NSAssert(path, @"not found localization");
    NSDictionary *plist = [NSDictionary dictionaryWithContentsOfFile:path];
    NSArray * list = [plist objectForKey:@"items"];
    NSMutableArray * ar = [NSMutableArray arrayWithCapacity:plist.count];
    for (NSDictionary * dic in list) {
        /*SkillSet * set = [[SkillSet new] autorelease];
        set.name = [dic objectForKey:@"name"];
        set.imageName = [dic objectForKey:@"icon"];
        set.skills = [dic objectForKey:@"items"];
        set.premium = [[dic objectForKey:@"premium"] boolValue];
        [ar addObject:set];*/
    }
}

- (NSArray *)getCategories {
    return nil;
}

@end
