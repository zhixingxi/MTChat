//
//  MTChatNoticeName.swift
//  MTChat
//
//  Created by IT A on 2018/11/26.
//  Copyright © 2018 IT A. All rights reserved.
//

import Foundation

public struct MTChatNoticeName {
    /// 开始长按录音q按钮
    public static let btRecordLongTapBegan = NSNotification.Name("btRecordLongTapBegan")
    /// 录音按钮长按平移
    public static let btRecordLongTapMove = NSNotification.Name("btRecordLongTapMove")
    /// 录音按钮长按结束
    public static let btRecordLongTapEnd = NSNotification.Name("btRecordLongTapEnd")
}

