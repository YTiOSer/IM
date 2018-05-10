//
//  SPBaseBubbleChatViewCustomize.m
//  WXOpenIMSampleDev
//
//  Created by huanglei on 4/29/15.
//  Copyright (c) 2015 taobao. All rights reserved.
//

#import "SPBaseBubbleChatViewCustomize.h"

#import "SPBubbleViewModelCustomize.h"

@interface SPBaseBubbleChatViewCustomize ()

@property (nonatomic, strong) UILabel *label;

/// 对应的ViewModel
@property (nonatomic, strong, readonly) SPBubbleViewModelCustomize *viewModel;

@end

@implementation SPBaseBubbleChatViewCustomize

@dynamic viewModel;

- (id)init
{
    self = [super init];
    
    if (self) {
        /// 初始化
        
        /// 你可以在这里添加不同的子view
        
        self.label = [[UILabel alloc] init];
        [self.label setBackgroundColor:[UIColor clearColor]];
        [self.label setTextColor:[UIColor whiteColor]];
        [self.label setFont:[UIFont systemFontOfSize:30.f]];
        [self.label setNumberOfLines:0];
        [self.label setTextAlignment:NSTextAlignmentCenter];
        
        [self addSubview:self.label];
    }
    
    return self;
}


/// 计算尺寸，更新显示
- (CGSize)_calculateAndUpdateFitSize
{
    /// 你可以在这里根据消息的内容，更新子view的显示
    
    [self.label setText:self.viewModel.bodyCustomize.content];

    /// 加大内容的边缘，您可以根据您的卡片，调整合适的大小
    CGSize result = [self.label.text sizeWithFont:self.label.font constrainedToSize:CGSizeMake(200, 10000)];
    result.width += 20;
    result.height += 20;

    CGRect frame = self.frame;
    frame.size = result;

    /// 更新frame
    [self setFrame:frame];

    frame.size.height += 2;
    [self.label setFrame:frame];
    [self.label setCenter:CGPointMake(frame.size.width/2, frame.size.height/2)];

    return result;
}

#pragma mark - YWBaseBubbleChatViewInf

/// 这几个函数是必须实现的

/// 内容区域大小
- (CGSize)getBubbleContentSize
{
    return [self _calculateAndUpdateFitSize];
}

/// 需要刷新BubbleView时会被调用
- (void)updateBubbleView
{
    [self _calculateAndUpdateFitSize];
}

// 返回所持ViewModel类名，用于类型检测
- (NSString *)viewModelClassName
{
    return NSStringFromClass([SPBubbleViewModelCustomize class]);
}


@end
