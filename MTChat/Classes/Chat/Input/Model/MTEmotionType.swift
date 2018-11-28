//
//  MTEmotionType.swift
//  MTChat
//
//  Created by IT A on 2018/11/27.
//  Copyright © 2018 IT A. All rights reserved.
//

import Foundation
import UIKit

protocol MTEmotionType {
    
    func isRemove() -> Bool
    func isEmpty() -> Bool
    func imagePath() -> String?
    var getText: String? { get }
}
