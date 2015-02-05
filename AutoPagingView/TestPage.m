//
//  TestPage.m
//  AutoPagingView
//
//  Created by Ken Huang on 2015-02-05.
//  Copyright (c) 2015 Ken Huang. All rights reserved.
//

#import "TestPage.h"

@implementation TestPage{
    NSTimer *_timer;
    NSTimeInterval _displayTime;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.timeLabel = [[UILabel alloc] initWithFrame:frame];
        [self addSubview: self.timeLabel];
    }
    return self;
}

- (void)setDisplayTime:(NSTimeInterval)time
{
    if (_timer){
        [_timer invalidate];
        _timer = nil;
    }
    _displayTime = time;
    self.timeLabel.text = [@(_displayTime) stringValue];
    _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(refreshText) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)refreshText
{
    _displayTime -- ;
    if (_displayTime <= 0)
    {
        [_timer invalidate];
        _timer = nil;
        _displayTime = 0;
        return;
    }
    self.timeLabel.text = [@(_displayTime) stringValue];
}
- (void)prepareForReuse
{
    [super prepareForReuse];
    self.timeLabel.text = @"0";
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.timeLabel.frame = self.bounds;
}

@end
