//
//  AutoPagingView.m
//  AutoPagingView
//
//  Created by Ken Huang on 2015-02-04.
//  Copyright (c) 2015 Ken Huang. All rights reserved.
//

#import "AutoPagingView.h"
#import "AutoPagingViewPage.h"
@interface ReusePool : NSObject

@property (strong, nonatomic) NSMutableDictionary *pool;
@property (strong, nonatomic) NSMutableDictionary *nameStorage;

- (id)objectWithIdentifier:(NSString *)identifier;
- (void)reuseObject:(id)Object withIdentifier:(NSString *)identifier;
- (void)registerClassName:(Class)aClass forIdentifier:(NSString *)identifier;

@end

@implementation ReusePool

- (id)init
{
    self = [super init];
    if (self)
    {
        self.pool = [[NSMutableDictionary alloc] initWithCapacity:2];
        self.nameStorage = [[NSMutableDictionary alloc] initWithCapacity:2];
    }
    return self;
}

- (void)reuseObject:(id)Object withIdentifier:(NSString *)identifier
{
    Class classType = [self.nameStorage objectForKey:identifier];
    NSAssert(classType != nil, @"class type is not registered, therefore cannot be reused");
    NSMutableArray *array = [self.pool objectForKey:identifier];
    if (!array)
    {
        array = [[NSMutableArray alloc] initWithCapacity:2];
        [self.pool setObject:array forKey:identifier];
    }
    [array addObject:Object];
}

- (id)objectWithIdentifier:(NSString *)identifier
{
    Class classType = [self.nameStorage objectForKey:identifier];
    NSAssert(classType != nil, @"class type is not registered, therefore cannot be reused");
    NSMutableArray *array = [self.pool objectForKey:identifier];
    if (!array)
    {
        array = [[NSMutableArray alloc] initWithCapacity:2];
        [self.pool setObject:array forKey:identifier];
    }
    id object = [array lastObject];
    if (!object) {
        object = [[classType alloc] initWithIdentifier:identifier];
    }else{
        [array removeObject:object];
    }
    return object;
}

- (void)registerClassName:(Class)aClass forIdentifier:(NSString *)identifier
{
    [self.nameStorage setObject:aClass forKey:identifier];
}

@end
@implementation AutoPagingView{
    NSUInteger _currentPageIndex;
    ReusePool *_reusablePool;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor orangeColor];
        _currentPageIndex = 0;
        _reusablePool = [[ReusePool alloc] init];
    }
    return self;
}

- (void)reloadData
{
    _currentPageIndex = 0;
    for (UIView *view in self.subviews)
    {
        [view removeFromSuperview];
    }
    AutoPagingViewPage *page= [self.delegate pagingView:self pageforIndex: _currentPageIndex];
    [page prepareForReuse];
    [_reusablePool reuseObject:page withIdentifier:page.identifier];
    [self addSubview:page];
    [self pageToNextView];
}

- (void)pageToNextView
{
    NSLog(@"Reusable pool size %lu",(unsigned long)_reusablePool.pool.count);
    NSLog(@"Printing Reusable Pool %@", _reusablePool.pool);
    if (_currentPageIndex >= [self.delegate numberOfPagesInPagingView:self])
    {
        [self.delegate didFinishPlayingPaingView:self];
        return;
    }
    _currentPageIndex++;
    AutoPagingViewPage *page = [self.subviews lastObject];
    [page removeFromSuperview];
    UIView *nextPage = [self.delegate pagingView:self pageforIndex:_currentPageIndex];
    
    [self reusePage:page];
    
    [self addSubview:nextPage];
    nextPage.frame = self.bounds;
    NSTimer *timer = [NSTimer timerWithTimeInterval:[self.delegate playTimeForPagingView:self atIndex:0] target:self selector:@selector(pageToNextView) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)reusePage:(AutoPagingViewPage *)page
{
    [_reusablePool reuseObject:page withIdentifier:page.identifier];
}

- (AutoPagingViewPage *)dequeueReusableViewWithIdentifier:(NSString *)identifier
{
    AutoPagingViewPage *page = [_reusablePool objectWithIdentifier:identifier];
    NSAssert(page != nil, @"cannot dequeue a nil Page!");
    return page;
}

- (void)registerClass:(Class)aClass forIdentifier:(NSString *)identifier
{
    [_reusablePool registerClassName:aClass forIdentifier:identifier];
}

@end
