//
//  SPKitExample.h
//  WXOpenIMSampleDev
//
//  Created by huanglei on 15/4/11.
//  Copyright (c) 2015年 taobao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <WXOpenIMSDKFMWK/YWFMWK.h>
#import <WXOUIModule/YWUIFMWK.h>


#define SPTribeSystemConversationID [NSString stringWithFormat:@"%@SPTribeSystem", kYWCustomConversationIdPrefix]

/// 自定义会话的id
FOUNDATION_EXTERN NSString *const kSPCustomConversationIdForPortal;
FOUNDATION_EXTERN NSString *const kSPCustomConversationIdForFAQ;

/// 定义用于自定义消息内部类型的key
#define kSPCustomizeMessageType @"customizeMessageType"


@class YWIMKit;

@interface SPKitExample : NSObject

/// SDK中的接口分为全局接口和非全局接口，非全局接口需要通过YWIMKit或其成员YWIMCore调用，所以这里需要持有这个对象
@property (strong, nonatomic, readwrite) YWIMKit *ywIMKit;

+ (instancetype)sharedInstance;

#pragma mark - quick start 使用下面三个函数即可完成从程序启动到登录再到登出的完整流程

/****************************************************************************
 ****************************************************************************
 ****************************************************************************
 ****************************************************************************
 
 注意：在-[AppDelegate didFinishLaunchingWithOptions:]等函数中调用下面这几个基础的入口胶水函数，可完成初步的集成。
 
 注意：进一步地，胶水代码中包含了特地设置的#warning，请仔细阅读这些warning的注释，根据实际情况调整代码，以符合你的需求。
 
 ****************************************************************************
 ****************************************************************************
 ****************************************************************************
 ****************************************************************************/
/**
 *  入口胶水函数：初始化入口函数
 *
 *  程序完成启动，在appdelegate中的 application:didFinishLaunchingWithOptions:一开始的地方调用
 */
- (void)callThisInDidFinishLaunching;

/** 
 *  入口胶水函数：登录入口函数
 *
 *  用户在应用的服务器登录成功之后，向云旺服务器登录之前调用
 *  @param ywLoginId, 用来登录云旺IMSDK的id
 *  @param password, 用来登录云旺IMSDK的密码
 *  @param aSuccessBlock, 登陆成功的回调
 *  @param aFailedBlock, 登录失败的回调
 */
- (void)callThisAfterISVAccountLoginSuccessWithYWLoginId:(NSString *)ywLoginId passWord:(NSString *)passWord preloginedBlock:(void(^)())aPreloginedBlock successBlock:(void(^)())aSuccessBlock failedBlock:(void (^)(NSError *))aFailedBlock;

/**
 *  入口胶水函数：登出入口函数
 *
 *  用户即将退出登录时调用
 */
- (void)callThisBeforeISVAccountLogout;





/****************************************************************************
 ****************************************************************************
 ****************************************************************************
 ****************************************************************************
 
 以下是各个子功能的胶水函数
 
 ****************************************************************************
 ****************************************************************************
 ****************************************************************************
 ****************************************************************************/

#pragma mark - basic

/**
 *  初始化的示例代码
 */
- (BOOL)exampleInit;

/**
 *  设置证书名的示例代码
 */
- (void)exampleSetCertName;

/**
 *  登录的示例代码
 */
- (void)exampleLoginWithUserID:(NSString *)aUserID password:(NSString *)aPassword successBlock:(void(^)())aSuccessBlock failedBlock:(void(^)(NSError *aError))aFailedBlock;

/**
 *  监听连接状态
 */
- (void)exampleListenConnectionStatus;

@property (nonatomic, assign) YWIMConnectionStatus lastConnectionStatus;

/**
 *  注销的示例代码
 */
- (void)exampleLogout;

/**
 *  预登录：上次登录过账号A，这次app启动，可以直接预登录该帐号，进入查看本地数据。同时发起真正的登录操作，连接IM。
 */
- (void)examplePreLoginWithLoginId:(NSString *)loginId successBlock:(void(^)())aPreloginedBlock;

#pragma mark - abilities

/**
 *  设置语音等声音的播放模式
 */
- (void)exampleSetAudioCategory;

/**
 *  设置头像显示方式：包括圆角弧度和contentMode
 */
- (void)exampleSetAvatarStyle;


/**
 *  设置头像和昵称
 */
- (void)exampleSetProfile;

#pragma mark - UI pages

/**
 *  创建会话列表页面
 */
- (YWConversationListViewController *)exampleMakeConversationListControllerWithSelectItemBlock:(YWConversationsListDidSelectItemBlock)aSelectItemBlock;

/**
 *  打开某个会话
 */
- (void)exampleOpenConversationViewControllerWithConversation:(YWConversation *)aConversation fromNavigationController:(UINavigationController *)aNavigationController;

/**
 *  打开单聊页面
 */
