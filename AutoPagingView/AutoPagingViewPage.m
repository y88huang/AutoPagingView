//
//  AutoPagingViewPage.m
//  AutoPagingView
//
//  Created by Ken Huang on 2015-02-05.
//  Copyright (c) 2015 Ken Huang. All rights reserved.
//

#import "AutoPagingViewPage.h"

@interface AutoPagingViewPage ()

@property (nonatomic, copy) NSString *identifier;

@end

@implementation AutoPagingViewPage

- (id)initWithIdentifier:(NSString *)identifier;
{
    self = [super init];
    if (self)
    {
        self.identifier = identifier;
    }
    return self;
}

- (void)prepareForReuse
{
    //overide when clean up is needed.
}
@end
