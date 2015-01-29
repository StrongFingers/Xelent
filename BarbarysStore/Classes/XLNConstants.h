//
//  XLNConstants.h
//
//  Created by Dmitry Kozlov on 3/20/14.
//  Copyright (c) 2014 Xelentec. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AppDel (TWTAppDelegate *)[[UIApplication sharedApplication] delegate]

#define USER [NSUserDefaults standardUserDefaults]

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IOS7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0

#define DEVICE_MODEL [[UIDevice currentDevice] platformString]
#define DEVICE_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define APP_BUILD [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey]

#define NOT_NULL(var) [var isEqual:[NSNull null]] || var == nil ? @"" : var

// DLog will output like NSLog only when the DEBUG variable is set
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif 

#define LOC(key) NSLocalizedString((key), @"")

static const NSString *serverXMLUrl = @"http://barbarys.com/aggregator/aggregatorall/yml.xml";
