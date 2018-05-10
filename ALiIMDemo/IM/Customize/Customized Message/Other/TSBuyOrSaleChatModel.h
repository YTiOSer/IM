//
//  TSBuyOrSaleChatModel.h
//  AutoziTypSociality
//
//  Created by yangtao on 2018/4/18.
//  Copyright © 2018年 qeegoo. All rights reserved.
//

#import <WXOUIModule/YWUIFMWK.h>
#import <WXOpenIMSDKFMWK/YWFMWK.h>

@interface TSBuyOrSaleChatModel : YWBaseBubbleViewModel

- (instancetype)initWithMessage:(id<IYWMessage>)aMessage;


/// 自定义消息体
@property (nonatomic, strong, readonly) YWMessageBodyCustomize *bodyCustomize;

@end