- (void)exampleOpenConversationViewControllerWithPerson:(YWPerson *)aPerson fromNavigationController:(UINavigationController *)aNavigationController;

/**
 *  打开群聊页面
 */
- (void)exampleOpenConversationViewControllerWithTribe:(YWTribe *)aTribe fromNavigationController:(UINavigationController *)aNavigationController;

/**
 *  打开客服会话
 *  @param aPersonId 客服Id
 */
- (void)exampleOpenEServiceConversationWithPersonId:(NSString *)aPersonId
                    fromNavigationController:(UINavigationController *)aNavigationController;

/**
 *  创建某个会话Controller
 */
- (YWConversationViewController *)exampleMakeConversationViewControllerWithConversation:(YWConversation *)aConversation;


#pragma mark - 自定义业务

/**
 *  设置如何显示自定义消息
 */
- (void)exampleShowCustomMessageWithConversationController:(YWConversationViewController *)aConversationController;

/**
 *  添加或者更新自定义会话
 */
- (void)exampleAddOrUpdateCustomConversation;

/**
 *  自定义优先级的置顶会话（可保持长期置顶）
 */
- (void)exampleAddHighPriorityCustomConversation;

/**
 *  将会话置顶，或者取消置顶
 */
- (void)exampleMarkConversationOnTop:(YWConversation *)aConversation onTop:(BOOL)aOnTop;

/**
 *  自定义会话Cell及菜单
 */
- (void)exampleCustomizeConversationCellWithConversationListController:(YWConversationListViewController *)aConversationListController;

/**
 *  发送透传指令
 *  并且展示了如何在客户端控制对方iOS设备收到的Push文案
 *  不显示在会话列表和聊天页面，开发者可以监听到该消息，做特定的逻辑处理
 */
- (void)exampleSendTransparentCommand:(NSString *)aCommand inConversation:(YWConversation *)aConversation completion:(YWMessageSendingCompletionBlock)aCompletion;

/**
 *  插入本地消息
 *  消息不会被发送到对方，仅本地展示
 */
- (void)exampleInsertLocalMessageBody:(YWMessageBody *)aBody inConversation:(YWConversation *)aConversation;

#pragma mark - Customize

/**
 *  自定义全局导航栏
 */
- (void)exampleCustomGlobleNavigationBar;

/**
 *  自定义皮肤
 */
- (void)exampleCustomUISkin;

/**
 *  开启群@消息功能
 */
- (void)exampleEnableTribeAtMessage;

#pragma mark - 聊天页面自定义

/**
 *  添加输入面板插件
 */
- (void)exampleAddInputViewPluginToConversationController:(YWConversationViewController *)aConversationController;

/**
 *  设置消息的长按菜单
 *  这个方法展示如何设置图片消息的长按菜单
 */
- (void)exampleSetMessageMenuToConversationController:(YWConversationViewController *)aConversationController;

/**
 *  设置气泡最大宽度
 */
- (void)exampleSetMaxBubbleWidth;


#pragma mark - events

/**
 *  监听新消息
 */
- (void)exampleListenNewMessage;

/**
 *  监听自己发送的消息的生命周期
 */
- (void)exampleListenMyMessageLife;

/**
 * 头像点击事件
 */
- (void)exampleListenOnClickAvatar;

/**
 *  链接点击事件
 */
- (void)exampleListenOnClickUrl;

/**
 *  预览大图事件
 */
- (void)exampleListenOnPreviewImage;


#pragma mark - apns

/**
 *  您需要在-[AppDelegate application:didFinishLaunchingWithOptions:]中第一时间设置此回调
 *  在IMSDK截获到Push通知并需要您处理Push时，IMSDK会自动调用此回调
 */
- (void)exampleHandleAPNSPush;


#pragma mark - EService

/**
 *  获取EService对象
 */
- (YWPerson *)exampleFetchEServicePersonWithPersonId:(NSString *)aPersonId groupId:(NSString *)aGroupId;


#pragma mrk - Feedback

/**
 *  监听反馈新消息
 */
- (void)exampleListenFeedbackNewMessage;

/**
 *  获取反馈未读数，用于在反馈入口或其他位置标注红点引导用户查看反馈消息
 */
- (void)exampleGetFeedbackUnreadCount:(BOOL)isAnonLogin inViewController:(UIViewController *)viewController;

/**
 *  获取反馈并打开反馈页面
 */
- (void)exampleOpenFeedbackViewController:(BOOL)isAnonLogin
                       fromViewController:(UIViewController *)aViewController;

@end

#pragma mark - 其他

@interface SPKitExample ()

// 用于监听群系统消息变更
@property (nonatomic, strong) YWTribeSystemConversation *tribeSystemConversation;

@property (nonatomic, readonly) id<UIApplicationDelegate> appDelegate;

@property (nonatomic, readonly) UIWindow *rootWindow;

@end
