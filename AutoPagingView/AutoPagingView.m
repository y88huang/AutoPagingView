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
    NSTimeInterval playtime = [self.delegate playTimeForPagingView:self forIndex:currentIndex];
    [self addSubview:view];
}

- (void)pageToNextView
{
    UIView *view = self.subviews[0];
    [view removeFromSuperview];
    UIView *nextPage = [reusablePool lastObject];
    [self reuseView: view];
    [self addSubview:nextPage];
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
