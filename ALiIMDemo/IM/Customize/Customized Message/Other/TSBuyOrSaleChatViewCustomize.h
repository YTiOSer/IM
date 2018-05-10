//
//  TSBuyOrSaleChatViewCustomize.h
//  AutoziTypSociality
//
//  Created by yangtao on 2018/4/18.
//  Copyright © 2018年 qeegoo. All rights reserved.
//

#import <WXOUIModule/YWUIFMWK.h>

@interface TSBuyOrSaleChatViewCustomize : YWBaseBubbleChatView

@property (nonatomic, copy) void (^JumpToDetailBlock)(NSDictionary *dict);

@end
