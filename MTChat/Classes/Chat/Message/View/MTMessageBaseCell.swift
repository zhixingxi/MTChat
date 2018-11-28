//
//  MTMessageBaseCell.swift
//  MTChat
//
//  Created by IT A on 2018/11/28.
//  Copyright © 2018 IT A. All rights reserved.
//

import UIKit
import Kingfisher

private let avatarHeight: CGFloat = 44.0

protocol MTMessageBaseCellDelegate: NSObjectProtocol {
    
}

class MTMessageBaseCell: UITableViewCell {

    var messageModel: MTMessageProtocol? {
        didSet { configModel() }
    }
    
    var isSender: Bool {
        return messageModel?.isMine() ?? false
    }
    
    var ivAvatar: UIImageView!
    
    var ivBubble: UIImageView!
    
    var vActivity: UIActivityIndicatorView!
    
    var btRetry: UIButton!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        self.backgroundColor = MTChatColors.commonBgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//MARK: - 布局
    func setupLayout() {
        let margin: CGFloat = 10.0
        if isSender {
            ivAvatar.snp.makeConstraints { (m) in
                m.width.height.equalTo(avatarHeight)
                m.top.equalToSuperview().offset(margin)
                m.right.equalToSuperview().offset(-margin)
            }
            
            vActivity.snp.makeConstraints { (m) in
                m.centerY.equalTo(ivBubble)
                m.right.equalTo(ivBubble.snp.left)
                m.width.height.equalTo(40)
            }
            
            btRetry.snp.makeConstraints { (m) in
                m.edges.equalTo(vActivity)
            }
        } else {
            ivAvatar.snp.makeConstraints { (m) in
                m.width.height.equalTo(avatarHeight)
                m.top.equalToSuperview().offset(margin)
                m.left.equalToSuperview().offset(margin)
            }
            vActivity.snp.makeConstraints { (m) in
                m.centerY.equalTo(ivBubble)
                m.left.equalTo(ivBubble.snp.right)
                m.width.height.equalTo(40)
            }
            
            btRetry.snp.makeConstraints { (m) in
                m.edges.equalTo(vActivity)
            }
        }
    }
    
//MARK: -  配置数据
    func configModel() {
        guard let model = messageModel else { return }
        ivAvatar.ykSetImage(with: model.getUser()?.getAvatar())
        let imgName = isSender ? "message_sender_background_normal" : "message_receiver_background_normal"
        ivBubble.image = UIImage.creatImage(imageName: imgName, isSender: isSender)
        // 消息状态
        switch model.getMsgStatus() {
        case .msgInit, .sending:
            btRetry.isHidden = true
            vActivity.isHidden = false
            vActivity.startAnimating()
            self.setupKVO()
        case .sendSuccess:
            btRetry.isHidden = true
            vActivity.isHidden = true
            vActivity.stopAnimating()
        case .sendFailed:
            btRetry.isHidden = false
            self.setupKVO()
        }
        setupLayout()
    }
    
}

// MARK: - KVO
extension MTMessageBaseCell {
    private func setupKVO() {
        guard let msgModel = messageModel as? MTMessage else { return }
        _ = msgModel.observe(\.msgStatus, options: [NSKeyValueObservingOptions.new]) {[weak self] (msg, _) in
            switch msg.msgStatus {
            case .msgInit , .sending:
                self?.vActivity.isHidden = false
                self?.vActivity.startAnimating()
            case .sendSuccess:
                self?.vActivity.isHidden = true
                self?.vActivity.stopAnimating()
            case .sendFailed:
                self?.btRetry.isHidden = false
            }
        }
    }
}

// MARK: - UI
extension MTMessageBaseCell {
    private func setupViews() {
        ivAvatar = UIImageView().then({ (iv) in
            iv.layer.masksToBounds = true
            iv.layer.cornerRadius = avatarHeight * 0.5
            iv.isUserInteractionEnabled = true
            contentView.addSubview(iv)
        })
        
        ivBubble = UIImageView().then({ (iv) in
            iv.isUserInteractionEnabled = true
            contentView.addSubview(iv)
        })
        
        vActivity = UIActivityIndicatorView(style: .gray).then({ (v) in
            v.isHidden = true
            contentView.addSubview(v)
        })
        
        
        btRetry = UIButton(type: .custom).then({ (bt) in
            bt.isHidden = true
            bt.setImage(UIImage(named: "resend"), for: .normal)
            contentView.addSubview(bt)
        })
    }
}



