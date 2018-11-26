//
//  MTChatEnums.swift
//  MTChat
//
//  Created by IT A on 2018/11/26.
//  Copyright © 2018 IT A. All rights reserved.
//

import Foundation

public struct MTChatEnums {
    
    public enum KeyboardType: Int {
        case noting
        case voice
        case text
        case emotion
        case more
    }
    
    public enum MoreType {
        case pic        // 照片
        case camera     // 相机
        case wallet     // 红包
        case sight      // 小视频
        case video      // 视频聊天
        case pay        // 转账
        case location   // 位置
        case myfav      // 收藏
        case friendCard // 个人名片
        case voiceInput // 语音输入
        case coupons    // 卡券
    }
    
}
