//
//  AutoPagingView.h
//  AutoPagingView
//
//  Created by Ken Huang on 2015-02-04.
//  Copyright (c) 2015 Ken Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AutoPagingViewPage;
@class AutoPagingView;

@protocol AutoPagingViewDelegate <NSObject>

@optional

- (void)didSelectAutoPagingView:(AutoPagingView *)pagingView atIndex:(NSUInteger)index;

@required
- (NSUInteger)numberOfPagesInPagingView:(AutoPagingView *)pagingView;
- (AutoPagingViewPage *)pagingView:(AutoPagingView *)pagingView pageforIndex:(NSUInteger)index;
- (NSTimeInterval)playTimeForPagingView:(AutoPagingView *)pagingView atIndex:(NSUInteger)index;
- (void)didFinishPlayingPaingView:(AutoPagingView *)pagingView;

@end

@interface AutoPagingView : UIView

- (void)reloadData;
- (void)registerClass:(Class)aClass forIdentifier:(NSString *)identifier;
- (AutoPagingViewPage *)dequeueReusableViewWithIdentifier:(NSString *)identifier;
@property (weak, nonatomic) id <AutoPagingViewDelegate> delegate;
@property (nonatomic) NSUInteger currentPageIndex;

@end
