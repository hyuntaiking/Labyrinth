//
//  ViewController.swift
//  Labyinth
//
//  Created by Hyuntai on 2017/7/17.
//  Copyright © 2017年 hyphen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var myCanvas: MyCanvas!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var accelerometerX: CGFloat = 0
        var accelerometerY: CGFloat = 0
        let refreshSecond: CGFloat = 0.005
        let app = UIApplication.shared.delegate as! AppDelegate
        app.mm.startAccelerometerUpdates(to: OperationQueue(), withHandler: { (data,error)  in
            if let tmp = data?.acceleration {
                //print("(x,y,z) = \(tmp.x),\(tmp.y),\(tmp.z)")
                accelerometerX =  CGFloat(tmp.x) * 2
                accelerometerY = -CGFloat(tmp.y) * 2
            }
            
        })
        
        app.refreshTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(refreshSecond), repeats: true, block: {
            (timer) in
            self.myCanvas.moveBall(ax: accelerometerX, ay: accelerometerY)
        })
    }
}

