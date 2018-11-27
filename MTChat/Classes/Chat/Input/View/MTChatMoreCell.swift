//
//  MTChatMoreCell.swift
//  MTChat
//
//  Created by IT A on 2018/11/26.
//  Copyright © 2018 IT A. All rights reserved.
//  更多页面 cell

import UIKit

class MTChatMoreCell: UICollectionViewCell {
    
    private var btItem: UIButton!
    private var lbItem: UILabel!

    var type: MTChatEnums.MoreType?
    
    var model: (name: String, icon: UIImage, type: MTChatEnums.MoreType)? {
        didSet {
            self.btItem.setImage(model?.icon, for: .normal)
            self.lbItem.text = model?.name
            self.type = model?.type
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //FIXME: - 是否需要
//        btItem.width = btItem.height
    }
    
    private func setupViews() {
        btItem = UIButton(type: .custom).then({ (bt) in
            bt.backgroundColor = UIColor.white
            bt.isUserInteractionEnabled = false
            bt.layer.cornerRadius = 10
            bt.layer.masksToBounds = true
            bt.layer.borderColor = UIColor.lightGray.cgColor
            bt.layer.borderWidth = 0.5
            contentView.addSubview(bt)
            bt.snp.makeConstraints({ (m) in
                m.top.equalToSuperview().offset(6)
                m.bottom.equalTo(lbItem.snp.top).offset(-5)
                m.width.equalTo(bt.snp.height)
                m.centerX.equalToSuperview()
            })
        })
        
        lbItem = UILabel().then({ (lb) in
            lb.textColor = UIColor.gray
            lb.font = UIFont.systemFont(ofSize: 11.0)
            lb.textAlignment = .center
            contentView.addSubview(lb)
            lb.snp.makeConstraints({ (m) in
                m.left.right.equalToSuperview()
                m.bottom.equalToSuperview().offset(-2)
                m.height.equalTo(21)
            })
        })
    }
}
