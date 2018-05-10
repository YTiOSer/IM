//
//  SPCallingCardBubbleViewModel.h
//  Messenger
//
//  Created by Jai Chen on 15/10/27.
//  Copyright © 2015年 taobao. All rights reserved.
//

#import <WXOUIModule/YWUIFMWK.h>
#import <WXOpenIMSDKFMWK/YWFMWK.h>

@interface SPCallingCardBubbleViewModel : YWBaseBubbleViewModel

- (instancetype)initWithMessage:(id<IYWMessage>)aMessage;

@property (nonatomic, readonly) YWPerson *person;
@property (nonatomic, readonly) NSString *displayName;
@property (nonatomic, readonly) UIImage *avatar;


typedef void (^CardBubbleAsk4ShowCard) ();
@property (nonatomic,   copy) CardBubbleAsk4ShowCard ask4showBlock;
- (void)setAsk4showBlock:(CardBubbleAsk4ShowCard)ask4showBlock;

@end
