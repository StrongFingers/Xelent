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

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *tmpPath = NSTemporaryDirectory();
        self.path = [tmpPath stringByAppendingPathComponent:@"db.sqlite"];
        self.db = [FMDatabase databaseWithPath:self.path];
    }
    return self;
}

- (void)createDB {
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.path isDirectory:nil]) {
        [[NSFileManager defaultManager] removeItemAtPath:self.path error:nil];
    }
    if (![self.db open]) {
        return;
    }
    [self.db executeUpdate:@"create table offers(offerId text primary key, description text, categoryId text, url text, price text, currency text, vendor text, model text, color text, gender text, material text)"];
    [self.db executeUpdate:@"create table categories(categoryId text, name text, parentId text)"];
    [self.db executeUpdate:@"create table categoriesOffers(offerId text, categoryId text)"];
    [self.db executeUpdate:@"create table pictures(offerId text, pictureUrl text)"];
}

- (void)addOffers:(NSArray *)offers {
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.path];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (BBSOffer *offer in offers) {
            [db executeUpdate:@"insert into offers (offerId, description, url, categoryId, price, currency, vendor, model, color, gender, material) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", offer.offerId, offer.descriptionText, offer.url, offer.categoryId, offer.price, offer.currency, offer.vendor, offer.model, offer.color, offer.gender, offer.material];
            [db executeUpdate:@"insert into categoriesOffers (offerId, categoryId) values (?, ?)", offer.offerId, offer.categoryId];
            if (offer.pictures) {
                for (NSString *pictureUrl in offer.pictures) {
                    [db executeUpdate:@"insert into pictures (offerId, pictureUrl) values (?, ?)", offer.offerId, pictureUrl];
                }
            }
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

- (NSArray *)getAllCategories {
    if (!self.db.open) {
        [self.db open];
    }
    FMResultSet *s = [self.db executeQuery:@"select * from categories"];
    NSMutableArray *categories = [[NSMutableArray alloc] init];
    while ([s next]) {
        NSString *categoryId = [s stringForColumnIndex:0];
        NSString *categoryName = [s stringForColumnIndex:1];
        [categories addObject:@{@"id" : categoryId, @"name" : categoryName}];
    }
    return categories;
}

- (NSArray *)getOffersByCategoryId:(NSString *)categoryId {
    if (!self.db.open) {
        [self.db open];
    }
    NSString *query = [NSString stringWithFormat:@"select * from offers where categoryId = %@", categoryId];
    FMResultSet *s = [self.db executeQuery:query];
    NSMutableArray *offers = [[NSMutableArray alloc] init];
    while ([s next]) {
        BBSOffer *offer = [[BBSOffer alloc] init];
        offer.offerId = [s stringForColumnIndex:0];
        offer.descriptionText = [s stringForColumnIndex:1];
        offer.url = [s stringForColumnIndex:3];
        offer.price = [s stringForColumnIndex:4];
        offer.vendor = [s stringForColumnIndex:6];
        offer.model = [s stringForColumnIndex:7];
        offer.color = [s stringForColumnIndex:8];
        offer.gender = [s stringForColumnIndex:9];
        offer.material = [s stringForColumnIndex:10];
        offer.pictures = [self getPicturesForOfferId:offer.offerId];
        [offers addObject:offer];
    }
    return offers;
}

- (NSArray *)getPicturesForOfferId:(NSString *)offerId {
    if (!self.db.open) {
        [self.db open];
    }
    NSString *query = [NSString stringWithFormat:@"select * from pictures where offerId = %@", offerId];
    FMResultSet *s = [self.db executeQuery:query];
    NSMutableArray *pictures = [[NSMutableArray alloc] init];
    while ([s next]) {
        NSString *url = [s stringForColumnIndex:1];
        [pictures addObject:url];
    }
    return pictures;
}

@end
