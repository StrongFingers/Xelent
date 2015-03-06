//
//  BBSHistoryItem.h
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 3/5/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBSHistoryItem : NSObject

@property (nonatomic, strong) NSString *createDate;
@property (nonatomic, strong) NSString *summaryPrice;
@property (nonatomic, strong) NSString *saleValue;
@property (nonatomic, strong) NSArray *offers;

@end
