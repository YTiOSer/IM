//
//  TSBuyOrSaleChatViewCustomize.m
//  AutoziTypSociality
//
//  Created by yangtao on 2018/4/18.
//  Copyright © 2018年 qeegoo. All rights reserved.
//

#import "TSBuyOrSaleChatViewCustomize.h"

#import "TSBuyOrSaleChatModel.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"
#import "AutoziTypSociality-Swift.h" // oc引用swift文件

@interface TSBuyOrSaleChatViewCustomize ()

@property (nonatomic, strong) UIView *view_BG; //北京
@property (nonatomic, strong) UIImageView *img_Icon; //车标
@property (nonatomic, strong) UILabel *label_CarName; //车标名
@property (nonatomic, strong) UILabel *label_CarMessage; //车信息
@property (nonatomic, strong) UILabel *label_Area; //地区
@property (nonatomic, strong) UIView *view_Pary; //配件
@property (nonatomic, strong) UIButton *btn_BG; //配件

/// 对应的ViewModel
@property (nonatomic, strong, readonly) TSBuyOrSaleChatModel *viewModel;

@end


@implementation TSBuyOrSaleChatViewCustomize

@dynamic viewModel;

- (id)init
{
    self = [super init];
    
    if (self) {
        /// 初始化
        
        self.view_BG = [[UIView alloc] init];
        [self.view_BG setBackgroundColor:[UIColor whiteColor]];
        [self.view_BG.layer setBorderColor:[[UIColor colorWithRed:221/255.f green:221/255.f blue:221/255.f alpha:1] CGColor]];
        [self.view_BG.layer setBorderWidth:0.5];
        [self.view_BG.layer setCornerRadius:3];
        //        [self.view_BG.layer masksToBounds] = YES;
        [self addSubview:self.view_BG];
        [self.view_BG mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.right.equalTo(self).offset(-15);
            make.top.equalTo(@0);
            make.height.equalTo(@180);
        }];
        
        self.img_Icon = [[UIImageView alloc] init];
        self.img_Icon.image = [UIImage imageNamed:@"DefaultIMG"];
        [self.view_BG addSubview:self.img_Icon];
        [self.img_Icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@25);
            make.top.equalTo(@15);
            make.width.equalTo(@50);
            make.height.equalTo(@35);
        }];
        
        self.label_CarName = [[UILabel alloc] init];
        [self.label_CarName setText:@"吉利"];
        [self.label_CarName setTextColor:[UIColor colorWithRed:101/255.f green:101/255.f blue:101/255.f alpha:1]];
        [self.label_CarName setFont:[UIFont systemFontOfSize:15]];
        [self.view_BG addSubview:self.label_CarName];
        [self.label_CarName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.img_Icon);
            make.left.equalTo(self.img_Icon.mas_right).offset(10);
            make.right.equalTo(self).offset(-15);
        }];
        
        self.label_CarMessage = [[UILabel alloc] init];
        [self.label_CarMessage setText:@"博瑞 2015款 礼宾限量版 1.8T 四驱自动"];
        [self.label_CarMessage setTextColor:[UIColor colorWithRed:150/255.f green:150/255.f blue:150/255.f alpha:1]];
        [self.label_CarMessage setFont:[UIFont systemFontOfSize:14]];
        [self.view_BG addSubview:self.label_CarMessage];
        [self.label_CarMessage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.label_CarName.mas_bottom).offset(5);
            make.left.right.equalTo(self.label_CarName);
        }];
        
        self.label_Area = [[UILabel alloc] init];
        [self.label_Area setText:@"内蒙古自治区"];
        [self.label_Area setTextColor:[UIColor colorWithRed:210/255.f green:210/255.f blue:210/255.f alpha:1]];
        [self.label_Area setFont:[UIFont systemFontOfSize:13]];
        [self.view_BG addSubview:self.label_Area];
        [self.label_Area mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.label_CarMessage.mas_bottom).offset(8);
            make.left.right.equalTo(self.label_CarName);
        }];
        
        self.btn_BG = [[UIButton alloc] init];
        self.btn_BG.backgroundColor = [UIColor clearColor];
        [self.btn_BG addTarget:self action:@selector(jumpBtnClickBtn:) forControlEvents: UIControlEventTouchUpInside];
        [self.view_BG addSubview:self.btn_BG];
        [self.btn_BG mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view_BG);
        }];
        
    }
    
    return self;
}

- (void)jumpBtnClickBtn:(UIButton*)btn{
    
    NSString *content = self.viewModel.bodyCustomize.content;
    
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingMutableContainers
                                                           error:&err];
    if (self.JumpToDetailBlock){
        self.JumpToDetailBlock(dict);
    }
}

