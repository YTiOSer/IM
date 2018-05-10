//
//  SPUtil.h
//  WXOpenIMSampleDev
//
//  Created by huanglei on 15/4/12.
//  Copyright (c) 2015年 taobao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#import <WXOUIModule/YWUIFMWK.h>

/***********************************************
 ***********************************************
 ***********************************************
 
 SPUtil中包含的功能都是Demo中需要的辅助代码，在你的真实
 APP中一般都需要替换为你真实的实现!!!
 
 SPUtil中包含的功能都是Demo中需要的辅助代码，在你的真实
 APP中一般都需要替换为你真实的实现!!!

 SPUtil中包含的功能都是Demo中需要的辅助代码，在你的真实
 APP中一般都需要替换为你真实的实现!!!
 
 ***********************************************
 ***********************************************
 ***********************************************/





typedef NS_ENUM(NSInteger, SPMessageNotificationType) {
    SPMessageNotificationTypeMessage = 0,
    SPMessageNotificationTypeWarning,
    SPMessageNotificationTypeError,
    SPMessageNotificationTypeSuccess
};


@interface SPUtil : NSObject


+ (instancetype)sharedInstance;


/**
 *  显示提示信息
 */
- (void)showNotificationInViewController:(UIViewController *)viewController
                                   title:(NSString *)title
                                subtitle:(NSString *)subtitle
                                    type:(SPMessageNotificationType)type;


/**
 *  获取用户的profile
 */
- (void)asyncGetProfileWithPerson:(YWPerson *)aPerson progress:(YWFetchProfileProgressBlock)aProgress completion:(YWFetchProfileCompletionBlock)aCompletion;

/**
 *  同步获取已缓存的用户 profile
 */
- (void)syncGetCachedProfileIfExists:(YWPerson *)person completion:(YWFetchProfileCompletionBlock)completionBlock;

/**
 *  等待提示
 */
- (void)setWaitingIndicatorShown:(BOOL)aShown withKey:(NSString *)aKey;

@end


/// 需要替换成你自己的客服主账号
#define kSPEServicePersonId @"openim官方客服"









/*****************************************************
 *  这些宏定义用以产生Demo中的联系人数据
 *****************************************************/

@interface SPUtil ()

- (UIImage *)avatarForTribe:(YWTribe *)tribe;

@end

