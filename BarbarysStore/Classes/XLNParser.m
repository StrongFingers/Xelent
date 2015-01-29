//
//  XLNParser.m
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 1/29/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "XLNParser.h"
#import <TBXML.h>
#import <TBXML+HTTP.h>

@interface XLNParser ()

@property (nonatomic, strong) TBXML *parser;

@end

@implementation XLNParser

- (void)ininWithURL:(NSURL *)url {
    self.parser = [TBXML tbxmlWithURL:url success:^(TBXML *tbxmlDocument) {

    } failure:^(TBXML *tbxmlDocument, NSError *error) {
        
    }];
}
@end
