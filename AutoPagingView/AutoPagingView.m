//
//  AutoPagingView.m
//  AutoPagingView
//
//  Created by Ken Huang on 2015-02-04.
//  Copyright (c) 2015 Ken Huang. All rights reserved.
//

#import "AutoPagingView.h"

@implementation AutoPagingView{
    NSUInteger currentIndex;
    NSMutableArray *reusablePool;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor orangeColor];
        currentIndex = 0;
        reusablePool = [[NSMutableArray alloc] initWithCapacity:2];
    }
    return self;
}

- (void)reloadData
{
    currentIndex = 0;
    for (UIView *view in self.subviews)
    {
        [view removeFromSuperview];
    }
    UIView *view = [self.delegate pagingView:self forIndex:0];
    [reusablePool addObject:view];
    [self addSubview:view];
    [self pageToNextView];
}

- (void)pageToNextView
{
    currentIndex++;
    UIView *view = self.subviews[0];
    [view removeFromSuperview];
    UIView *nextPage = [self.delegate pagingView:self forIndex:currentIndex];
    [self reuseView: view];
    [self addSubview:nextPage];
    nextPage.frame = self.bounds;
    NSTimer *timer = [NSTimer timerWithTimeInterval:[self.delegate playTimeForPagingView:self forIndex:0] target:self selector:@selector(pageToNextView) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)reuseView:(UIView *)view
{
    [reusablePool addObject:view];
}

- (UIView *)dequeueReusableView
{
    UIView *view = [reusablePool lastObject];
    [reusablePool removeObject:view];
    return view;
}

@end
