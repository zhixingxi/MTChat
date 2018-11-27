
//
//  UITextViewExtension.swift
//  MTChat
//
//  Created by IT A on 2018/11/27.
//  Copyright © 2018 IT A. All rights reserved.
//

import UIKit

class MTChatEmotionAttachment: NSTextAttachment {
    var text: String?
}

extension UITextView {
    // MARK:- 获取textView属性字符串,换成对应的表情字符串
    func getEmotionString() -> String {
        let attrMStr = NSMutableAttributedString(attributedString: attributedText)
        
        let range = NSRange(location: 0, length: attrMStr.length)
        
        attrMStr.enumerateAttributes(in: range, options: []) { (dict, range, _) in
            if let attachment = dict[NSAttributedString.Key.attachment] as?MTChatEmotionAttachment {
                attrMStr.replaceCharacters(in: range, with: attachment.text!)
            }
        }
        return attrMStr.string
    }
    
    func insertEmotion(emotion: MTEmotionType) {
        // 空白
        if emotion.isEmpty() {
            return
        }
        // 删除
        if emotion.isRemove() {
            deleteBackward()
            return
        }
        // 表情
        let attachment = MTChatEmotionAttachment()
        attachment.text = emotion.getText
        attachment.image = UIImage(contentsOfFile: emotion.imagePath()!)
        let font = self.font!
        attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
        let attrImageStr = NSAttributedString(attachment: attachment)
        
        let attrMStr = NSMutableAttributedString(attributedString: attributedText)
        let range = selectedRange
        attrMStr.replaceCharacters(in: range, with: attrImageStr)
        attributedText = attrMStr
        self.font = font
        selectedRange = NSRange(location: range.location + 1, length: 0)
    }
}
