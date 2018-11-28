//
//  MTChatControllerViewController.swift
//  MTChat
//
//  Created by IT A on 2018/11/27.
//  Copyright © 2018 IT A. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class MTChatController: UIViewController {
    //MARK: - Property
    /// 决定是否停止录
    var finishRecordingVoice: Bool = true
    /// 用户模型
    var user: MTUserType?

    /// 输入栏控制器
    lazy var chatBarVC: MTChatBarController = { [unowned self] in
        let barVC = MTChatBarController(user: self.user)
        self.view.addSubview(barVC.view)
        barVC.view.snp.makeConstraints { (make) in
            make.left.right.width.equalTo(self.view)
            make.bottom.equalTo(self.view.snp.bottom)
            make.height.equalTo(MTInputBarConstant.barOriginHeight)
        }
        barVC.delegate = self
        return barVC
    }()
    /// 消息展示控制器
    lazy var chatMsgVC: MTChatMessageController = { [unowned self] in
        let msgVC = MTChatMessageController()
        msgVC.delegate = self
        self.view.addSubview(msgVC.view)
        msgVC.view.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self.view)
            make.bottom.equalTo(self.chatBarVC.view.snp.top)
        }
        return msgVC
    }()
    
    // MARK: 表情面板
    lazy var emotionView: MTChatEmotionView = { [unowned self] in
        let emotionV = MTChatEmotionView()
        emotionV.delegate = self.chatBarVC
        return emotionV
    }()
    // MARK: 更多面板
    lazy var moreView: MTChatMoreView = { [unowned self] in
        let moreV = MTChatMoreView()
        moreV.delegate = self.chatBarVC
        return moreV
    }()
    // MARK: 录音视图
    lazy var recordVoiceView: MTChatVoiceView = {
        let recordVoiceV = MTChatVoiceView()
        recordVoiceV.isHidden = true
        return recordVoiceV
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = MTChatColors.commonBgColor
        setupViews()
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    override func viewDidDisappear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    deinit {
        MTLog("释放")
    }
}

// MARK: - 初始化
extension MTChatController {
    private func setupViews() {
        navigationItem.title = user?.getTitle()
        
        addChild(chatBarVC)
        addChild(chatMsgVC)
        // 添加表情面板和更多面板
        view.addSubview(emotionView)
        view.addSubview(moreView)
        view.addSubview(recordVoiceView)
        // 布局
        // 布局
        emotionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.chatBarVC.view.snp.bottom)
            make.left.right.equalTo(self.view)
            make.height.equalTo(MTInputBarConstant.noTextKeyboardHeight)
        }
        moreView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.height.equalTo(MTInputBarConstant.noTextKeyboardHeight)
            make.top.equalTo(self.emotionView.snp.bottom)
        }
        recordVoiceView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top).offset(100)
            make.bottom.equalTo(self.view.snp.bottom).offset(-100)
            make.left.right.equalTo(self.view)
        }
    }
    
    // 注册通知
    private func registerNote() {
        NotificationCenter.default.addObserver(self, selector: #selector(chatBarRecordBtnLongTapBegan(_:)), name: MTChatNoticeName.btRecordLongTapBegan, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(chatBarRecordBtnLongTapChanged(_ :)), name: MTChatNoticeName.btRecordLongTapMove, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(chatBarRecordBtnLongTapEnded(_ :)), name: MTChatNoticeName.btRecordLongTapEnd, object: nil)
    }
}

// MARK: - actions
extension MTChatController {
    // MARK: 重置barView的位置
    func resetChatBarFrame() {
        if chatBarVC.keyboardType == .voice {
            return
        }
        chatBarVC.resetKeyboard()
        UIApplication.shared.keyWindow?.endEditing(true)
        chatBarVC.view.snp.updateConstraints { (make) in
            make.bottom.equalTo(self.view.snp.bottom)
        }
        UIView.animate(withDuration: MTInputBarConstant.keyboardChangeFrameTime, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    //MARK: - 录音按钮长按事件
    @objc private func chatBarRecordBtnLongTapBegan(_ note : Notification) {
        // LXFLog("长按开始")
        finishRecordingVoice = true
        recordVoiceView.recording()
        //FIXME: - 开始录音
//        LXFWeChatTools.shared.recordVoice()
    }
    @objc private func chatBarRecordBtnLongTapChanged(_ note : Notification) {
        // LXFLog("长按平移")
        let longTap = note.object as! UILongPressGestureRecognizer
        let point = longTap.location(in: self.recordVoiceView)
        if recordVoiceView.point(inside: point, with: nil) {
            recordVoiceView.slideToCancelRecord()
            finishRecordingVoice = false
        } else {
            recordVoiceView.recording()
            finishRecordingVoice = true
        }
    }
    @objc func chatBarRecordBtnLongTapEnded(_ note : Notification) {
        // LXFLog("长按结束")
        if finishRecordingVoice {
            //FIXME: - 停止录音
//            LXFWeChatTools.shared.stopRecordVoice()
        } else {
            //FIXME: - 取消录音
//            LXFWeChatTools.shared.cancelRecordVoice()
        }
        recordVoiceView.endRecord()
    }
}

// MARK: - MTChatBarControllerDelegate
extension MTChatController: MTChatBarControllerDelegate {
    func chatBarShowTextKeyboard() {
        UIView.animate(withDuration: MTInputBarConstant.keyboardChangeFrameTime) {
            self.emotionView.alpha = 0
            self.moreView.alpha = 0
        }
    }
    
    func chatBarShowVoice() {
        
    }
    
    func chatBarShowEmotionKeyboard() {
        self.emotionView.alpha = 1
        self.moreView.alpha = 1
        moreView.snp.updateConstraints { (make) in
            make.top.equalTo(self.emotionView.snp.bottom)
        }
        UIView.animate(withDuration: MTInputBarConstant.keyboardChangeFrameTime) {
            self.view.layoutIfNeeded()
        }
    }
    
    func chatBarShowMoreKeyboard() {
        self.emotionView.alpha = 1
        self.moreView.alpha = 1
        moreView.snp.updateConstraints { (make) in
            make.top.equalTo(self.emotionView.snp.bottom).offset(-(MTInputBarConstant.noTextKeyboardHeight))
        }
        UIView.animate(withDuration: MTInputBarConstant.keyboardChangeFrameTime) {
            self.view.layoutIfNeeded()
        }
    }
    
    func chatBarUpdateHeight(height: CGFloat) {
        chatBarVC.view.snp.updateConstraints { (make) in
            make.height.equalTo(height)
        }
    }
    
    func chatBarVC(chatBarVC: MTChatBarController, didChageChatBoxBottomDistance distance: CGFloat) {
        MTLog(distance)
        chatBarVC.view.snp.updateConstraints { (make) in
            make.bottom.equalTo(self.view.snp.bottom).offset(-distance)
        }
        UIView.animate(withDuration: MTInputBarConstant.keyboardChangeFrameTime, animations: {
            self.view.layoutIfNeeded()
        })
        
        if distance != 0 {
            chatMsgVC.scrollToBottom()
        }
    }
    
    
}


extension MTChatController: MTChatMessageControllerDelegate {
    func chatMsgVCWillBeginDragging(chatMsgVC: MTChatMessageController) {
        resetChatBarFrame()
    }
    
    
}
