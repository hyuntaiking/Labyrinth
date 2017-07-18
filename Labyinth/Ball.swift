//
//  Ball.swift
//  Labyinth
//
//  Created by Hyuntai on 2017/7/17.
//  Copyright © 2017年 hyphen. All rights reserved.
//

import Foundation
import UIKit

class Ball: UIImageView {
    var start  = CGPoint(x: 0, y: 0)
}
class Stage {
    var image: UIImage?
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    var name: String
    init(name: String, frame: CGRect) {
        image = UIImage(named: name)
        self.frame = frame
        self.name = name
    }
}
