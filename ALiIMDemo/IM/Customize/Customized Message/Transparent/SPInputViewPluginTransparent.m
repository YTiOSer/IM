//
//  SPInputViewPluginTransparent.m
//  WXOpenIMSampleDev
//
//  Created by huanglei on 16/1/26.
//  Copyright © 2016年 taobao. All rights reserved.
//

#import "SPInputViewPluginTransparent.h"

#import "SPUtil.h"
#import "SPKitExample.h"

@interface SPInputViewPluginTransparent ()
<UIAlertViewDelegate>

@property (nonatomic, readonly) YWConversationViewController *conversationViewController;

@end

@implementation SPInputViewPluginTransparent

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
    return [UIImage imageNamed:@"input_plug_ico_transparent_nor"];
}

// 插件名称
- (NSString *)pluginName
{
    return @"阅后即焚";
}

// 插件对应的view，会被加载到inputView上
- (UIView *)pluginContentView
{
    return nil;
}

// 插件被选中运行
- (void)pluginDidClicked
{
    UIAlertView *alertView = [[UIAlertView alloc] init];
    alertView.delegate = self;
    alertView.title = @"输入阅后即焚内容";
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView addButtonWithTitle:@"取消"];
    [alertView addButtonWithTitle:@"确定"];
    
    [alertView show];
}

- (YWInputViewPluginType)pluginType {
    return YWInputViewPluginTypeDefault;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString *text = [[alertView textFieldAtIndex:0] text];
        
        if (text.length > 0) {
            __weak typeof(self) weakSelf = self;
            
            NSDictionary *contentDictionary = @{
                                                kSPCustomizeMessageType:@"yuehoujifen",
                                                @"text":text
                                                };
            NSData *data = [NSJSONSerialization dataWithJSONObject:contentDictionary
                                                           options:0
                                                             error:NULL];
            NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

            
            [[SPKitExample sharedInstance] exampleSendTransparentCommand:content inConversation:self.conversationViewController.conversation completion:^(NSError *error, NSString *messageID) {
                if (error.code == 0) {
                    [[SPUtil sharedInstance] showNotificationInViewController:weakSelf.conversationViewController title:@"发送成功" subtitle:@"" type:SPMessageNotificationTypeMessage];
                } else {
                    [[SPUtil sharedInstance] showNotificationInViewController:weakSelf.conversationViewController title:@"发送失败" subtitle:@"" type:SPMessageNotificationTypeError];
                }
            }];
        } else {
            [[SPUtil sharedInstance] showNotificationInViewController:self.conversationViewController title:@"内容为空" subtitle:@"" type:SPMessageNotificationTypeMessage];
        }
    }
}



@end
