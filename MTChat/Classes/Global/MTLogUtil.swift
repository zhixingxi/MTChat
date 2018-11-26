//
//  MTLogUtil.swift
//  MTChat
//
//  Created by IT A on 2018/11/26.
//  Copyright © 2018 IT A. All rights reserved.
//

import Foundation
public func MTLog<T>(_ message: T,
                     file: String = #file,
                     method: String = #function,
                     line: Int = #line,
                     time: Date = Date())
{
    #if DEBUG
    print("YKLog: [\(time)], \((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    #endif
}
