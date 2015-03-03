//
//  BBSAPIRequest.h
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 2/25/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BBSAPIRequestDelegate <NSObject>

@required
- (void)requestFinished:(id)responseObject sender:(id)sender;
- (void)requestFinishedWithError:(NSError *)error;
@optional
- (void)requestFinishedWithErrorAndMessage:(NSError *)error errorMessage:(NSString *)errorMessage;

@end

@interface BBSAPIRequest : NSObject

@property (nonatomic, strong) id<BBSAPIRequestDelegate> delegate;

- (id)initWithDelegate:(id<BBSAPIRequestDelegate>)delegate;
- (void)getCategoryOffers:(NSString *)categoryId gender:(NSString *)gender page:(NSInteger)page;
- (void)getOfferById:(NSString *)offerId;

@end
