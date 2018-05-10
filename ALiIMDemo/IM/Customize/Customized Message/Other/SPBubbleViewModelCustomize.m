//
//  SPBubbleViewModelCustomize.m
//  WXOpenIMSampleDev
//
//  Created by huanglei on 4/29/15.
//  Copyright (c) 2015 taobao. All rights reserved.
//

#import "SPBubbleViewModelCustomize.h"

@interface SPBubbleViewModelCustomize ()

/// 自定义消息体
@property (nonatomic, strong, readwrite) YWMessageBodyCustomize *bodyCustomize;

@end

@implementation SPBubbleViewModelCustomize

- (instancetype)initWithMessage:(id<IYWMessage>)aMessage
{
    self = [super init];
    
    if (self) {
        /// 初始化
        
        /// 记录消息体，您也可以不记录原始消息体，而是将数据解析后，记录解析后的数据
        self.bodyCustomize = (YWMessageBodyCustomize *)[aMessage messageBody];
        
        /// 设置气泡类型
        self.bubbleStyle = [aMessage outgoing] ? BubbleStyleCommonRight : BubbleStyleCommonLeft;
    }
    
    return self;
}

#pragma mark - 


@end
