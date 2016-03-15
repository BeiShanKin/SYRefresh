//
//  SYTableView.m
//  SYRefreshDemo
//
//  Created by lz on 16/3/15.
//  Copyright © 2016年 SY. All rights reserved.
//

#import "SYTableView.h"
#import "UIScrollView+SYRefresh.h"

@implementation SYTableView

- (void)awakeFromNib
{
    [self addRefreshAction:^{
        for (int i = 0; i < 1000; i++) {
            NSLog(@"我是第%i号机器人",i);
        }
    }];
}

@end
