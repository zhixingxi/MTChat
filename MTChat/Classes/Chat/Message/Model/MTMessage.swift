//
//  MTMessage.swift
//  MTChat
//
//  Created by IT A on 2018/11/28.
//  Copyright © 2018 IT A. All rights reserved.
//

import UIKit

@objc class MTMessage: NSObject {
    @objc dynamic var msgStatus: MTChatEnums.MessageStatus = .msgInit
}

extension MTMessage: MTMessageProtocol {
    func getMsgType() -> MTChatEnums.MessageType {
        return .text
    }
    
    func getTextConten() -> NSMutableAttributedString? {
        return NSMutableAttributedString(string: "共")
    }
    
    func getMsgStatus() -> MTChatEnums.MessageStatus {
        return .msgInit
    }
    
    func getUser() -> MTUserType? {
        return nil
    }
    
    /// 是否是自己发的消息
    func isMine() -> Bool {
        return false
    }
}
