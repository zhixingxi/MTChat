//
//  MTChatEmotionCell.swift
//  MTChat
//
//  Created by IT A on 2018/11/27.
//  Copyright © 2018 IT A. All rights reserved.
//

import UIKit

class MTChatEmotionCell: UICollectionViewCell {
    
    var emotion: MTEmotionType? {
        didSet {
            guard let emo = emotion else {
                return
            }
            if emo.isRemove() {
                ivEmotion.image = UIImage(named: "DeleteEmoticonBtn")
            } else if emo.isEmpty() {
                ivEmotion.image = UIImage()
            } else {
                guard let imgPath = emo.imagePath() else {
                    return
                }
                ivEmotion.image = UIImage(contentsOfFile: imgPath)
            }
            
        }
    }
    
    private var ivEmotion: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        ivEmotion = UIImageView()
        addSubview(ivEmotion)
        ivEmotion.snp.makeConstraints { (m) in
            m.center.equalToSuperview()
            m.width.height.equalTo(32)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
