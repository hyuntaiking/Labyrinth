//
//  Ball.swift
//  Labyinth
//
//  Created by Hyuntai on 2017/7/17.
//  Copyright © 2017年 hyphen. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

class Ball {
    var image: UIImage?
    // 起始點
    var start  = CGPoint(x: 0, y: 0)
    var isHidden = false
    // 以下為移動中座標
    var origin = CGPoint(x: 0, y: 0)
    var size = CGSize(width: 0, height: 0)
    var center: CGPoint {
        get {
            let centerX = origin.x + (size.width / 2)
            let centerY = origin.y + (size.height / 2)
            return CGPoint(x: centerX, y: centerY)
        }
        set(newCenter) {
            origin.x = newCenter.x - (size.width / 2)
            origin.y = newCenter.y - (size.height / 2)
        }
    }
    init(image: UIImage) {
        self.image = image
        size.width  = image.size.width
        size.height = image.size.height
    }
}
