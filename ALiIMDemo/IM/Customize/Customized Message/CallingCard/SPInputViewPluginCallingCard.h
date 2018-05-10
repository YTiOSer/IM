//
//  SPInputViewPluginCallingCard.h
//  WXOpenIMSampleDev
//
//  Created by Jai Chen on 15/10/27.
//  Copyright © 2015年 taobao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <WXOUIModule/YWUIFMWK.h>
#import <WXOpenIMSDKFMWK/YWFMWK.h>

@interface SPInputViewPluginCallingCard : NSObject
<YWInputViewPluginProtocol>

// 加载该插件的inputView
@property (nonatomic, weak) YWMessageInputView *inputViewRef;

@end
