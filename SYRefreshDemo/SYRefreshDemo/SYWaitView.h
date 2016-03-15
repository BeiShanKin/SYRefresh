//
//  SYWaitView.h
//  CADisplayLinkDemo
//
//  Created by lz on 16/3/14.
//  Copyright © 2016年 glow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYWaitView : UIView
@property (strong, nonatomic) void(^refreshAction)(void);
@property (assign, nonatomic, getter=isAnimationing) BOOL animationing;
@property (assign, nonatomic, getter=isObserving) BOOL observing;
- (void)startAnimation;
- (void)stopAnimation;
@end
