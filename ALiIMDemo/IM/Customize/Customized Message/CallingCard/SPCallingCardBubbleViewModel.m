//
//  SPCallingCardBubbleViewModel.m
//  Messenger
//
//  Created by Jai Chen on 15/10/27.
//  Copyright © 2015年 taobao. All rights reserved.
//

#import "SPCallingCardBubbleViewModel.h"
#import "SPUtil.h"

@interface SPCallingCardBubbleViewModel ()

@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, strong, readwrite) UIImage *avatar;

@property (nonatomic, strong) YWPerson *person;
@property (nonatomic, assign) BOOL isRequestingProfile;

@end

@implementation SPCallingCardBubbleViewModel

- (instancetype)initWithMessage:(id<IYWMessage>)aMessage
{
    self = [super init];

    if (self) {
        /// 初始化

        /// 记录消息体，您也可以不记录原始消息体，而是将数据解析后，记录解析后的数据
        YWMessageBodyCustomize *bodyCustomize = (YWMessageBodyCustomize *)[aMessage messageBody];

        NSData *contentData = [bodyCustomize.content dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *contentDictionary = [NSJSONSerialization JSONObjectWithData:contentData
                                                                          options:0
                                                                            error:NULL];

        NSString *personId = contentDictionary[@"personId"];
        NSString *appKey = contentDictionary[@"appKey"];
        if (appKey.length) {
            self.person = [[YWPerson alloc] initWithPersonId:personId
                                                      appKey:appKey];
        }
        else {
            self.person = [[YWPerson alloc] initWithPersonId:personId];
        }



        __weak __typeof(self) weakSelf = self;

        [[SPUtil sharedInstance] syncGetCachedProfileIfExists:self.person
                                                   completion:^(BOOL aIsSuccess, YWPerson *aPerson, NSString *aDisplayName, UIImage *aAvatarImage) {
                                                       [weakSelf handleProfileResult:aDisplayName avatar:aAvatarImage];
                                                   }];
        if (!_nickName || !_avatar) {
            [self requestProfileIfNeeded];
        }

        /// 设置气泡类型
        self.bubbleStyle = BubbleStyleCustomize;
        self.layout = WXOBubbleLayoutCenter;
    }

    return self;
}

- (void)requestProfileIfNeeded {
    if (!self.person) {
        return;
    }

    if (self.isRequestingProfile) {
        return;
    }
    __weak __typeof(self) weakSelf = self;

    self.isRequestingProfile = YES;
    [[SPUtil sharedInstance] asyncGetProfileWithPerson:self.person
                                              progress:^(YWPerson *aPerson, NSString *aDisplayName, UIImage *aAvatarImage) {
                                                  [weakSelf handleProfileResult:aDisplayName avatar:aAvatarImage];
                                              } completion:^(BOOL aIsSuccess, YWPerson *aPerson, NSString *aDisplayName, UIImage *aAvatarImage) {
                                                  weakSelf.isRequestingProfile = NO;
                                                  [weakSelf handleProfileResult:aDisplayName avatar:aAvatarImage];
                                              }];
}

- (void)handleProfileResult:(NSString *)displayName avatar:(UIImage *)avatar {
    if (displayName && ![displayName isEqualToString:self.nickName]) {
        self.nickName = displayName;

        self.bubbleView.forceLayout = YES;
    }

    if (avatar) {
        self.avatar = avatar;

        self.bubbleView.forceLayout = YES;
    }

}


- (NSString *)displayName {
    if (!self.nickName) {
        [self requestProfileIfNeeded];

        return self.person.personId;
    }
    return self.nickName;
}

- (UIImage *)avatar {
    if (!_avatar) {
        [self requestProfileIfNeeded];
        return [UIImage imageNamed:@"demo_head_120"];
    }
    return _avatar;
}

@end
