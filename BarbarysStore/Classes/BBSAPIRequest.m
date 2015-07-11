//
//  BBSAPIRequest.m
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 2/25/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "BBSAPIRequest.h"
#import <AFNetworking.h>




@implementation BBSAPIRequest


- (id)initWithDelegate:(id<BBSAPIRequestDelegate>)delegate {
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

#pragma mark - Connection methods

- (void)requestFinished:(id)responseObject {
    if ([self.delegate respondsToSelector:@selector(requestFinished:sender:)]) {
        [self.delegate requestFinished:responseObject sender:self];
    }
}

- (void)requestFinishedWithError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(requestFinishedWithError:)]) {
        [self.delegate requestFinishedWithError:error];
    }
}

- (void)requestFinishedWithErrorAndMessage:(NSError *)error errorMessage:(NSString *)errorMessage {
    if ([self.delegate respondsToSelector:@selector(requestFinishedWithErrorAndMessage:errorMessage:)]) {
        [self.delegate requestFinishedWithErrorAndMessage:error errorMessage:errorMessage];
    }
}

#pragma mark - Main connection methods


- (void)requestGET:(NSString *)url {
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:LOC(@"alertView.error.title") message:LOC(@"alertView.connectionError.title") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        return;
        
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self requestFinished:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self requestFinishedWithError:error];
        
    }];
}

- (void)requestDELETE:(NSString *)url {
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:LOC(@"alertView.error.title") message:LOC(@"alertView.connectionError.title") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
    [manager DELETE:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self requestFinished:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self requestFinishedWithError:error];
    }];
}

- (void)requestPOST:(NSString *)url data:(NSDictionary *)parameters {
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:LOC(@"alertView.error.title") message:LOC(@"alertView.connectionError.title") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self requestFinished:responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self requestFinishedWithError:error];
        [self requestFinishedWithErrorAndMessage:error errorMessage:[operation responseObject][@"error_text"]];
    }];
}

- (void)requestPUT:(NSString *)url data:(NSDictionary *)parameters {
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:LOC(@"alertView.error.title") message:LOC(@"alertView.connectionError.title") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager PUT:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self requestFinished:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self requestFinishedWithError:error];
    }];
}

#pragma mark - Methods

- (void)getCategoryOffers:(NSString *)categoryId gender:(NSString *)gender page:(NSInteger)page {
    NSMutableString *url = [NSMutableString stringWithFormat:serverUrl, @"get/category/"];
    [url appendFormat:@"%@", categoryId];
    [url appendFormat:@"?product_type=%@", gender];
    [url appendFormat:@"&api_key=%@", serverAPIKey];
    [url appendFormat:@"&page=%ld", page];
    [self requestGET:url];
}

- (void)getOfferById:(NSString *)offerId {
    NSMutableString *url = [NSMutableString stringWithFormat:serverUrl, @"get/product/"];
    [url appendFormat:@"?id=%@", offerId];
    [url appendFormat:@"&api_key=%@", serverAPIKey];
    [self requestGET:url];
}

@end
