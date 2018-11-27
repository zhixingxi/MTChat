//
//  MTEmotionHelp.swift
//  MTChat
//
//  Created by IT A on 2018/11/27.
//  Copyright © 2018 IT A. All rights reserved.
//

import Foundation

struct MTEmotionHelp {
    static func getAllEmotions() -> [MTEmotionType] {
        var emotions: [MTEmotionType] = []
        let plistPath = Bundle.main.path(forResource: "Expression", ofType: "plist")
        let array = NSArray(contentsOfFile: plistPath!) as! [[String : String]]
        var index = 0
        for dict in array {
            emotions.append(MTChatEmotion(dict: dict))
            index += 1
            if index == 23 {
                // 添加删除表情
                emotions.append(MTChatEmotion(isRemove: true))
                index = 0
            }
        }
        // 添加空白表情
        emotions = self.addEmptyEmotion(emotiions: emotions)
        return emotions
    }
    
    // 添加空白表情
    private static func addEmptyEmotion(emotiions: [MTEmotionType]) -> [MTEmotionType] {
        var emos = emotiions
        let count = emos.count % 24
        if count == 0 {
            return emos
        }
        for _ in count..<23 {
            emos.append(MTChatEmotion(isEmpty: true))
        }
        emos.append(MTChatEmotion(isRemove: true))
        return emos
    }
}


