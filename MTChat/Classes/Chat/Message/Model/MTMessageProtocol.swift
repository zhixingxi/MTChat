//
//  MTMessageProtocol.swift
//  MTChat
//
//  Created by IT A on 2018/11/28.
//  Copyright © 2018 IT A. All rights reserved.
//  消息模型 协议

import UIKit

protocol MTMessageProtocol: NSObjectProtocol {
    func isMine() -> Bool
    func getMsgStatus() -> MTChatEnums.MessageStatus
    func getUser() -> MTUserType?
}
