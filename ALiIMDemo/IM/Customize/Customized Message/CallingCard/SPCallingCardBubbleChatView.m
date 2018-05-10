//
//  SPCallingCardBubbleChatView.m
//  Messenger
//
//  Created by Jai Chen on 15/10/27.
//  Copyright © 2015年 taobao. All rights reserved.
//

#import "SPCallingCardBubbleChatView.h"
#import "SPCallingCardBubbleViewModel.h"
#import "SPUtil.h"

@interface SPCallingCardBubbleChatView ()

@property (nonatomic, strong) SPCallingCardBubbleViewModel *viewModel;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@end

@implementation SPCallingCardBubbleChatView
@dynamic viewModel;

- (instancetype)init {
    if (self = [super init]) {
        UINib *nib = [UINib nibWithNibName:@"SPCallingCardBubbleChatContentView" bundle:nil];
        [nib instantiateWithOwner:self options:NULL];
        self.frame = self.contentView.frame;
        [self addSubview:self.contentView];

        UITapGestureRecognizer *tapGestureRecognizer =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onCardClicked)];
        [self addGestureRecognizer:tapGestureRecognizer];

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.avatarImageView.layer.cornerRadius = CGRectGetWidth(self.avatarImageView.frame) * 0.5;
    self.avatarImageView.clipsToBounds = YES;
}

- (void)onCardClicked
{
    if ( self.viewModel.ask4showBlock )
    {
        self.viewModel.ask4showBlock();
    }
}


#pragma mark - YWBaseBubbleChatViewInf
/// 内容区域大小
- (CGSize)getBubbleContentSize
{
    return self.frame.size;
}

/// 需要刷新BubbleView时会被调用
- (void)updateBubbleView
{
    self.nameLabel.text = self.viewModel.displayName;
    self.avatarImageView.image = self.viewModel.avatar;
}

// 返回所持ViewModel类名，用于类型检测
- (NSString *)viewModelClassName
{
    return NSStringFromClass([SPCallingCardBubbleViewModel class]);
}

@end
