//
//  ViewController.swift
//  ALiIMDemo
//
//  Created by yangtao on 2018/5/10.
//  Copyright © 2018年 qeegoo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    fileprivate var vc_Chat: YWConversationViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // MARK: 因项目运行需要对应的账户,这里没办法操作, 所以下面给出集成单聊 群聊 自定义消息等操作的代码, 集成时候直接使用即可, 集成前环境等集成参考.md文档即可
    
    // MARK: 单聊
    func p2pChat() {
        
        let person = YWPerson.init(personId: "对方百川id")
        if SPKitExample.sharedInstance().ywIMKit == nil{print("IM未登录成功"); return}
        let conversation = YWP2PConversation.fetch(by: person, creatIfNotExist: true, baseContext: SPKitExample.sharedInstance().ywIMKit.imCore) //获取单聊会话
        vc_Chat = SPKitExample.sharedInstance().exampleMakeConversationViewController(with: conversation)// 创建会话Controller
        SPKitExample.sharedInstance().ywIMKit.imCore.getContactService().enableContactOnlineStatus = true //显示用户是否在线 默认为NO既默认都显示在线
        vc_Chat?.viewDidLoadBlock = { [weak self] in
            guard let weakSelf = self else{return}
            
            let btn_Pop = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 25, height: 40))
            btn_Pop.setImage(UIImage.init(named: "Back"), for: .normal)
            btn_Pop.addTarget(weakSelf, action: #selector(weakSelf.leftNavBtnClick(btn:)), for: .touchUpInside)
            weakSelf.vc_Chat?.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: btn_Pop)
            
            let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 40))
            btn.setImage(UIImage.init(named: "名片"), for: .normal)
            btn.addTarget(weakSelf, action: #selector(weakSelf.rightNavBtnClick), for: .touchUpInside)
            weakSelf.vc_Chat?.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: btn)
        }
        navigationController?.pushViewController(vc_Chat!, animated: true)
        
    }
    
    // MARK: 群聊
    func groupChat() {
        
        SPKitExample.sharedInstance().ywIMKit.imCore.getTribeService().requestTribe(fromServer: "群id") { [weak self](tribute, error) in
            guard let weakSelf = self else{return}
            if SPKitExample.sharedInstance().ywIMKit == nil{print("IM未登录成功"); return}
            let conversation = YWTribeConversation.fetch(by: tribute, createIfNotExist: true, baseContext: SPKitExample.sharedInstance().ywIMKit.imCore)
            weakSelf.vc_Chat = SPKitExample.sharedInstance().exampleMakeConversationViewController(with: conversation)
            weakSelf.vc_Chat.viewDidLoadBlock = { [weak self] in
                guard let weakSelf = self else{return}
                
                weakSelf.vc_Chat.title = "群聊(5)"
                
                let btn_Pop = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 25, height: 40))
                btn_Pop.setImage(UIImage.init(named: "Back"), for: .normal)
                btn_Pop.addTarget(weakSelf, action: #selector(weakSelf.leftNavBtnClick(btn:)), for: .touchUpInside)
                weakSelf.vc_Chat?.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: btn_Pop)
                
                let btn = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 40))
                btn.setImage(UIImage.init(named: "群聊人员"), for: .normal)
                btn.addTarget(weakSelf, action: #selector(weakSelf.rightNavBtnClick), for: .touchUpInside)
                weakSelf.vc_Chat?.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: btn)
            }
            weakSelf.vc_Chat.viewWillAppearBlock = { [weak self] (animated: Bool) in
                guard let weakSelf = self else{return}
                //可更新群成员个数等数据
                
            }
            weakSelf.navigationController?.pushViewController(weakSelf.vc_Chat, animated: true)
        }
        
    }
    
    //发送自定义消息
    func sendCustomerMessage() {
        
        /// 构建一个自定义消息
        var contentDictionary = [String: Any]()
        // customizeMessageType 参考文档 自定义需要设置这个值 区分不同自定义消息
        contentDictionary["customizeMessageType"] = "TSBuyOrSaleDetailCustomerChatMessage"
        //根据具体业务需求赋值 字段自定义 在自定义消息view中 解析
        contentDictionary["detailUrl"] = ""
        contentDictionary["shareUrl"] = ""
        
        let data = try? JSONSerialization.data(withJSONObject: contentDictionary, options: [])
        
        let content = String.init(data: data!, encoding: String.Encoding.utf8)
        
        let body = YWMessageBodyCustomize.init(messageCustomizeContent: content, summary: "在消会话列表显示的内容, 可自定义")
        
        /// 发送该自定义消息
        vc_Chat.conversation.asyncSend(body, progress: { (progres, str) in
            
        }) { (error, messageID) in
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


extension ViewController{
    
    @objc func leftNavBtnClick(btn: UIButton) {
        vc_Chat.navigationController?.popViewController(animated: true)
    }
    
    @objc func rightNavBtnClick() {
        //自定义事件
    }
    
}



