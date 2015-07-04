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
//init and open DB from path
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
        //[[NSFileManager defaultManager] removeItemAtPath:self.path error:nil];
        return;
    }
    if (![self.db open]) {
        return;
    }
    [self.db executeUpdate:@"create table favorites(offerId text, description text, categoryId text, url text, thumbnailUrl text, price text, currency text, vendor text, model text, color text, gender text, material text, colors blob, sizes blob, pictures blob)"];
    [self.db executeUpdate:@"create table shoppingCart(offerId text primary key, description text, categoryId text, url text, thumbnailUrl text, price text, currency text, vendor text, model text, color text, gender text, material text, size text, choosedColor text, quantity text, colors blob, sizes blod, pictures blob)"];
    [self.db executeUpdate:@"create table history (id integer primary key, date text, summaryPrice text, saleValue text, offers blob)"];
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
            offer.brand = [s stringForColumnIndex:7];
            offer.model = [s stringForColumnIndex:8];
            offer.color = [s stringForColumnIndex:9];
            offer.gender = [s stringForColumnIndex:10];
            offer.material = [s stringForColumnIndex:11];
            //offer.pictures = [self getPicturesForOfferId:offer.offerId];
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
        [db executeUpdate:@"replace into favorites (offerId, description, url, thumbnailUrl, categoryId, price, currency, vendor, model, color, gender, material, colors, sizes, pictures) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", offer.offerId, offer.descriptionText, offer.url, offer.thumbnailUrl, offer.categoryId, offer.price, offer.currency, offer.brand, offer.model, offer.color, offer.gender, offer.material, [NSKeyedArchiver archivedDataWithRootObject:offer.colorsType], [NSKeyedArchiver archivedDataWithRootObject:offer.sizesType], [NSKeyedArchiver archivedDataWithRootObject:offer.pictures]];
    }];
}

- (void)removeFromFavorites:(BBSOffer *)offer {
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.path];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:[NSString stringWithFormat:@"delete from favorites where offerId = %@ and color = %@", offer.offerId, offer.color]];
    }];
}

- (void)updateFavorite:(BBSOffer *)offer {
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.path];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:@"update favorites set offerId=?, description=?, colors=?, sizes=?, pictures=? where offerId=? and color=?", offer.offerId, offer.descriptionText, [NSKeyedArchiver archivedDataWithRootObject:offer.colorsType], [NSKeyedArchiver archivedDataWithRootObject:offer.sizesType], [NSKeyedArchiver archivedDataWithRootObject:offer.pictures], offer.offerId, offer.color];
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
            offer.brand = [s stringForColumnIndex:7];
            offer.model = [s stringForColumnIndex:8];
            offer.color = [s stringForColumnIndex:9];
            offer.gender = [s stringForColumnIndex:10];
            offer.material = [s stringForColumnIndex:11];
            offer.colorsType = [NSKeyedUnarchiver unarchiveObjectWithData:[s dataForColumnIndex:12]];
            offer.sizesType = [NSKeyedUnarchiver unarchiveObjectWithData:[s dataForColumnIndex:13]];
            offer.pictures = [NSKeyedUnarchiver unarchiveObjectWithData:[s dataForColumnIndex:14]];
            [offers addObject:offer];
        }
    }];
    return offers;
}

- (void)addToShoppingCart:(BBSCartOffer *)offer {
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.path];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:@"insert into shoppingCart (offerId, description, url, thumbnailUrl, categoryId, price, currency, vendor, model, color, gender, material, size, choosedColor, quantity, colors, sizes, pictures) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", offer.offerId, offer.descriptionText, offer.url, offer.thumbnailUrl, offer.categoryId, offer.price, offer.currency, offer.brand, offer.model, offer.color, offer.gender, offer.material, offer.size, offer.choosedColor, offer.quantity, [NSKeyedArchiver archivedDataWithRootObject:offer.colorsType], [NSKeyedArchiver archivedDataWithRootObject:offer.sizesType], [NSKeyedArchiver archivedDataWithRootObject:offer.pictures]];
    }];
}

- (void)removeFromShoppingCart:(BBSCartOffer *)offer {
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.path];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:[NSString stringWithFormat:@"delete from shoppingCart where offerId = %@ and color = %@", offer.offerId, offer.color]];
    }];
}

