//
//  AutoPagingView.h
//  AutoPagingView
//
//  Created by Ken Huang on 2015-02-04.
//  Copyright (c) 2015 Ken Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AutoPagingView;
@protocol AutoPagingViewDelegate <NSObject>

- (NSInteger)numberOfElementsInView:(AutoPagingView *)view;
- (UIView *)pagingView:(AutoPagingView *)pagingView forIndex:(NSUInteger)index;
- (NSTimeInterval)playTimeForPagingView:(AutoPagingView *)pagingView forIndex:(NSUInteger)index;

@end

@interface AutoPagingView : UIView

- (UIView *)dequeueReusableView;
@property (weak, nonatomic) id <AutoPagingViewDelegate> delegate;
@end
