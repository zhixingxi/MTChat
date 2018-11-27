//
//  MTChatBarController.swift
//  MTChat
//
//  Created by IT A on 2018/11/26.
//  Copyright © 2018 IT A. All rights reserved.
//  

import UIKit

//MARK: - protocol
protocol MTChatBarControllerDelegate: NSObjectProtocol {
    func chatBarShowTextKeyboard()
    func chatBarShowVoice()
    func chatBarShowEmotionKeyboard()
    func chatBarShowMoreKeyboard()
    func chatBarUpdateHeight(height: CGFloat)
    func chatBarVC(chatBarVC: MTChatBarController, didChageChatBoxBottomDistance distance: CGFloat)
}


class MTChatBarController: UIViewController {
    
    // 用户模型
    var user: MTUserType?
    
    private var keyboardFrame: CGRect?
    var keyboardType: MTChatEnums.KeyboardType?
    
    lazy var barView : MTChatBarView = { [unowned self] in
        let barView = MTChatBarView()
        barView.delegate = self
        return barView
        }()
    
    weak var delegate: MTChatBarControllerDelegate?
    
    
    // MARK:- init
    init(user: MTUserType?) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(barView)
        barView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(50)
        }
        
        // 监听键盘
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameWillChange(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
}

// MARK:- 对外提供的方法
extension MTChatBarController {
    func resetKeyboard() {
        barView.resetButtonsUI()
        barView.keyboardType = .noting
    }
}

// MARK:- 发送信息
extension MTChatBarController {
    func sendMessage() {
        MTLog("发送文字消息")
        /*
        // 取出字符串
        let message = barView.inputTextView.getEmotionString()
        barView.inputTextView.text = ""
        
        // 发送
        LXFWeChatTools.shared.sendText(userId: user?.userId, text: message)
        LXFLog(message)
 */
    }
}


// MARK:- 键盘监听事件
extension MTChatBarController {
    @objc private func keyboardWillHide(_ note: NSNotification) {
        keyboardFrame = CGRect.zero
        if barView.keyboardType == .emotion || barView.keyboardType == .more {
            return
        }
        delegate?.chatBarVC(chatBarVC: self, didChageChatBoxBottomDistance: 0)
    }
    
    @objc private func keyboardFrameWillChange(_ note: NSNotification) {
        keyboardFrame = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect?
        
        MTLog(keyboardFrame)
        
        if barView.keyboardType == .emotion || barView.keyboardType == .more {
            return
        }
        delegate?.chatBarVC(chatBarVC: self, didChageChatBoxBottomDistance: keyboardFrame?.height ?? 0)
    }
}

// MARK: - MTChatBarViewDelegate
extension MTChatBarController: MTChatBarViewDelegate {
    func chatBarShowTextKeyboard() {
        MTLog("普通键盘")
        keyboardType = .text
        delegate?.chatBarShowTextKeyboard()
        delegate?.chatBarVC(chatBarVC: self, didChageChatBoxBottomDistance: keyboardFrame?.height ?? 0)
    }
    
    func chatBarShowVoice() {
       MTLog("声音")
        keyboardType = .voice
        delegate?.chatBarShowVoice()
        delegate?.chatBarVC(chatBarVC: self, didChageChatBoxBottomDistance: 0)
    }
    
    func chatBarShowEmotionKeyboard() {
        MTLog("表情面板")
        keyboardType = .emotion
        delegate?.chatBarShowEmotionKeyboard()
        delegate?.chatBarVC(chatBarVC: self, didChageChatBoxBottomDistance: MTInputBarConstant.noTextKeyboardHeight)
    }
    
    func chatBarShowMoreKeyboard() {
       MTLog("更多面板")
        keyboardType = .more
        delegate?.chatBarShowMoreKeyboard()
        delegate?.chatBarVC(chatBarVC: self, didChageChatBoxBottomDistance: MTInputBarConstant.noTextKeyboardHeight)
    }
    
    func chatBarUpdateHeight(height: CGFloat) {
        barView.snp.updateConstraints { (make) in
            make.height.equalTo(height)
        }
        delegate?.chatBarUpdateHeight(height: height)
    }
    
    func chatBarSendMessage() {
        MTLog("发送信息")
        sendMessage()
    }
    
    
}

// MARK:- MTChatEmotionViewDelegate
extension MTChatBarController : MTChatEmotionViewDelegate {
    func emotionView(emotionView: MTChatEmotionView, didSelectedEmotion emotion: MTEmotionType) {
        MTLog(emotion)
        
        // 插入表情
        barView.tvInput.insertEmotion(emotion: emotion)
    }
    
    func send(emotionView: MTChatEmotionView) {
        MTLog("发送操作")
        sendMessage()
    }
}

// MARK: - MTChatMoreViewDelegate
extension MTChatBarController: MTChatMoreViewDelegate {
    func chatMoreView(moreView: MTChatMoreView, didSelectedType type: MTChatEnums.MoreType) {
        switch type {
        case .pic:
            let vc = TZImagePickerController(maxImagesCount: 9, columnNumber: 4, delegate: self)
            vc?.allowTakeVideo = false
            vc?.allowPickingVideo = false
            self.present(vc!, animated: true, completion: nil)
        case .camera:
            if hasPermissionToGetCamera() {
                MTLog("相机权限未打开")
            }
            let vc = UIImagePickerController()
            vc.sourceType = UIImagePickerController.SourceType.camera
            vc.delegate = self
            vc.modalPresentationStyle = .custom
            self.present(vc, animated: true, completion: nil)
        default:
            break
        }
    }
    
    
}

extension MTChatBarController: TZImagePickerControllerDelegate {
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool, infos: [[AnyHashable : Any]]!) {
        for _ in photos {
            //FIXME: - 发送图片
            MTLog("发送图片")
        }
    }
}

// MARK: - UIImagePickerControllerDelegate
extension MTChatBarController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let _ = info[UIImagePickerController.InfoKey.originalImage]
        //FIXME: - 发送图片
        MTLog("发送图片")
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func  hasPermissionToGetCamera() -> Bool {
        var hasPermission = false
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if authStatus == .restricted || authStatus == .denied {
            hasPermission = false
        }
        return hasPermission
    }
}
