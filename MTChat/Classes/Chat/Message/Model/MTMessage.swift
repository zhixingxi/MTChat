//
//  MTMessage.swift
//  MTChat
//
//  Created by IT A on 2018/11/28.
//  Copyright © 2018 IT A. All rights reserved.
//

import UIKit

@objc class MTMessage: NSObject {
    var msgStatus: MTChatEnums.MessageStatus = .msgInit
}

extension MTMessage: MTMessageProtocol {
    func getMsgStatus() -> MTChatEnums.MessageStatus {
        return .msgInit
    }
    
    func getUser() -> MTUserType? {
        return nil
    }
    
    /// 是否是自己发的消息
    func isMine() -> Bool {
        return true
    }
}
