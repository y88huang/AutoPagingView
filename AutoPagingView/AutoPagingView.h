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

@required
- (NSUInteger)numberOfPagesInPagingView:(AutoPagingView *)pagingView;
- (UIView *)pagingView:(AutoPagingView *)pagingView pageforIndex:(NSUInteger)index;
- (NSTimeInterval)playTimeForPagingView:(AutoPagingView *)pagingView atIndex:(NSUInteger)index;
- (void)didFinishPlayingPaingView:(AutoPagingView *)pagingView;

@end

@interface AutoPagingView : UIView
- (void)reloadData;
- (UIView *)dequeueReusableView;
@property (weak, nonatomic) id <AutoPagingViewDelegate> delegate;
@end
