//
//  UIScrollView+SYRefresh.h
//  SYRefreshDemo
//
//  Created by lz on 16/3/15.
//  Copyright © 2016年 SY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYWaitView.h"

@interface UIScrollView (SYRefresh)<UIScrollViewDelegate>

@property (weak, nonatomic) SYWaitView *waitView;

- (void)addRefreshAction:(void(^)(void)) actionHandler;
@end