/// 计算尺寸，更新显示
- (CGSize)_calculateAndUpdateFitSize
{
    NSString *content = self.viewModel.bodyCustomize.content;
    
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingMutableContainers
                                                           error:&err];
    if(err){
        NSLog(@"json解析失败：%@",err);
    }
    
    [self.img_Icon sd_setImageWithURL:[NSURL URLWithString:dict[@"logoUrl"]] placeholderImage:[UIImage imageNamed:@"DefaultIMG"]];
    [self.label_CarName setText:dict[@"logoName"]];
    [self.label_CarMessage setText:dict[@"modelName"]];
    [self.label_Area setText:dict[@"areaName"]];
    
    NSArray *array = dict[@"categoryNameAndCount"];
    
    CGFloat width = TSBuyOrSaleChatViewCustomize.maxWidthUsedForLayout - 20;
    
    [self.view_BG mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(140 + array.count / 2 * 35));
    }];
    
    [self.btn_BG mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view_BG);
    }];
    
    if (self.view_BG.subviews.count == 4 + array.count){ //避免重复添加
        return CGSizeMake(width, 140 + array.count / 2 * 35);
    }
    
    for (int i = 0; i < array.count; i++){
        
        UIView *view_Part = [[UIView alloc] init];
        [view_Part.layer setBorderColor:[[UIColor colorWithRed:241/255.f green:241/255.f blue:241/255.f alpha:1] CGColor]];
        [view_Part.layer setBorderWidth:0.5];
        [view_Part.layer setCornerRadius:10];
        [self.view_BG addSubview:view_Part];
        [view_Part mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i % 2 == 0){
                make.left.equalTo(@25);
            }else{
                make.left.equalTo(@((width - 80) / 2 + 35));
            }
            make.top.equalTo(self.label_Area.mas_bottom).offset(15 + i / 2 * (20 + 15));
            make.width.equalTo(@((width - 80) / 2));
            make.height.equalTo(@20);
        }];
        
        UILabel *label_Color = [[UILabel alloc] init];
        if (i % 2 == 0){
            [label_Color setBackgroundColor:[UIColor colorWithRed:245/255.f green:185/255.f blue:48/255.f alpha:1]];
        }else{
            [label_Color setBackgroundColor:[UIColor colorWithRed:163/255.f green:214/255.f blue:61/255.f alpha:1]];
        }
        [view_Part addSubview:label_Color];
        [label_Color mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view_Part);
            make.left.equalTo(@10);
            make.width.equalTo(@3);
            make.height.equalTo(@8);
        }];
        
        UILabel *label_Name = [[UILabel alloc] init];
        [label_Name setText:array[i]];
        [label_Name setTextColor:[UIColor colorWithRed:153/255.f green:153/255.f blue:153/255.f alpha:1]];
        [label_Name setFont:[UIFont systemFontOfSize:14]];
        [view_Part addSubview:label_Name];
        [label_Name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view_Part);
            make.left.equalTo(label_Color.mas_right).offset(10);
            make.right.equalTo(view_Part.mas_right).offset(-5);
        }];
        
    }
    
    
    
    return CGSizeMake(width, 140 + array.count / 2 * 35);
    
    /// 你可以在这里根据消息的内容，更新子view的显示
    
    //    [self.label setText:self.viewModel.bodyCustomize.content];
    //
    //
    //
    //    /// 加大内容的边缘，您可以根据您的卡片，调整合适的大小
    //    CGSize result = [self.label.text sizeWithFont:self.label.font constrainedToSize:CGSizeMake(200, 10000)];
    //    result.width += 20;
    //    result.height += 20;
    //
    //    CGRect frame = self.frame;
    //    frame.size = result;
    //
    //    /// 更新frame
    //    [self setFrame:frame];
    //
    //    frame.size.height += 2;
    //    [self.label setFrame:frame];
    //    [self.label setCenter:CGPointMake(frame.size.width/2, frame.size.height/2)];
    //
    //    return result;
}

#pragma mark - YWBaseBubbleChatViewInf

/// 这几个函数是必须实现的

/// 内容区域大小
- (CGSize)getBubbleContentSize
{
    return [self _calculateAndUpdateFitSize];
}

/// 需要刷新BubbleView时会被调用
- (void)updateBubbleView
{
    [self _calculateAndUpdateFitSize];
}

// 返回所持ViewModel类名，用于类型检测
- (NSString *)viewModelClassName
{
    return NSStringFromClass([TSBuyOrSaleChatModel class]);
}


@end
