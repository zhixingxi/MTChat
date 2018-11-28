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
        case redpacket     // 红包
        case sight      // 小视频
        case video      // 视频聊天
        case pay        // 转账
        case location   // 位置
        case myfav      // 收藏
        case friendCard // 个人名片
        case voiceInput // 语音输入
        case coupons    // 卡券
    }
    
    /// 消息类型
    public enum MessageType: Int {
        case text //文字
        case image //图片
        case voice //语音
        case redpacket //红包
        case time //时间
    }
    
    @objc public enum MessageStatus: Int {
        case msgInit = 0 // 初始化
        case sending = 1 //发送中
        case sendSuccess = 2 // 发送成功
        case sendFailed = 3 // 发送失败
    }
}
