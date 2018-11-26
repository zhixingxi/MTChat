//
//  MTChatBarView.swift
//  MTChat
//
//  Created by IT A on 2018/11/26.
//  Copyright © 2018 IT A. All rights reserved.
//

import UIKit
import SnapKit

protocol MTChatBarViewDelegate: NSObjectProtocol {
    func chatBarShowTextKeyboard()
    func chatBarShowVoice()
    func chatBarShowEmotionKeyboard()
    func chatBarShowMoreKeyboard()
    func chatBarUpdateHeight(height: CGFloat)
    func chatBarSendMessage()
}

/// 输入组件
class MTChatBarView: UIView {

//MARK: - Property
    /// 输入类型
    var keyboardType: MTChatEnums.keyboardType = .noting
    var inputTextViewCurrentHeight = MTInputBarConstant.barOriginHeight
    weak var delegate: MTChatBarViewDelegate?
    /// 语音按钮
    private var btVoice: UIButton!
    /// 表情按钮
    private var btEmotion: UIButton!
    /// 更多按钮
    private var btMore: UIButton!
    /// 输入 UITextView
    private var tvInput: UITextView!
    /// 语音按钮
    private var btRecord: UIButton!
    
//MARK - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - views
extension MTChatBarView {
    private func setupUI() {
        backgroundColor = MTInputBarConstant.keyboardBgColor
        setupVoiceButton()
        setupMoreButton()
        setupEmotionButton()
        setupInputTextView()
        setupRecodButton()
        setupTwoLines()
    }
    
    /// 设置语音按钮
    private func setupVoiceButton() {
        btVoice = UIButton(type: .custom).then({ (bt) in
            bt.setImage(UIImage(named: "ToolViewInputVoice"), for: .normal)
            bt.setImage(UIImage(named: "ToolViewInputVoiceHL"), for: .highlighted)
            addSubview(bt)
            bt.snp.makeConstraints({ (m) in
                m.left.equalToSuperview().offset(5)
                m.width.height.equalTo(35)
                m.bottom.equalToSuperview().offset(-7)
            })
        })
    }
    
    /// 设置更多按钮
    private func setupMoreButton() {
        btMore = UIButton(type: .custom).then({ (bt) in
            bt.setImage(UIImage(named: "TypeSelectorBtn_Black"), for: .normal)
            bt.setImage(UIImage(named: "TooTypeSelectorBtnHL_BlacklViewEmotionHL"), for: .highlighted)
            addSubview(bt)
            bt.snp.makeConstraints({ (m) in
                m.right.equalToSuperview().offset(-5)
                m.width.height.equalTo(35)
                m.bottom.equalToSuperview().offset(-7)
            })
        })
    }
    
    /// 设置表情按钮
    private func setupEmotionButton() {
        btEmotion = UIButton(type: .custom).then({ (bt) in
            bt.setImage(UIImage(named: "ToolViewEmotion"), for: .normal)
            bt.setImage(UIImage(named: "ToolViewEmotionHL"), for: .highlighted)
            addSubview(bt)
            bt.snp.makeConstraints({ (m) in
                m.right.equalTo(btMore.snp.left)
                m.width.height.equalTo(35)
                m.bottom.equalTo(self.snp.bottom).offset(-7)
            })
        })
    }
    /// 设置输入框
    private func setupInputTextView() {
        tvInput = UITextView().then({ (tv) in
            tv.font = UIFont.systemFont(ofSize: 15.0)
            tv.textColor = UIColor.black
            tv.returnKeyType = .send
            tv.enablesReturnKeyAutomatically = true
            //inputV.textContainerInset = UIEdgeInsetsMake(8, 5, 8, 5)
            tv.layer.cornerRadius = 4.0
            tv.layer.masksToBounds = true
            tv.layer.borderColor = MTChatColors.splitLineColor.cgColor
            tv.layer.borderWidth = 0.5
            tv.delegate = self
            tv.addObserver(self, forKeyPath: "attributedText", options: .new, context: nil)
            addSubview(tv)
            tv.snp.makeConstraints({ (m) in
                m.left.equalTo(btVoice.snp.right).offset(7)
                m.right.equalTo(btEmotion.snp.left).offset(-7)
                m.top.equalToSuperview().offset(7)
                m.bottom.equalToSuperview().offset(-7)
            })
        })
    }
    
    private func setupRecodButton() {
        btRecord = UIButton(type: .custom).then({ (bt) in
            bt.setTitle("按住 说话", for: .normal)
            bt.setTitle("松开 结束", for: .highlighted)
            bt.setBackgroundImage(UIColor.hexInt(0xF3F4F8).transToImage(), for: .normal)
            bt.setBackgroundImage(UIColor.hexInt(0xC6C7CB).transToImage(), for: .highlighted)
            bt.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
            bt.setTitleColor(UIColor.black, for: .normal)
            bt.setTitleColor(UIColor.black, for: .highlighted)
            bt.layer.cornerRadius = 4.0
            bt.layer.masksToBounds = true
            bt.layer.borderColor = MTChatColors.splitLineColor.cgColor
            bt.layer.borderWidth = 0.5
            bt.isHidden = true
            addSubview(bt)
            bt.snp.makeConstraints({ (m) in
                m.left.equalTo(btVoice.snp.right).offset(7)
                m.right.equalTo(btEmotion.snp.left).offset(-7)
                m.height.equalTo(35)
                m.centerY.equalTo(self.snp.centerY)
            })
        })
    }
    
    private func setupTwoLines() {
        for i in 0..<2 {
            let line = UIView()
            line.backgroundColor = MTChatColors.splitLineColor
            addSubview(line)
            line.snp.makeConstraints { (m) in
                m.left.right.equalToSuperview()
                m.height.equalTo(0.5)
                if i == 0 {
                    m.top.equalToSuperview()
                } else {
                    m.bottom.equalToSuperview()
                }
            }
        }
    }
    
}

// MARK: - UITextViewDelegate
extension MTChatBarView: UITextViewDelegate {
    
}


