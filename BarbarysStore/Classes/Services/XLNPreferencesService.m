//
//  XLNPreferencesService.m
//
//  Created by Dmitry Kozlov on 6/16/14.
//  Copyright (c) 2014 Xelentec. All rights reserved.
//

#import "XLNPreferencesService.h"

#define DE [NSUserDefaults standardUserDefaults]

@implementation XLNPreferencesService

+ (instancetype)sharedInstance {
    static XLNPreferencesService *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[XLNPreferencesService alloc] init];
    });
    return instance;
}

- (void)addItemToFavorites:(id)offer {
    NSMutableArray *favorites = [NSKeyedUnarchiver unarchiveObjectWithData:[DE objectForKey:@"favorites"]];
    [favorites addObject:offer];
    [DE setObject:[NSKeyedArchiver archivedDataWithRootObject:favorites] forKey:@"favorites"];
    [DE synchronize];
}

- (NSArray *)getFavorites {
    NSArray *favorites = [NSKeyedUnarchiver unarchiveObjectWithData:[DE objectForKey:@"favorites"]];
    return favorites;
}

- (void)setProfileInfo:(NSDictionary *)profileInfo {
	[DE setObject:profileInfo forKey:@"profileInfo"];
	[DE synchronize];
}

- (NSDictionary *)getProfileInfo {
	return [DE objectForKey:@"profileInfo"];
}

@end
