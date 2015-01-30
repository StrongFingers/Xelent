//
//  XLNDatabaseManager.m
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 1/29/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "XLNDatabaseManager.h"
#import "BBSOffer.h"
#import "BBSCategory.h"

#import <FMDB.h>
#import <sqlite3.h>

@interface XLNDatabaseManager ()
@property (nonatomic, strong) FMDatabase *db;
@property (nonatomic, strong) NSString *path;
@end

@implementation XLNDatabaseManager

- (void)createDB {
    NSString *tmpPath = NSTemporaryDirectory();
    self.path = [tmpPath stringByAppendingPathComponent:@"db.sqlite"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.path isDirectory:nil]) {
        [[NSFileManager defaultManager] removeItemAtPath:self.path error:nil];
    }
    self.db = [FMDatabase databaseWithPath:self.path];
    if (![self.db open]) {
        return;
    }
    [self.db executeUpdate:@"create table offers(offerId text primary key, description text, categoryId text, url text, price text, currency text, vendor text, model text, color text, gender text, material text)"];
    [self.db executeUpdate:@"create table categories(categoryId text, name text, parentId text)"];
    [self.db executeUpdate:@"create table categoriesOffers(offerId text, categoryId text)"];
}

- (void)addOffers:(NSArray *)offers {
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.path];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (BBSOffer *offer in offers) {
            [db executeUpdate:@"insert into offers (offerId, description, url, categoryId, price, currency, vendor, model, color, gender, material) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", offer.offerId, offer.descriptionText, offer.url, offer.categoryId, offer.price, offer.currency, offer.vendor, offer.model, offer.color, offer.gender, offer.material];
            [db executeUpdate:@"insert into categoriesOffers (offerId, categoryId) values (?, ?)", offer.offerId, offer.categoryId];
        }
    }];
    DLog(@"done 2");
    FMResultSet *s = [self.db executeQuery:@"select count(*) from offers"];
    while ([s next]) {
        DLog(@"%d", [s intForColumnIndex:0]);
        //retrieve values for each record*
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"parsingEnded" object:nil];
}

- (void)addCategories:(NSArray *)categories {
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.path];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (BBSCategory *category in categories) {
            [db executeUpdate:@"insert into categories (categoryId, name, parentId) values (?, ?, ?)", category.categoryId, category.name, category.parentId];
        }
    }];
}

@end
