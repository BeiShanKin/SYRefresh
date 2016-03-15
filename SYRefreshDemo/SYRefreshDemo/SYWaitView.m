//
//  SYWaitView.m
//  CADisplayLinkDemo
//
//  Created by lz on 16/3/14.
//  Copyright © 2016年 glow. All rights reserved.
//

#import "SYWaitView.h"

@interface SYWaitView()
@property (strong, nonatomic) CADisplayLink *displayLink;
@property (assign, nonatomic) CGFloat fasterAngel;
@property (assign, nonatomic) CGFloat slowerAngel;
@property (assign, nonatomic) NSInteger colorCount;
@property (copy, nonatomic) NSArray *colorArray;
@property (assign, nonatomic, getter=isColorChange) BOOL colorChange;
@end

@implementation SYWaitView

- (void)layoutSubviews
{
    
}

- (NSArray *)colorArray
{
    if (!_colorArray) {
        _colorArray = @[[UIColor colorWithRed:120/255.0 green:146/255.0 blue:98/255.0 alpha:1],[UIColor colorWithRed:73/255.0 green:65/255.0 blue:102/255.0 alpha:1],[UIColor colorWithRed:23/255.0 green:124/255.0 blue:176/255.0f alpha:1],[UIColor colorWithRed:163/255.0 green:226/255.0 blue:197/255.0 alpha:1]];
    }
    return _colorArray;
}

- (void)startAnimation
{
    self.colorCount = 0;
    self.colorChange = YES;
    self.animationing = YES;
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(tickAngel)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stopAnimation
{
    self.animationing = NO;
    self.displayLink.paused = YES;
    [self.displayLink invalidate];
    self.displayLink = nil;
}

- (void)tickAngel
{
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect
{
    UIBezierPath *path;
    if (self.fasterAngel - self.slowerAngel >= M_PI * 1.9) {
        CGFloat tmp = self.fasterAngel;
        self.fasterAngel = self.slowerAngel;
        self.slowerAngel = tmp;
        self.colorChange = YES;
    }
    
    if ((int)self.fasterAngel == (int)self.slowerAngel && self.isColorChange) {
        self.colorCount++;
        self.colorChange = NO;
        NSLog(@"%f--我的老家，就住在这个屯--%f",self.fasterAngel,self.slowerAngel);
    }
    
    NSUInteger index = self.colorCount % self.colorArray.count;
    UIColor *color = self.colorArray[index];
    [color set];
    
    if (self.fasterAngel > self.slowerAngel) {
        path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2) radius:(rect.size.width * 0.3) startAngle:self.fasterAngel endAngle:self.slowerAngel clockwise:NO];
    } else {
        path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2) radius:(rect.size.width * 0.3) startAngle:self.slowerAngel endAngle:self.fasterAngel clockwise:NO];
    }
    self.slowerAngel += M_PI / 180 * 2;
    self.fasterAngel += M_PI / 180 * 8;
    path.lineWidth = 3.0f;
    [path stroke];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        if ([object isKindOfClass:[UITableView class]]) {
            CGPoint contentOffset = [[change valueForKey:NSKeyValueChangeNewKey] CGPointValue];
            CGFloat angel = M_PI / 18000 * -contentOffset.y;
            self.fasterAngel = self.fasterAngel + angel;
            [self tickAngel];
            NSLog(@"y--------^%f",contentOffset.y);
            if (contentOffset.y < -80 && !self.isAnimationing) {
                if (!self.isAnimationing) {
                    [self startAnimation];
                }
                NSLog(@"猜猜我被调用了几次？");
                UITableView *tableView = object;
                [UIView animateWithDuration:0.3 animations:^{
                    tableView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0);
                } completion:^(BOOL finished) {
                    NSBlockOperation *operation1 = [NSBlockOperation blockOperationWithBlock:^{
                        if (self.refreshAction) {
                            self.refreshAction();
                        }
                    }];
                    
                    NSBlockOperation *operation2 = [NSBlockOperation blockOperationWithBlock:^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [UIView animateWithDuration:0.3 animations:^{
                                tableView.contentInset = UIEdgeInsetsZero;
                            } completion:^(BOOL finished) {
                                if (self.isAnimationing) {
                                    [self stopAnimation];
                                }
                            }];
                        });
                    }];
                    
                    [operation2 addDependency:operation1];
                    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
                    [queue addOperations:@[operation2,operation1] waitUntilFinished:NO];
                }];
            }
        }
    }
}

@end
