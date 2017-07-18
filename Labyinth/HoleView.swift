//
//  HoleDraw.swift
//  Labyinth
//
//  Created by Hyuntai on 2017/7/18.
//  Copyright © 2017年 hyphen. All rights reserved.
//

import UIKit

class HoleView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let ovalPath = UIBezierPath(ovalIn: rect)
        UIColor.red.setFill()
        ovalPath.fill()
    }
}
