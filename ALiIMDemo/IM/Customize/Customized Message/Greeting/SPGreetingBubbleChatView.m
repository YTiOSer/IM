//
//  SPGreetingBubbleChatView.m
//  WXOpenIMSampleDev
//
//  Created by Jai Chen on 15/11/2.
//  Copyright © 2015年 taobao. All rights reserved.
//

#import "SPGreetingBubbleChatView.h"
#import "SPGreetingBubbleViewModel.h"

@interface SPGreetingBubbleChatView ()

@property (nonatomic, weak) UIImageView *imageView;

@end

@implementation SPGreetingBubbleChatView

- (instancetype)init {

    UIImage *image = [UIImage imageNamed:@"greeting_message"];
    CGRect frame = {{0, 0}, image.size};
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:imageView];

        NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:imageView
                                                                           attribute:NSLayoutAttributeWidth
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self
                                                                           attribute:NSLayoutAttributeWidth
                                                                          multiplier:1.0
                                                                            constant:0.0];

        NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:imageView
                                                                            attribute:NSLayoutAttributeHeight
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:self
                                                                            attribute:NSLayoutAttributeHeight
                                                                           multiplier:1.0
                                                                             constant:0.0];

        [self addConstraints:@[widthConstraint, heightConstraint]];
    }
    return self;
}


#pragma mark - YWBaseBubbleChatViewInf
/// 内容区域大小
- (CGSize)getBubbleContentSize
{
    return self.frame.size;
}

- (void)updateBubbleView {
    ;
}

// 返回所持ViewModel类名，用于类型检测
- (NSString *)viewModelClassName
{
    return NSStringFromClass([SPGreetingBubbleViewModel class]);
}

@end
