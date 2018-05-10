# 阿里百川IM集成
> 最近项目中用到了即时通讯,需要使用单聊 群聊等功能,经过一番对比,最终选择了阿里系的阿里百川IM,选择阿里的原因主要就是免费切后续没有别的附加费用和限制,所以就决定使用百川IM.

> 前段时间一直在忙着开发项目,在集成百川IM的过程中也遇到了不少的坑,所以想着项目做完闲下来写篇文章来记录一下,让更多的攻城狮在以后的集成过程中少踩些坑.

![664070306cb6ce2e8e0e297f5f086aca.jpg](https://upload-images.jianshu.io/upload_images/8283020-b84ac1df51ff96f5.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


##### 下面我详细介绍下阿里百川集成过程及其中的坑.
#### 1. 准备工作
- 阿里百川有详细的前后端集成文档,在接入之前强烈建议多读几遍
- 下载官方DEMO,运行demo看下功能是否满足项目需求.

[DEMO下载地址](https://baichuan.taobao.com/portal/newDocIndex.htm?spm=a3c0d.7998979.1998907816.25.48532f457DbwYN)

#### 2. 百川创建应用
- 创建时候有一个坑需要注意,因为安卓iOS聊天是需要同一个KEY,所以创建应用的时候**创建一个**即可,因为创建时候可以根据iOS的bundleID或安卓的包名,这点需要注意.
- 创建完应用后就有了key,然后需要在项目中**换成自己的key**.
![95D0BE6B-8D2E-4B59-9E6A-8FEE5B3CA7F1.png](https://upload-images.jianshu.io/upload_images/8283020-396344450216a6ce.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
- 安全图片,百川验证应用信息是通过安全图片验证的,所以需要申请安全图片,申请图片的版本V4 V5需要根据自己当前**库版本**决定,现在最近版的库使用的是V4,这里注意(坑). 
另外,在替换成自己项目的安全图片时,切记图片名称保持**yw_1222.jpg**不要换,因为百川读取的是这个名字的图片.

![FE23E4AF-E381-407C-AD8E-F369FA095D7C.png](https://upload-images.jianshu.io/upload_images/8283020-73c8efcb396477cb.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

- 如果需要**推送消息**,还需要集成推送功能(安卓自带有,iOS需要自己配置)
集成推送需要上传推送证书,然后在项目中修改成自己的证书名.
上传推送证书,需要在产品后台开通百川即时通讯(这是现在版本,以前版本是在应用下面选项就可以上传),注意,这里直接用**生产**证书,开发证书在这里上传无效,因为阿里使用的生产环境证书.

![CDD0F3E5-BF06-4257-A573-A7A7BA3A6A4F.png](https://upload-images.jianshu.io/upload_images/8283020-e20e15d600699cff.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### 3. 项目集成过程
- 快速集成可参考百川文档,根据文档可快速集成IM(快速集成使用的是基本聊天功能,若需求有自定义等则需要自己修改开发)
[快速集成文档](http://baichuan.taobao.com/docs/doc.htm?spm=a3c0d.7629140.0.0.Jg1dgL&treeId=41&articleId=103398&docType=1)
- 需要在 didFinishLaunchingWithOptions 初始化IM,这里也可以进行登录操作,同时在退出登录时,需要退出IM,不然切换账号IM聊天信息还是上一个账号的缓存.
```
// YWSDK快速接入接口，程序启动后调用这个接口
SPKitExample.sharedInstance().callThisInDidFinishLaunching()

if BaseUser.shareUser().isLogined{
SPKitExample.sharedInstance().callThisAfterISVAccountLoginSuccess(withYWLoginId: BaseUser.shareUser().getUserId(), passWord: IMUserPwd, preloginedBlock: {

}, successBlock: {
self.showToast(text: "IM登录成功")
}, failedBlock: { (error) in
self.showToast(text: "IM登录失败")
})
}
```
退出登录,同时退出百川IM.
`
SPKitExample.sharedInstance().callThisBeforeISVAccountLogout()
`
- 调单聊页面
```
let person = YWPerson.init(personId: "对方百川id")
if SPKitExample.sharedInstance().ywIMKit == nil{self.showToast(text: "IM未登录成功"); return} //IM未登录成功
let conversation = YWP2PConversation.fetch(by: person, creatIfNotExist: true, baseContext: SPKitExample.sharedInstance().ywIMKit.imCore) //获取单聊会话
vc_Chat = SPKitExample.sharedInstance().exampleMakeConversationViewController(with: conversation)// 创建会话Controller
SPKitExample.sharedInstance().ywIMKit.imCore.getContactService().enableContactOnlineStatus = true //显示用户是否在线 默认为NO既默认都显示在线
vc_Chat?.viewDidLoadBlock = { [weak self] in
guard let strongSelf = self else{return}
//在这里可以进行自定义 比如导航栏按钮 标题 请求数据等
}
navigationController?.pushViewController(vc_Chat!, animated: true)

```
注: 这里有个坑.iOS最新的版本 viewDidLoadBlock 这些view相关事件调出,是**readonly**只读的,如果需要使用,把readonly去掉即可,如下:
```
@property (nonatomic, copy) YWViewDidLoadBlock viewDidLoadBlock;
//@property (nonatomic, copy, readonly) YWViewWillAppearBlock viewWillAppearBlock;
@property (nonatomic, copy) YWViewWillAppearBlock viewWillAppearBlock;
@property (nonatomic, copy, readonly) YWViewDidAppearBlock viewDidAppearBlock;
@property (nonatomic, copy, readonly) YWViewWillDisappearBlock viewWillDisappearBlock;
@property (nonatomic, copy, readonly) YWViewDidDisappearBlock viewDidDisappearBlock;
@property (nonatomic, copy, readonly) YWViewControllerWillDeallocBlock viewControllerWillDeallocBlock;
```
- 调群聊页面
```
SPKitExample.sharedInstance().ywIMKit.imCore.getTribeService().requestTribe(fromServer: id_SelectGroupChat) { [weak self](tribute, error) in
guard let strongSelf = self else{return}
if SPKitExample.sharedInstance().ywIMKit == nil{weakSelf.showToast(text: "IM未登录成功"); return}
let conversation = YWTribeConversation.fetch(by: tribute, createIfNotExist: true, baseContext: SPKitExample.sharedInstance().ywIMKit.imCore)
weakSelf.vc_Chat = SPKitExample.sharedInstance().exampleMakeConversationViewController(with: conversation)
weakSelf.vc_Chat.viewDidLoadBlock = { [weak self] in
guard let strongSelf = self else{return}
//这里是个例子,比如需求和微信类似,点右侧导航进群聊信息,则可这样自定义,进入自己的页面进行查看群信息和修改.
let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 40))
btn.setImage(UIImage.init(named: "群聊人员"), for: .normal)
btn.addTarget(strongSelf, action: #selector(strongSelf.rightNavBtnClick), for: .touchUpInside)
strongSelf.vc_Chat?.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: btn)
}
weakSelf.vc_Chat.viewWillAppearBlock = { [weak self] (animated: Bool) in
//在这里可以进行请求数据刷新导航等问题
guard let strongSelf = self else{return}
strongSelf.requestGroupPersonMessage(isRefreshData: true)
}
strongSelf.navigationController?.pushViewController(weakSelf.vc_Chat, animated: true)
}
```
注: 如果需要自定义,则需要将聊天控制器作为当前类的属性,既上面的**vc_Chat**,这样可以在聊天页面进行push等操作,否则push等操作会在聊天前的页面.

- 会话列表,因为聊天内容涉及图片 表情等,自己做起来复杂,可以直接使用百川的会话列表.

```
vc_ChatList = SPKitExample.sharedInstance().exampleMakeConversationListController { [weak self](conversation) in //点击会话列表对应会话.可跳转对应的聊天页面

guard let strongSelf = self else{return}
//根据会话类可判断选中的会话是单聊还是群聊
if conversation?.conversationType == .P2P{
strongSelf.type_IsGroup = false
}else{
strongSelf.type_IsGroup = true
}

strongSelf.vc_Chat = SPKitExample.sharedInstance().exampleMakeConversationViewController(with: conversation) 
SPKitExample.sharedInstance().ywIMKit.imCore.getContactService().enableContactOnlineStatus = true //显示用户是否在线 默认为NO既默认都显示在线

strongSelf.vc_Chat.viewDidLoadBlock = {
//自定义事件
}
strongSelf.navigationController?.pushViewController(weakSelf.vc_Chat, animated: true)
}
```
#### 4. 自定义操作
参考文档中心的快速集成和上述的过程,一个单聊 群聊等功能就做出来了,但有时候会遇到产品的一些自定义需求,比如打开页面发一个商品信息等需求,这时候就需要自定义一个消息了.

这个我已发商品信息消息详细说下,因为我在做的时候查找了很多资料,发现没有这方面的,就自己一个个坑踩了出来,实现了需求,我相信介绍下给大家,希望大家遇到相关需求可以轻松实现.

- 首先,大家在集成的时候除非自己强迫症或者需要重写胶水代码,否则使用DEMO中的胶水代码即可, 里面有具体的初始化,登录,自定义等操作,直接使用即可,而自定义消息就在胶水代码中.

![5632A2B3-D836-4C86-9826-B77EAF2AC076.png](https://upload-images.jianshu.io/upload_images/8283020-e1d88a15b3d06e75.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

如上图所示,打码的是我自定义的消息,上面两个就是系统自带的自定义消息是空的,CallingCard和Greeting是系统自定义的打招呼和发名片消息,在自定义的时候可以参考.

- 自定义消息ViewModel
```

#import <WXOUIModule/YWUIFMWK.h>
#import <WXOpenIMSDKFMWK/YWFMWK.h>

@interface 类名 : YWBaseBubbleViewModel

- (instancetype)initWithMessage:(id<IYWMessage>)aMessage;

/// 自定义消息体
@property (nonatomic, strong, readonly) YWMessageBodyCustomize *bodyCustomize;

@end
```

```
#import "TSBuyOrSaleChatModel.h"

@interface TSBuyOrSaleChatModel ()

/// 自定义消息体
@property (nonatomic, strong, readwrite) YWMessageBodyCustomize *bodyCustomize;

@end

@implementation TSBuyOrSaleChatModel

- (instancetype)initWithMessage:(id<IYWMessage>)aMessage
{
self = [super init];

if (self) {
/// 初始化

/// 记录消息体，您也可以不记录原始消息体，而是将数据解析后，记录解析后的数据
self.bodyCustomize = (YWMessageBodyCustomize *)[aMessage messageBody];

/// 设置气泡类型
//        self.bubbleStyle = [aMessage outgoing] ? BubbleStyleCommonRight : BubbleStyleCommonLeft;
self.bubbleStyle = BubbleStyleNone; //修改为不显示气泡, 一般发送商品信息不需要气泡和头像,这里设置为none,则没有气泡和头像
}

return self;
}

#pragma mark -


@end
```

- 自定义消息view
```
#import <WXOUIModule/YWUIFMWK.h>

@interface 类名 : YWBaseBubbleChatView

@end
```

```
#import "TSBuyOrSaleChatViewCustomize.h"

#import "TSBuyOrSaleChatModel.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"

@interface TSBuyOrSaleChatViewCustomize ()

@property (nonatomic, strong) UILabel*label; 

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
//在这里进行初始化页面操作

}

return self;
}


/// 计算尺寸，更新显示
- (CGSize)_calculateAndUpdateFitSize
{
//这里可以解析上面自定义的ViewModel传递的content内容,一般都是JSON转为的字符串,这里可以转为字典进行使用
NSString *content = self.viewModel.bodyCustomize.content;

NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];

NSError *err;
NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
options:NSJSONReadingMutableContainers
error:&err];
if(err){
NSLog(@"json解析失败：%@",err);
}


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
return NSStringFromClass([对应的viewmodel类名 class]);
}


@end

```
注意: 在m文件中要引入**自定义的ViewModel**.

- **发送自定义消息**
```

/// 构建一个自定义消息
var contentDictionary: [String: Any]
contentDictionary = dict //自己的json数据
contentDictionary["customizeMessageType"] = "CustomerChatMessage" //注 这个是必须有的,用于区分不同的自定义消息,key customizeMessageType是胶水代码里固定的,直接使用即可
//将数据转为字符串 通过消息体发送
let data = try? JSONSerialization.data(withJSONObject: contentDictionary, options: [])

let content = String.init(data: data!, encoding: String.Encoding.utf8)

let body = YWMessageBodyCustomize.init(messageCustomizeContent: content, summary: str_Msg)

/// 发送该自定义消息
vc_Chat.conversation.asyncSend(body, progress: { (progres, str) in

}) { (error, messageID) in

}
```
- 自定义消息
在创建聊天页面,使用的胶水代码exampleMakeConversationViewControllerWithConversation方法中有自定义消息.
```
/// 添加自定义表情
[self exampleShowCustomEmotionWithConversationController:conversationController];
```

根据自定义字段返回自己的ViewModel.
```

NSString *messageType = contentDictionary[kSPCustomizeMessageType];
if ([messageType isEqualToString:@"CallingCard"]) {
SPCallingCardBubbleViewModel *viewModel = [[SPCallingCardBubbleViewModel alloc] initWithMessage:message];
return viewModel;
}
else if ([messageType isEqualToString:@"Greeting"]) {
SPGreetingBubbleViewModel *viewModel = [[SPGreetingBubbleViewModel alloc] initWithMessage:message];
return viewModel;

}else if ([messageType isEqualToString:@"CustomerChatMessage"]){
TSBuyOrSaleChatModel *viewModel = [[TSBuyOrSaleChatModel alloc] initWithMessage:message]; //这里的字段为发消息时候自定义的字段, ViewModel为自定义的消息Model.
return viewModel;
}else{
SPBubbleViewModelCustomize *viewModel = [[SPBubbleViewModelCustomize alloc] initWithMessage:message];
return viewModel;
}
```
根据ViewModel使用对应的自定义消息View
```
/// ChatView一般从ViewModel中获取已经解析的数据，用于显示
[aConversationController setHook4BubbleView:^YWBaseBubbleChatView *(YWBaseBubbleViewModel *viewModel) {
#if HAS_PRIVATEIMAGE
{
YWBaseBubbleChatView *cv = [[SPLogicBizPrivateImage sharedInstance] handleShowModel:viewModel];
if (cv) {
return cv;
}
}
#endif
if ([viewModel isKindOfClass:[SPCallingCardBubbleViewModel class]]) {
SPCallingCardBubbleChatView *chatView = [[SPCallingCardBubbleChatView alloc] init];
return chatView;
}
else if ([viewModel isKindOfClass:[SPGreetingBubbleViewModel class]]) {
SPGreetingBubbleChatView *chatView = [[SPGreetingBubbleChatView alloc] init];
return chatView;
}
else if ([viewModel isKindOfClass:[SPBubbleViewModelCustomize class]]) {
SPBaseBubbleChatViewCustomize *chatView = [[SPBaseBubbleChatViewCustomize alloc] init];
return chatView;
}
else if ([viewModel isKindOfClass:[TSBuyOrSaleChatModel class]]) {
TSBuyOrSaleChatViewCustomize *chatView = [[TSBuyOrSaleChatViewCustomize alloc] init];
return chatView; //这个为自定义view
}
return nil;
}];
```
**注**: 这里使用的是创建会话的胶水代码,所以为了保证消息在不同的页面都可以看到,要保证创建会话都用的这个胶水代码,既可根据会话创建,使用我上面代码中的创建方法即可.

其它自定义需求,比如导航颜色,消息颜色,默认图片等可参考文档中[自定义](http://baichuan.taobao.com/docs/doc.htm?spm=a3c0d.7629140.0.0.Zt4jBM&treeId=41&articleId=103412&docType=1).
![61122FD7-330A-4713-8398-9E2237B9A140.png](https://upload-images.jianshu.io/upload_images/8283020-ffdece518c3822ae.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


#### 5.总结
写到这里,相信对于百川即时通讯已经满足大部分人的需求了,单聊,群聊,会话列表,自定义等操作都可以实现.我在集成过程中遇到了一些坑在上面有的我已经在对于过程中一一说明出来了,有遇到对应过程问题的,可以再次看下上面过程中**注**的坑和代码中的注意地方,这些都很重要,是我自己根据自己经验总结的,希望对大家有所帮助.

最后给大家推荐一个论坛,里面有大部分集成的问题,可以在里面找到对应的方法,官方的里面没几个人回答,比较坑...
[集成问题解决方案汇总](http://im.taobao.com/faqs/ios/output/faqs.html),大部分问题都能在该处找到解决方案. 另在集成过程中有别的问题可以给我评论和留言,我看到后会第一时间回复. 如果对你有所帮助,喜欢的话,不妨给我一个小小的喜欢和关注哈!


