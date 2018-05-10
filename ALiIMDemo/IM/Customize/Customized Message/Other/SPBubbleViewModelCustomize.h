//
//  SPBubbleViewModelCustomize.h
//  WXOpenIMSampleDev
//
//  Created by huanglei on 4/29/15.
//  Copyright (c) 2015 taobao. All rights reserved.
//

#import <WXOUIModule/YWUIFMWK.h>
#import <WXOpenIMSDKFMWK/YWFMWK.h>

@interface SPBubbleViewModelCustomize : YWBaseBubbleViewModel

- (instancetype)initWithMessage:(id<IYWMessage>)aMessage;


/// 自定义消息体
@property (nonatomic, strong, readonly) YWMessageBodyCustomize *bodyCustomize;

@end
