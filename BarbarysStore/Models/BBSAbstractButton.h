//
//  BBSAbstractButton.h
//  BarbarysStore
//
//  Created by Dmitry Kozlov on 2/12/15.
//  Copyright (c) 2015 Xelentec. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AbstractButton

- (void)setTouchUpTarget:(id)target selector:(SEL)selector;

@end

@interface BBSAbstractButtonImpl : UIView <AbstractButton> {
    id target;
    SEL selector;
}

@end
