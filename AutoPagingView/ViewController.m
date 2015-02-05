//
//  ViewController.m
//  AutoPagingView
//
//  Created by Ken Huang on 2015-02-04.
//  Copyright (c) 2015 Ken Huang. All rights reserved.
//

#import "ViewController.h"
#import "AutoPagingView.h"
@interface ViewController ()<AutoPagingViewDelegate>
@property (nonatomic, strong) AutoPagingView *pageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageView = [[AutoPagingView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.pageView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.pageView.delegate = self;
    [self.pageView reloadData];
}
- (UIView *)pagingView:(AutoPagingView *)pagingView forIndex:(NSUInteger)index
{
    UIView *container = [pagingView dequeueReusableView];
    if (!container){
        container = [[UIView alloc] init];
    }
    container.backgroundColor = index % 2 == 0 ? [UIColor blueColor] : [UIColor redColor];
    return container;
}

- (NSTimeInterval)playTimeForPagingView:(AutoPagingView *)pagingView forIndex:(NSUInteger)index
{
    return 3;
}
@end
