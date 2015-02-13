//
//  BBSCategorySet.h
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 2/12/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBSCategorySet : NSObject

@property (nonatomic, strong) NSString *categoryId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *subcategories;

@end
