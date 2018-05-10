//
//  SPInputViewPluginTransparent.h
//  WXOpenIMSampleDev
//
//  Created by huanglei on 16/1/26.
//  Copyright © 2016年 taobao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <WXOUIModule/YWUIFMWK.h>
#import <WXOpenIMSDKFMWK/YWFMWK.h>

/// 需要实现输入插件协议
@interface SPInputViewPluginTransparent : NSObject
<YWInputViewPluginProtocol>

// 加载该插件的inputView
@property (nonatomic, weak) YWMessageInputView *inputViewRef;

@end
