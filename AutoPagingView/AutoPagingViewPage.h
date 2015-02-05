//
//  AutoPagingViewPage.h
//  AutoPagingView
//
//  Created by Ken Huang on 2015-02-05.
//  Copyright (c) 2015 Ken Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AutoPagingViewPage : UIView

- (void)prepareForReuse;
- (id)initWithIdentifier:(NSString *)identifier;

@property (nonatomic, readonly,copy) NSString *identifier;

@end
