//
//  XLNLocalNotifications.m
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 2/9/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "XLNLocalNotifications.h"

@implementation XLNLocalNotifications

- (void)addNotificationIfBucketNotEmpty {
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    notification.repeatInterval = NSDayCalendarUnit;
    [notification setAlertBody:@"You have offers in bucket"];
    [notification setFireDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    [notification setTimeZone:[NSTimeZone defaultTimeZone]];
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (void)addNotificationForNewItems {
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    notification.repeatInterval = NSDayCalendarUnit;
    [notification setAlertBody:@"You have offers in bucket"];
    [notification setFireDate:[NSDate dateWithTimeIntervalSinceNow:31]];
    [notification setTimeZone:[NSTimeZone defaultTimeZone]];
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

- (void)addNotificationForReview {
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    notification.repeatInterval = NSDayCalendarUnit;
    [notification setAlertBody:@"You have offers in bucket"];
    [notification setFireDate:[NSDate dateWithTimeIntervalSinceNow:14]];
    [notification setTimeZone:[NSTimeZone defaultTimeZone]];
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

@end
