//
//  SPUtil.m
//  WXOpenIMSampleDev
//
//  Created by huanglei on 15/4/12.
//  Copyright (c) 2015年 taobao. All rights reserved.
//

#import "SPUtil.h"

#import <CommonCrypto/CommonDigest.h>

#import <WXOUIModule/YWIndicator.h>
#import "SPKitExample.h"

@interface SPUtil ()

@property (nonatomic, readonly) NSArray *arrayProfileDictionaries;

@property (nonatomic, strong) NSMutableSet *waitingIndicatorKeys;
@property (nonatomic, strong) UIControl *controlWaiting;

@property (nonatomic, strong) NSMutableDictionary *cachedPersonDisplayNames;
@property (nonatomic, strong) NSMutableDictionary *cachedPersonAvatars;

@end

@implementation SPUtil

#pragma mark - life

- (id)init
{
    self = [super init];
    
    if (self) {
        /// 初始化
        
        self.waitingIndicatorKeys = [NSMutableSet setWithCapacity:20];
        {
            self.controlWaiting = [[UIControl alloc] initWithFrame:[SPKitExample sharedInstance].rootWindow.frame];
            [self.controlWaiting setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
            [self.controlWaiting setBackgroundColor:[UIColor clearColor]];
            
            UIView *viewFrame = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
            [viewFrame setBackgroundColor:[UIColor colorWithWhite:0.f alpha:.8f]];
            [viewFrame.layer setMasksToBounds:YES];
            [viewFrame.layer setCornerRadius:3.f];
            [viewFrame setCenter:CGPointMake(self.controlWaiting.bounds.size.width/2, self.controlWaiting.bounds.size.height/2)];
            [viewFrame setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin];
            [self.controlWaiting addSubview:viewFrame];
            
            UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            [indicator startAnimating];
            [indicator setCenter:CGPointMake(viewFrame.bounds.size.width/2, viewFrame.bounds.size.height/2)];
            [indicator setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin];
            [viewFrame addSubview:indicator];
            
            [indicator setHidesWhenStopped:NO];

            self.cachedPersonDisplayNames = [NSMutableDictionary dictionary];
            self.cachedPersonAvatars = [NSMutableDictionary dictionary];
        }
    }
    
    return self;
}

#pragma mark - public

+ (instancetype)sharedInstance
{
    static SPUtil *sUtil = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sUtil = [[SPUtil alloc] init];
    });
    
    return sUtil;
}

- (void)showNotificationInViewController:(UIViewController *)viewController title:(NSString *)title subtitle:(NSString *)subtitle type:(SPMessageNotificationType)type
{
    /// 在这里使用了OpenIMSDK提供的默认样式显示提示信息
    /// 在您的app中，您也可以换成您app中已有的提示方式
    [YWIndicator showTopToastTitle:title content:subtitle userInfo:nil withTimeToDisplay:1.f andClickBlock:NULL];
}

/****************************************************************************
 *  获取用户的profile
 
 *  注意：这里使用了dispatch_after模拟网络延迟
 *  实际上，您需要修改为您自己获取用户profile的实现
 
 ****************************************************************************/

- (void)asyncGetProfileWithPerson:(YWPerson *)aPerson progress:(YWFetchProfileProgressBlock)aProgress completion:(YWFetchProfileCompletionBlock)aCompletion
{
#warning TODO: CHANGE TO YOUR ACTUAL Profile GETTING METHOD
    
    /// 我们已经将用户profile导入到IM服务器，所以直接调用IMSDK底层接口，获取profile
    
    [[[SPKitExample sharedInstance].ywIMKit.IMCore getContactService] asyncGetProfileFromServerForPerson:aPerson withTribe:nil withProgress:^(YWProfileItem *item) {
        if (aProgress) {
            aProgress(item.person, item.displayName, item.avatar);
        }
    } andCompletionBlock:^(BOOL aIsSuccess, YWProfileItem *item) {
        if (aCompletion) {
            aCompletion(aIsSuccess, item.person, item.displayName, item.avatar);
        }
    }];
    
}

- (void)syncGetCachedProfileIfExists:(YWPerson *)person completion:(YWFetchProfileCompletionBlock)completionBlock {

    YWProfileItem *item = [[[SPKitExample sharedInstance].ywIMKit.IMCore getContactService] getProfileForPerson:person withTribe:nil];
    NSString *displayName = item.displayName;
    UIImage *avatar = item.avatar;
    
    if (item.updateDateFromServer && [[NSDate date] timeIntervalSinceDate:item.updateDateFromServer] <= 24 * 3600) {
        if (displayName == nil) {
            displayName = person.personId;
        }
        if (avatar == nil) {
            avatar = [UIImage imageNamed:@"demo_head_120"];
        }
    }


    if (displayName || avatar) {
        completionBlock(YES, person, displayName, avatar);
    }
    else {
        completionBlock(NO, person, nil, nil);
    }
}

- (void)setWaitingIndicatorShown:(BOOL)aShown withKey:(NSString *)aKey
{
    if (!aKey) {
        return;
    }
    
    if (aShown) {
        [self.waitingIndicatorKeys addObject:aKey];
    } else {
        [self.waitingIndicatorKeys removeObject:aKey];
    }
    
    if (self.waitingIndicatorKeys.count > 0) {
        [self.controlWaiting setFrame:[SPKitExample sharedInstance].appDelegate.window.bounds];
        [[SPKitExample sharedInstance].appDelegate.window addSubview:self.controlWaiting];
    } else {
        [self.controlWaiting removeFromSuperview];
    }
}


#pragma mark - private

- (UIImage *)avatarForTribe:(YWTribe *)tribe {
    if (tribe.tribeType == YWTribeTypeMultipleChat) {
        return [UIImage imageNamed:@"demo_discussion"];
    }
    return [UIImage imageNamed:@"demo_group_120"];
}

@end
