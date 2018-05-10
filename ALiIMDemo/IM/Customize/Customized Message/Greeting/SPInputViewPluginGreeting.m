//
//  SPInputViewPluginGreeting.m
//  WXOpenIMSampleDev
//
//  Created by huanglei on 4/29/15.
//  Copyright (c) 2015 taobao. All rights reserved.
//

#import "SPInputViewPluginGreeting.h"
#import "SPUtil.h"
#import "SPKitExample.h"

@interface SPInputViewPluginGreeting ()

@property (nonatomic, readonly) YWConversationViewController *conversationViewController;

@end

@implementation SPInputViewPluginGreeting

#pragma mark - properties

- (YWConversationViewController *)conversationViewController
{
    if ([self.inputViewRef.controllerRef isKindOfClass:[YWConversationViewController class]]) {
        return (YWConversationViewController *)self.inputViewRef.controllerRef;
    } else {
        return nil;
    }
}


#pragma mark - YWInputViewPluginProtocol

/**
 * 您需要实现以下方法
 */

// 插件图标
- (UIImage *)pluginIconImage
{
    return [UIImage imageNamed:@"input_plug_ico_hi_nor"];
}

// 插件名称
- (NSString *)pluginName
{
    return @"打招呼";
}

// 插件对应的view，会被加载到inputView上
- (UIView *)pluginContentView
{
    return nil;
}

// 插件被选中运行
- (void)pluginDidClicked
{
    YWConversationViewController *conversationController = [self conversationViewController];
    __weak typeof(conversationController) weakController = conversationController;

    /// 构建一个自定义消息
    NSDictionary *contentDictionary = @{
                                        kSPCustomizeMessageType:@"Greeting",
                                        };
    NSData *data = [NSJSONSerialization dataWithJSONObject:contentDictionary
                                                   options:0
                                                     error:NULL];
    NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    YWMessageBodyCustomize *body = [[YWMessageBodyCustomize alloc] initWithMessageCustomizeContent:content
                                                                                           summary:@"您收到一个招呼"];


    /// 发送该自定义消息
    [conversationController.conversation asyncSendMessageBody:body
                                                     progress:nil
                                                   completion:^(NSError *error, NSString *messageID) {
                                                       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                           if (error.code == 0) {
                                                               [[SPKitExample sharedInstance] exampleInsertLocalMessageBody:[[YWMessageBodySystemNotify alloc] initWithContent:@"打招呼成功"] inConversation:weakController.conversation];
                                                           } else {
                                                               [[SPKitExample sharedInstance] exampleInsertLocalMessageBody:[[YWMessageBodySystemNotify alloc] initWithContent:@"打招呼失败"] inConversation:weakController.conversation];
                                                           }
                                                       });
                                                   }];
}

- (YWInputViewPluginType)pluginType {
    return YWInputViewPluginTypeDefault;
}

@end
