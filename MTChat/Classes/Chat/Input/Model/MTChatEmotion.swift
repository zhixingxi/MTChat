//
//  MTChatEmotion.swift
//  MTChat
//
//  Created by IT A on 2018/11/27.
//  Copyright © 2018 IT A. All rights reserved.
//

import Foundation

/// 表情对象
struct MTChatEmotion {
    /// 表情对应的图片名称
    var image: String? {
        didSet {
            imgPath = Bundle.main.bundlePath + "/Expression.bundle/" + image! + ".png"
        }
    }
    /// 表情对应的文字
    var text: String?
    
    var imgPath: String?
    var beRemove: Bool  = false
    var beEmpty: Bool = false
    
    init(dict: [String: String]) {
        self.image = dict["image"]
        self.text = dict["text"]
    }
    
    init(isRemove: Bool) {
        self.beRemove = isRemove
    }
    
    init(isEmpty: Bool) {
        self.beEmpty = isEmpty
    }
}

extension MTChatEmotion: MTEmotionType {
    func isRemove() -> Bool {
        return beRemove
    }
    
    func isEmpty() -> Bool {
        return beEmpty
    }
    
    func imagePath() -> String? {
        return imgPath
    }
}

