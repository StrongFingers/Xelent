//
//  BBSSideMenuCell.h
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 2/2/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBSCategory.h"
@interface BBSSideMenuCell : UITableViewCell


- (void)setCategory:(BBSCategory *)categoryInfo;
- (NSString *)categoryId;

@end
