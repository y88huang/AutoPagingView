//
//  ViewController.m
//  AutoPagingView
//
//  Created by Ken Huang on 2015-02-04.
//  Copyright (c) 2015 Ken Huang. All rights reserved.
//

#import "ViewController.h"
#import "AutoPagingView.h"
#import "TestPage.h"

@interface ViewController ()<AutoPagingViewDelegate>
@property (nonatomic, strong) AutoPagingView *pageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageView = [[AutoPagingView alloc] initWithFrame:self.view.bounds];
    [self.pageView registerClass: [TestPage class] forIdentifier: @"testIdentifier"];
    [self.view addSubview:self.pageView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.pageView.delegate = self;
    [self.pageView reloadData];
}

- (AutoPagingViewPage *)pagingView:(AutoPagingView *)pagingView pageforIndex:(NSUInteger)index
{
    TestPage *page = (TestPage *)[pagingView dequeueReusableViewWithIdentifier:@"testIdentifier"];
    page.backgroundColor = index % 2 == 0 ? [UIColor redColor] : [UIColor greenColor];
    [page setDisplayTime:3];
    return page;
}

- (NSTimeInterval)playTimeForPagingView:(AutoPagingView *)pagingView atIndex:(NSUInteger)index
{
    return 3;
}

- (NSUInteger)numberOfPagesInPagingView:(AutoPagingView *)view
{
    return 4;
}

- (void)didFinishPlayingPaingView:(AutoPagingView *)pagingView
{
    [pagingView removeFromSuperview];
}

@end
