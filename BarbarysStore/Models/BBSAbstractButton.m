//
//  BBSAbstractButton.m
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 2/12/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import "BBSAbstractButton.h"

@implementation BBSAbstractButtonImpl

-(void)setTouchUpTarget:(id)_target selector:(SEL)_selector {
    target = _target;
    selector = _selector;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [target performSelector:selector withObject:self];
}

@end
