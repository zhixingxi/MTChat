//
//  MTTextMessageCell.swift
//  MTChat
//
//  Created by IT A on 2018/11/28.
//  Copyright © 2018 IT A. All rights reserved.
//

import UIKit

class MTTextMessageCell: MTMessageBaseCell {
    var lbMessage: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//MARK: - 布局
    override func setupLayout() {
        super.setupLayout()
        let margin: CGFloat = 10.0
        let headToBubble: CGFloat = 3;
        let bubblePadding: CGFloat = 8;
        let arrowWidth: CGFloat = 10;
        let isSender = messageModel?.isMine() ?? false
        if isSender {
            ivBubble.snp.makeConstraints { (m) in
                m.top.equalTo(ivAvatar)
                m.right.equalTo(ivAvatar.snp.left).offset(-headToBubble)
                m.left.equalTo(lbMessage.snp.left).offset(-bubblePadding * 2)
                m.bottom.equalToSuperview().offset(-margin)
            }
            
            lbMessage.snp.makeConstraints { (m) in
                m.top.equalTo(ivBubble).offset(bubblePadding)
                m.right.equalTo(ivBubble).offset(-arrowWidth - bubblePadding)
                m.height.greaterThanOrEqualTo(28)
                m.bottom.equalToSuperview().offset(-margin - bubblePadding)
            }
        } else {
            ivBubble.snp.makeConstraints { (m) in
                m.top.equalTo(ivAvatar)
                m.left.equalTo(ivAvatar.snp.right).offset(headToBubble)
                m.right.equalTo(lbMessage.snp.right).offset(bubblePadding * 2)
                m.bottom.equalToSuperview().offset(-margin)
            }
            
            lbMessage.snp.makeConstraints { (m) in
                m.top.equalTo(ivBubble).offset(bubblePadding)
                m.left.equalTo(ivBubble).offset(arrowWidth + bubblePadding)
                m.height.greaterThanOrEqualTo(28)
                m.bottom.equalToSuperview().offset(-margin - bubblePadding)
            }
        }
        lbMessage.setContentHuggingPriority(UILayoutPriority.required, for: .horizontal)
        ivBubble.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
//MARK: - 配置数据
    override func configModel() {
        super.configModel()
        lbMessage.attributedText = messageModel?.getTextConten()
        setupLayout()
    }
}


extension MTTextMessageCell {
    private func setupViews() {
        lbMessage = UILabel().then({ (lb) in
            lb.numberOfLines = 0
            lb.font = UIFont.systemFont(ofSize: 15)
            lb.textColor = UIColor.black
            lb.sizeToFit()
            lb.preferredMaxLayoutWidth = MTMessageConstant.textMsgMaxWidth
            contentView.addSubview(lb)
        })
    }
}
