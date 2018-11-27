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
    var keyboardType: MTChatEnums.KeyboardType = .noting
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
    
// MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    deinit {
        tvInput.removeObserver(self, forKeyPath: "attributedText")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- 初始化事件
extension MTChatBarView {
    /// 语音按钮长按
    @objc private func btRecordLongTap(_ longTap: UILongPressGestureRecognizer) {
        if longTap.state == .began {    // 长按开始
            NotificationCenter.default.post(name: MTChatNoticeName.btRecordLongTapBegan, object: longTap)
            self.replaceRecordBtnUI(isRecording: true)
        } else if longTap.state == .changed {   // 长按平移
            NotificationCenter.default.post(name: MTChatNoticeName.btRecordLongTapMove, object: longTap)
        } else if longTap.state == .ended { // 长按结束
            NotificationCenter.default.post(name: MTChatNoticeName.btRecordLongTapEnd, object: longTap)
            self.replaceRecordBtnUI(isRecording: false)
        }
    }
    
    // 切换 录音按钮的UI
    private func replaceRecordBtnUI(isRecording: Bool) {
        if isRecording {
            btRecord.setBackgroundImage(UIColor.hexInt(0xC6C7CB).transToImage(), for: .normal)
            btRecord.setBackgroundImage(UIColor.hexInt(0xF3F4F8).transToImage(), for: .highlighted)
            btRecord.setTitle("松开 结束", for: .normal)
            btRecord.setTitle("按住 说话", for: .highlighted)
        } else {
            btRecord.setBackgroundImage(UIColor.hexInt(0xF3F4F8).transToImage(), for: .normal)
            btRecord.setBackgroundImage(UIColor.hexInt(0xC6C7CB).transToImage(), for: .highlighted)
            btRecord.setTitle("按住 说话", for: .normal)
            btRecord.setTitle("松开 结束", for: .highlighted)
        }
    }
    /// 语音按钮
    @objc private func btVoiceClick(_ sender: UIButton) {
        MTLog("btVoiceClick")
        resetButtonsUI()
        if keyboardType == .voice {
            keyboardType = .text
            tvInput.isHidden = false
            btRecord.isHidden = true
            tvInput.becomeFirstResponder()
        } else {
            keyboardType = .voice
            tvInput.resignFirstResponder()
            tvInput.isHidden = true
            btRecord.isHidden = false
            
            btVoice.setImage(UIImage(named: "ToolViewKeyboard"), for: .normal)
            btVoice.setImage(UIImage(named: "ToolViewKeyboardHL"), for: .highlighted)
            
            // 调用代理方法
            delegate?.chatBarShowVoice()
            // 改变键盘高度为正常
            delegate?.chatBarUpdateHeight(height: MTInputBarConstant.barOriginHeight)
        }
    }
    /// 表情按钮
    @objc private func btEmotionClick(_ sender: UIButton) {
        MTLog("btEmotionClick")
        resetButtonsUI()
        if keyboardType == .emotion { // 正在显示表情键盘
            keyboardType = .text
            tvInput.becomeFirstResponder()
        } else {
            if keyboardType == .voice {
                btRecord.isHidden = true
                tvInput.isHidden = false
                // textViewDidChange
            } else if keyboardType == .text {
                tvInput.resignFirstResponder()
            }
            
            keyboardType = .emotion
            tvInput.resignFirstResponder()
            
            btEmotion.setImage(UIImage(named: "ToolViewKeyboard"), for: .normal)
            btEmotion.setImage(UIImage(named: "ToolViewKeyboardHL"), for: .highlighted)
            
            // 调用代理方法
            delegate?.chatBarShowEmotionKeyboard()
        }
    }
    /// 更多按钮
    @objc private func btMoreClick(_ sender: UIButton) {
        MTLog(btMoreClick)
        resetButtonsUI()
        if keyboardType == .more { // 正在显示更多键盘
            keyboardType = .text
            tvInput.becomeFirstResponder()
        } else {
            if keyboardType == .voice {
                btRecord.isHidden = true
                tvInput.isHidden = false
                // textViewDidChange
            } else if keyboardType == .text {
                tvInput.resignFirstResponder()
            }
            keyboardType = .more
            // inputTextView.resignFirstResponder()
            
            btMore.setImage(UIImage(named: "ToolViewKeyboard"), for: .normal)
            btMore.setImage(UIImage(named: "ToolViewKeyboardHL"), for: .highlighted)
            // 调用代理方法
            delegate?.chatBarShowMoreKeyboard()
        }
    }
}

// MARK:- 初始化UI
extension MTChatBarView {
    private func setupUI() {
        backgroundColor = MTChatColors.keyboardBgColor
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
            bt.addTarget(self, action: #selector(btVoiceClick(_:)), for: .touchUpInside)
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
            bt.setImage(UIImage(named: "TypeSelectorBtnHL_Black"), for: .highlighted)
            bt.addTarget(self, action: #selector(btMoreClick(_:)), for: .touchUpInside)
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
            bt.addTarget(self, action: #selector(btEmotionClick(_:)), for: .touchUpInside)
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
            let longTap = UILongPressGestureRecognizer(target: self, action: #selector(btRecordLongTap(_:)))
            bt.addGestureRecognizer(longTap)
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

// MARK: - 改变 UI
extension MTChatBarView {
    private func resetButtonsUI() {
        btVoice.setImage(UIImage(named: "ToolViewInputVoice"), for: .normal)
        btVoice.setImage(UIImage(named: "ToolViewInputVoiceHL"), for: .highlighted)
        
        btEmotion.setImage(UIImage(named: "ToolViewEmotion"), for: .normal)
        btEmotion.setImage(UIImage(named: "ToolViewEmotionHL"), for: .highlighted)
        
        btMore.setImage(UIImage(named: "TypeSelectorBtn_Black"), for: .normal)
        btMore.setImage(UIImage(named: "TypeSelectorBtnHL_Black"), for: .highlighted)
        
        // 时刻修改barView的高度
        self.textViewDidChange(tvInput)
    }
}

// MARK: - UITextViewDelegate
extension MTChatBarView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        resetButtonsUI()
        
        keyboardType = .text
        
        // 调用代理方法
        delegate?.chatBarShowTextKeyboard()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        var height = textView.sizeThatFits(CGSize(width: textView.width, height: CGFloat(Float.greatestFiniteMagnitude))).height
        height = height > MTInputBarConstant.barTextViewHeight ? height : MTInputBarConstant.barTextViewHeight
        height = height < MTInputBarConstant.barTextViewMaxHeight ? height : textView.height
        inputTextViewCurrentHeight = height + MTInputBarConstant.barOriginHeight - MTInputBarConstant.barTextViewHeight
        if inputTextViewCurrentHeight != textView.height {
            UIView.animate(withDuration: 0.05, animations: {
                // 调用代理方法
                self.delegate?.chatBarUpdateHeight(height: self.inputTextViewCurrentHeight)
            })
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            MTLog("发送")
            delegate?.chatBarSendMessage()
            return false
        }
        return true
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        MTLog("文字改变")
        tvInput.scrollRangeToVisible(NSMakeRange(tvInput.text.count, 1))
        self.textViewDidChange(tvInput)
    }
}


