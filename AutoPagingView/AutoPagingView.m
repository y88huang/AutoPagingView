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
@property (weak, nonatomic) id delegate;

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

- (id)initWithDelegate:(id)delegate
{
    self = [self init];
    if (self){
        self.delegate = delegate;
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
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.delegate action:@selector(pagePressed:)];
        [object addGestureRecognizer:recognizer];
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

@interface AutoPagingView ()

@property (nonatomic, strong) ReusePool *reusablePool;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation AutoPagingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor orangeColor];
        _currentPageIndex = 0;
        _reusablePool = [[ReusePool alloc] initWithDelegate:self];
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

- (void)setCurrentPageIndex:(NSUInteger)currentPageIndex
{
    _currentPageIndex = currentPageIndex;
    if (_currentPageIndex >= [self.delegate numberOfPagesInPagingView:self])
    {
        [self.delegate didFinishPlayingPaingView:self];
        return;
    }
    AutoPagingViewPage *page = [self.subviews lastObject];
    [page removeFromSuperview];
    UIView *nextPage = [self.delegate pagingView:self pageforIndex:_currentPageIndex];
    
    [self reusePage:page];
    
    [self addSubview:nextPage];
    nextPage.frame = self.bounds;
    [self.timer invalidate];
    self.timer = nil;
    self.timer = [NSTimer timerWithTimeInterval:[self.delegate playTimeForPagingView:self atIndex:currentPageIndex] target:self selector:@selector(pageToNextView) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)pageToNextView
{
    self.currentPageIndex++;
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

- (void)pagePressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didSelectAutoPagingView:atIndex:)])
    {
        [self.delegate didSelectAutoPagingView:self atIndex:_currentPageIndex];
        return;
    }
    return;
}

@end
