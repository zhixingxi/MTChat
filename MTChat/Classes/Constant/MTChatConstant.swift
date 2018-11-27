//
//  MTChatConstant.swift
//  MTChat
//
//  Created by IT A on 2018/11/26.
//  Copyright © 2018 IT A. All rights reserved.
//

import Foundation
import UIKit

//MARK: -  尺寸常量
public struct MTUIConstant {
    /// 屏幕宽度
    public static let screenWith = UIScreen.main.bounds.width
    /// 屏幕高度
    public static let screenHeight = UIScreen.main.bounds.height
}

//MARK: -  输入框相关常量
public struct MTInputBarConstant {
    public static let barOriginHeight: CGFloat = 49.0
    public static let barTextViewMaxHeight: CGFloat = 100
    public static let barTextViewHeight: CGFloat = barOriginHeight - 14.0
}

//MARK: -  颜色常量
public struct MTChatColors {
    
    /// 键盘背景色
    public static let keyboardBgColor = UIColor (red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
    /// 分割线颜色
    public static let splitLineColor = UIColor (red: 0.78, green: 0.78, blue: 0.80, alpha: 1.0)
}