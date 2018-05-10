//
//  SPGreetingBubbleViewModel.m
//  WXOpenIMSampleDev
//
//  Created by Jai Chen on 15/11/2.
//  Copyright © 2015年 taobao. All rights reserved.
//

#import "SPGreetingBubbleViewModel.h"

@implementation SPGreetingBubbleViewModel


- (instancetype)initWithMessage:(id<IYWMessage>)aMessage
{
    self = [super init];

    if (self) {
        /// 设置气泡类型
        self.bubbleStyle = BubbleStyleCustomize;
        self.layout = [aMessage outgoing] ? WXOBubbleLayoutRight : WXOBubbleLayoutLeft;
    }

    return self;
}

@end
