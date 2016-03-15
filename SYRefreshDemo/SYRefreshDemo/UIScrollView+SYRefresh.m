//
//  UIScrollView+SYRefresh.m
//  SYRefreshDemo
//
//  Created by lz on 16/3/15.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "UIScrollView+SYRefresh.h"
#import <objc/runtime.h>

static char WaitViewKey;

@implementation UIScrollView (SYRefresh)

- (void)setWaitView:(SYWaitView *)waitView
{
    objc_setAssociatedObject(self, &WaitViewKey, waitView, OBJC_ASSOCIATION_ASSIGN);
}

- (SYWaitView *)waitView
{
    return objc_getAssociatedObject(self, &WaitViewKey);
}

- (void)addRefreshAction:(void (^)(void))actionHandler
{
    [self setupWaitShow];
    self.waitView.refreshAction = actionHandler;
    self.delegate = self;
}

- (void)setupWaitShow
{
    SYWaitView *waitView = [[SYWaitView alloc] initWithFrame:CGRectMake((self.frame.size.width - 40) * 0.5, -50, 40, 40)];
    waitView.observing = NO;
    waitView.backgroundColor = [UIColor whiteColor];
    waitView.layer.borderWidth = 1.0f;
    waitView.layer.borderColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:0.2].CGColor;
    waitView.layer.cornerRadius = waitView.frame.size.width * 0.5;
    waitView.clipsToBounds = YES;
    self.waitView = waitView;
    [self setShowWaitObserver:YES];
    [self addSubview:waitView];
}
// 添加或者移除监听
- (void)setShowWaitObserver:(BOOL)status
{
    if (status) {
        if (!self.waitView.isObserving) {
            [self addObserver:self.waitView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
            self.waitView.observing = YES;
        }
    } else {
        if (self.waitView.isObserving) {
            [self removeObserver:self.waitView forKeyPath:@"contentOffset"];
            self.waitView.observing = NO;
        }
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    NSLog(@"我被调用了吗？");
    [self setShowWaitObserver:NO];
}

@end
