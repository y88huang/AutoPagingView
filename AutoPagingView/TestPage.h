//
//  TestPage.h
//  AutoPagingView
//
//  Created by Ken Huang on 2015-02-05.
//  Copyright (c) 2015 Ken Huang. All rights reserved.
//

#import "AutoPagingViewPage.h"

@interface TestPage : AutoPagingViewPage

@property UILabel *timeLabel;

- (void)setDisplayTime:(NSTimeInterval)time;

@end
