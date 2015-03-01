//
//  XLNPreferencesService.h
//
//  Created by Dmitry Kozlov on 6/16/14.
//  Copyright (c) 2014 Xelentec. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PREF [XLNPreferencesService sharedInstance]

@interface XLNPreferencesService : NSObject
+ (instancetype)sharedInstance;

- (void)addItemToFavorites:(id)offer;
- (NSArray *)getFavorites;

- (void)setProfileInfo:(NSDictionary *)profileInfo;
- (NSDictionary *)getProfileInfo;

@end
