//
//  XLNLocalNotifications.h
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 2/9/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XLNLocalNotifications : NSObject

- (void)addNotificationIfBucketNotEmpty;
- (void)addNotificationForNewItems;
- (void)addNotificationForReview;

@end
