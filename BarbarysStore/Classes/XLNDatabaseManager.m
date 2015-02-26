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
        //self.path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"db.sqlite"];
        //self.path = [[NSBundle mainBundle] pathForResource:@"db" ofType:@"sqlite"]; // [tmpPath stringByAppendingPathComponent:@"db.sqlite"];
        self.path = [tmpPath stringByAppendingPathComponent:@"db.sqlite"];
        self.db = [FMDatabase databaseWithPath:self.path];
    }
    return self;
}

- (void)createDB {
    if ([[NSFileManager defaultManager] fileExistsAtPath:self.path isDirectory:nil]) {
        //[[NSFileManager defaultManager] removeItemAtPath:self.path error:nil];
        return;
    }
    if (![self.db open]) {
        return;
    }
    [self.db executeUpdate:@"create table favorites(offerId text primary key UNIQUE, description text, categoryId text, url text, thumbnailUrl text, price text, currency text, vendor text, model text, color text, gender text, material text)"];
    [self.db executeUpdate:@"create table categories(categoryId text, name text, parentId text)"];
    [self.db executeUpdate:@"create table categoriesOffers(offerId text, categoryId text)"];
    [self.db executeUpdate:@"create table pictures(offerId text, pictureUrl text)"];
}

- (void)addOffers:(NSArray *)offers {
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.path];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (BBSOffer *offer in offers) {
            [db executeUpdate:@"insert into favorites (offerId, description, url, thumbnailUrl, categoryId, price, currency, vendor, model, color, gender, material) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", offer.offerId, offer.descriptionText, offer.url, offer.thumbnailUrl, offer.categoryId, offer.price, offer.currency, offer.vendor, offer.model, offer.color, offer.gender, offer.material];
            [db executeUpdate:@"insert into categoriesOffers (offerId, categoryId) values (?, ?)", offer.offerId, offer.categoryId];
            if (offer.pictures) {
                for (NSString *pictureUrl in offer.pictures) {
                    [db executeUpdate:@"insert into pictures (offerId, pictureUrl) values (?, ?)", offer.offerId, pictureUrl];
                }
            }
        }
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[UIAlertView alloc] initWithTitle:nil message:@"Parsing complete" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    });
    DLog(@"done 2");
    FMResultSet *s = [self.db executeQuery:@"select count(*) from favorites"];
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
    NSMutableArray *offers = [[NSMutableArray alloc] init];
    NSString *query = [NSString stringWithFormat:@"select * from offers where categoryId = %@", categoryId];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.path];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *s = [self.db executeQuery:query];
        while ([s next]) {
            __block BBSOffer *offer = [[BBSOffer alloc] init];
            offer.offerId = [s stringForColumnIndex:0];
            offer.descriptionText = [s stringForColumnIndex:1];
            offer.url = [s stringForColumnIndex:3];
            offer.thumbnailUrl = [s stringForColumnIndex:4];
            offer.price = [s stringForColumnIndex:5];
            offer.vendor = [s stringForColumnIndex:7];
            offer.model = [s stringForColumnIndex:8];
            offer.color = [s stringForColumnIndex:9];
            offer.gender = [s stringForColumnIndex:10];
            offer.material = [s stringForColumnIndex:11];
            offer.pictures = [self getPicturesForOfferId:offer.offerId];
            [offers addObject:offer];
        }
    }];
    return offers;
}

- (NSArray *)getPicturesForOfferId:(NSString *)offerId {
    if (!self.db.open) {
        [self.db open];
    }
    NSMutableArray *pictures = [NSMutableArray array];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.path];
    [queue inDatabase:^(FMDatabase *db) {
    NSString *query = [NSString stringWithFormat:@"select * from pictures where offerId = %@", offerId];
        FMResultSet *s = [self.db executeQuery:query];
        while ([s next]) {
            NSString *url = [s stringForColumnIndex:1];
            [pictures addObject:url];
        }
    }];
    return pictures;
}

- (void)addToFavorites:(BBSOffer *)offer {
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.path];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:@"insert into favorites (offerId, description, url, thumbnailUrl, categoryId, price, currency, vendor, model, color, gender, material) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", offer.offerId, offer.descriptionText, offer.url, offer.thumbnailUrl, offer.categoryId, offer.price, offer.currency, offer.vendor, offer.model, offer.color, offer.gender, offer.material];
        if (offer.pictures) {
            for (NSString *pictureUrl in offer.pictures) {
                [db executeUpdate:@"insert into pictures (offerId, pictureUrl) values (?, ?)", offer.offerId, pictureUrl];
            }
        }
    }];
}

- (void)removeFromFavorites:(BBSOffer *)offer {
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.path];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        if (offer.pictures) {
            [db executeUpdate:[NSString stringWithFormat:@"delete from pictures where offerId = %@", offer.offerId]];
        }
        [db executeUpdate:[NSString stringWithFormat:@"delete from favorites where offerId = %@", offer.offerId]];
    }];
}

- (NSArray *)getFavorites {
    if (!self.db.open) {
        [self.db open];
    }
    NSMutableArray *offers = [[NSMutableArray alloc] init];
    NSString *query = [NSString stringWithFormat:@"select * from favorites"];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.path];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *s = [self.db executeQuery:query];
        while ([s next]) {
            __block BBSOffer *offer = [[BBSOffer alloc] init];
            offer.offerId = [s stringForColumnIndex:0];
            offer.descriptionText = [s stringForColumnIndex:1];
            offer.url = [s stringForColumnIndex:3];
            offer.thumbnailUrl = [s stringForColumnIndex:4];
            offer.price = [s stringForColumnIndex:5];
            offer.vendor = [s stringForColumnIndex:7];
            offer.model = [s stringForColumnIndex:8];
            offer.color = [s stringForColumnIndex:9];
            offer.gender = [s stringForColumnIndex:10];
            offer.material = [s stringForColumnIndex:11];
            offer.pictures = [self getPicturesForOfferId:offer.offerId];
            [offers addObject:offer];
        }
    }];
    return offers;
}

- (void)addToShoppingCart:(BBSCartOffer *)offer {

}

- (NSInteger)countOfRows:(BBSOffer *)offer {
    if (!self.db.open) {
        [self.db open];
    }
    __block NSInteger count = 0;
    NSString *query = [NSString stringWithFormat:@"select count(*) from favorites where offerId = %@", offer.offerId];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.path];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *s = [self.db executeQuery:query];
        while ([s next]) {
            count = [s intForColumnIndex:0];
        }
    }];
    return count;
}

@end
