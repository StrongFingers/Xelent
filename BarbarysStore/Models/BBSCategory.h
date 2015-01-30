//
//  Category.h
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 1/29/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBSCategory : NSObject

@property (nonatomic, strong) NSString *categoryId;
@property (nonatomic, strong) NSString *parentId;
@property (nonatomic, strong) NSString *name;

@end
