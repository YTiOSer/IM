//
//  SPInputViewPluginGreeting.h
//  WXOpenIMSampleDev
//
//  Created by huanglei on 4/29/15.
//  Copyright (c) 2015 taobao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <WXOUIModule/YWUIFMWK.h>
#import <WXOpenIMSDKFMWK/YWFMWK.h>

/**
 *  这个类用于添加输入面板的自定义插件
 */

/// 输入面板的插件，需要遵循YWInputViewPluginProtocol协议
@interface SPInputViewPluginGreeting : NSObject
<YWInputViewPluginProtocol>

// 加载该插件的inputView
@property (nonatomic, weak) YWMessageInputView *inputViewRef;

@end