- (NSArray *)getShoppingCart {
    if (!self.db.open) {
        [self.db open];
    }
    NSMutableArray *offers = [[NSMutableArray alloc] init];
    NSString *query = [NSString stringWithFormat:@"select * from shoppingCart"];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.path];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *s = [self.db executeQuery:query];
        while ([s next]) {
            __block BBSCartOffer *offer = [[BBSCartOffer alloc] init];
            offer.offerId = [s stringForColumnIndex:0];
            offer.descriptionText = [s stringForColumnIndex:1];
            offer.url = [s stringForColumnIndex:3];
            offer.thumbnailUrl = [s stringForColumnIndex:4];
            offer.price = [s stringForColumnIndex:5];
            offer.brand = [s stringForColumnIndex:7];
            offer.model = [s stringForColumnIndex:8];
            offer.color = [s stringForColumnIndex:9];
            offer.gender = [s stringForColumnIndex:10];
            offer.material = [s stringForColumnIndex:11];
            offer.size = [s stringForColumnIndex:12];
            offer.choosedColor = [s stringForColumnIndex:13];
            offer.quantity = [s stringForColumnIndex:14];
            offer.colorsType = [NSKeyedUnarchiver unarchiveObjectWithData:[s dataForColumnIndex:15]];
            offer.sizesType = [NSKeyedUnarchiver unarchiveObjectWithData:[s dataForColumnIndex:16]];
            offer.pictures = [NSKeyedUnarchiver unarchiveObjectWithData:[s dataForColumnIndex:17]];
            [offers addObject:offer];
        }
    }];
    return offers;
}


- (NSInteger)countOfRows:(BBSOffer *)offer {
    if (!self.db.open) {
        [self.db open];
    }
    __block NSInteger count = 0;
    NSString *query = [NSString stringWithFormat:@"select count(*) from favorites where offerId = %@ and color = %@", offer.offerId, offer.color];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.path];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *s = [self.db executeQuery:query];
        while ([s next]) {
            count = [s intForColumnIndex:0];
        }
    }];
    return count;
}

- (BBSCartOffer *)cartOfferById:(NSString *)offerId {
    if (!self.db.open) {
        [self.db open];
    }
    __block BBSCartOffer *offer = [[BBSCartOffer alloc] init];
    NSString *query = [NSString stringWithFormat:@"select * from shoppingCart where offerId = %@", offerId];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.path];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *s = [self.db executeQuery:query];
        while ([s next]) {
            offer.offerId = [s stringForColumnIndex:0];
            offer.descriptionText = [s stringForColumnIndex:1];
            offer.url = [s stringForColumnIndex:3];
            offer.thumbnailUrl = [s stringForColumnIndex:4];
            offer.price = [s stringForColumnIndex:5];
            offer.brand = [s stringForColumnIndex:7];
            //changed
            offer.sv_brandDescription = [s stringForColumnIndex:6];
            offer.model = [s stringForColumnIndex:8];
            offer.color = [s stringForColumnIndex:9];
            offer.gender = [s stringForColumnIndex:10];
            offer.material = [s stringForColumnIndex:11];
            offer.size = [s stringForColumnIndex:12];
            offer.choosedColor = [s stringForColumnIndex:13];
            offer.quantity = [s stringForColumnIndex:14];
            offer.colorsType = [NSKeyedUnarchiver unarchiveObjectWithData:[s dataForColumnIndex:15]];
            offer.sizesType = [NSKeyedUnarchiver unarchiveObjectWithData:[s dataForColumnIndex:16]];
            offer.pictures = [NSKeyedUnarchiver unarchiveObjectWithData:[s dataForColumnIndex:17]];
        }
    }];
    return offer;
}

- (void)addToHistory:(BBSHistoryItem *)historyItem {
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.path];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:@"insert into history (date, summaryPrice, saleValue, offers) values (?, ?, ?, ?)", historyItem.createDate, historyItem.summaryPrice, historyItem.saleValue, [NSKeyedArchiver archivedDataWithRootObject:historyItem.offers]];
    }];
}

- (NSArray *)loadFromHistory {
    if (!self.db.open) {
        [self.db open];
    }
    NSMutableArray *offers = [[NSMutableArray alloc] init];
    NSString *query = [NSString stringWithFormat:@"select * from history"];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.path];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *s = [self.db executeQuery:query];
        while ([s next]) {
            __block BBSHistoryItem *offer = [[BBSHistoryItem alloc] init];
            offer.createDate = [s stringForColumnIndex:1];
            offer.summaryPrice = [s stringForColumnIndex:2];
            offer.saleValue = [s stringForColumnIndex:3];
            offer.offers = [NSKeyedUnarchiver unarchiveObjectWithData:[s dataForColumnIndex:4]];
            [offers addObject:offer];
        }
    }];
    return offers;
}

@end
