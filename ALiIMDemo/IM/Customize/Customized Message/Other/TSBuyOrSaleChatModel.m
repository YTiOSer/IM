//
//  TSBuyOrSaleChatModel.m
//  AutoziTypSociality
//
//  Created by yangtao on 2018/4/18.
//  Copyright © 2018年 qeegoo. All rights reserved.
//

#import "TSBuyOrSaleChatModel.h"

@interface TSBuyOrSaleChatModel ()

/// 自定义消息体
@property (nonatomic, strong, readwrite) YWMessageBodyCustomize *bodyCustomize;

@end

@implementation TSBuyOrSaleChatModel

- (instancetype)initWithMessage:(id<IYWMessage>)aMessage
{
    self = [super init];
    
    if (self) {
        /// 初始化
        
        /// 记录消息体，您也可以不记录原始消息体，而是将数据解析后，记录解析后的数据
        self.bodyCustomize = (YWMessageBodyCustomize *)[aMessage messageBody];
        
        /// 设置气泡类型
        //        self.bubbleStyle = [aMessage outgoing] ? BubbleStyleCommonRight : BubbleStyleCommonLeft;
        self.bubbleStyle = BubbleStyleNone; //修改为不显示气泡
    }
    
    return self;
}

#pragma mark -


@end
