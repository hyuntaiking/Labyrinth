//
//  MyCanvas.swift
//  Labyinth
//
//  Created by Hyuntai on 2017/7/17.
//  Copyright © 2017年 hyphen. All rights reserved.
//

import UIKit

class MyCanvas: UIView {
    private var context: CGContext?
    private var viewWidth:  CGFloat = 0
    private var viewHeight: CGFloat = 0
    private var isInit = false
    private var ball = Ball(image: UIImage(named: "ball.png")!)
    private var deltaX: CGFloat = 0
    private var deltaY: CGFloat = 0
    
    private var holes:  [CGRect] = []
    private var stages: [CGRect] = []
    private var walls:  [CGRect] = []
    
    
    private func initState(_ rect: CGRect){
        isInit = true
        viewWidth  = rect.size.width
        viewHeight = rect.size.height
        context = UIGraphicsGetCurrentContext()
        // 切換關卡
        //stage1()
        stage2()
    }
    func stage1() {
        // 洞
        holes = []
        holes.append(CGRect(x: viewWidth*1/7, y: viewHeight*0.8/10, width: ball.size.width, height: ball.size.height))
        holes.append(CGRect(x: viewWidth*1/7, y: viewHeight*3.7/10, width: ball.size.width, height: ball.size.height))
        holes.append(CGRect(x: viewWidth*4.5/7, y: viewHeight*3/10, width: ball.size.width, height: ball.size.height))
        holes.append(CGRect(x: viewWidth*4/7, y: viewHeight*5.7/10, width: ball.size.width, height: ball.size.height))
        holes.append(CGRect(x: viewWidth*2/7, y: viewHeight*8.5/10, width: ball.size.width, height: ball.size.height))
        // 過關
        stages = []
        stages.append(CGRect(x: viewWidth*5/7, y: viewHeight*8.2/10, width: ball.size.width, height: ball.size.height))
        
        
        // 牆
        walls = []
        walls.append(CGRect(x: viewWidth*1.8/7, y: viewHeight*2.2/10, width: viewWidth * 5.2/7, height: viewHeight * 0.5/10))
        walls.append(CGRect(x: 0, y: viewHeight*4.5/10, width: viewWidth * 3.6/7, height: viewHeight * 0.5/10))
        walls.append(CGRect(x: viewWidth*5/7, y: viewHeight*4.5/10, width: viewWidth * 2/7, height: viewHeight * 0.5/10))
        walls.append(CGRect(x: viewWidth*1.8/7, y: viewHeight*6.9/10, width: viewWidth * 5.2/7, height: viewHeight * 0.5/10))
        // ball的位置
        ball.center.x = viewWidth * 4/5
        ball.center.y = viewHeight * 1/7
        
        
        // 記錄ball的起始點
        ball.start.x = ball.origin.x
        ball.start.y = ball.origin.y
    }
    func stage2() {
        // 牆
        walls = []
        walls.append(CGRect(x: viewWidth*0/7, y: viewHeight*0/10, width: viewWidth * 7/7, height: viewHeight * 0.4/10))
        walls.append(CGRect(x: viewWidth*0/7, y: viewHeight*9.6/10, width: viewWidth * 7/7, height: viewHeight * 0.4/10))
        walls.append(CGRect(x: viewWidth*0/7, y: viewHeight*0/10, width: viewWidth * 0.4/7, height: viewHeight * 10/10))
        walls.append(CGRect(x: viewWidth*6.6/7, y: viewHeight*0/10, width: viewWidth * 0.4/7, height: viewHeight * 10/10))
        walls.append(CGRect(x: viewWidth*1.4/7, y: viewHeight*0/10, width: viewWidth * 0.35/7, height: viewHeight * 8.8/10))
        walls.append(CGRect(x: viewWidth*1.4/7, y: viewHeight*8.45/10, width: viewWidth * 4.3/7, height: viewHeight * 0.35/10))
        walls.append(CGRect(x: viewWidth*2.8/7, y: viewHeight*1.2/10, width: viewWidth * 2.9/7, height: viewHeight * 0.35/10))
        walls.append(CGRect(x: viewWidth*5.35/7, y: viewHeight*1.2/10, width: viewWidth * 0.35/7, height: viewHeight * 7.6/10))
        walls.append(CGRect(x: viewWidth*2.8/7, y: viewHeight*1.2/10, width: viewWidth * 0.34/7, height: viewHeight * 6.2/10))
        walls.append(CGRect(x: viewWidth*2.8/7, y: viewHeight*7.05/10, width: viewWidth * 1.6/7, height: viewHeight * 0.35/10))
        walls.append(CGRect(x: viewWidth*4.1/7, y: viewHeight*2.6/10, width: viewWidth * 0.35/7, height: viewHeight * 4.8/10))
        
        // 洞
        holes = []
        holes.append(CGRect(x: viewWidth*0.5/7, y: viewHeight*9.1/10, width: ball.size.width, height: ball.size.height))
        holes.append(CGRect(x: viewWidth*6.0/7, y: viewHeight*9.1/10, width: ball.size.width, height: ball.size.height))
        holes.append(CGRect(x: viewWidth*6.0/7, y: viewHeight*0.4/10, width: ball.size.width, height: ball.size.height))
        holes.append(CGRect(x: viewWidth*1.8/7, y: viewHeight*0.4/10, width: ball.size.width, height: ball.size.height))
        holes.append(CGRect(x: viewWidth*1.8/7, y: viewHeight*7.8/10, width: ball.size.width, height: ball.size.height))
        holes.append(CGRect(x: viewWidth*4.7/7, y: viewHeight*7.8/10, width: ball.size.width, height: ball.size.height))
        holes.append(CGRect(x: viewWidth*4.7/7, y: viewHeight*1.6/10, width: ball.size.width, height: ball.size.height))
        holes.append(CGRect(x: viewWidth*3.2/7, y: viewHeight*1.6/10, width: ball.size.width, height: ball.size.height))
        // 過關
        stages = []
        stages.append(CGRect(x: viewWidth*3.3/7, y: viewHeight*6.4/10, width: ball.size.width, height: ball.size.height))
        // ball的位置
        ball.center.x = viewWidth * 1/7
        ball.center.y = viewHeight * 1/10
        
        // 記錄ball的起始點
        ball.start.x = ball.origin.x
        ball.start.y = ball.origin.y
    }
    
    func moveBall(ax:CGFloat,ay:CGFloat) {
        deltaX += ax
        deltaY += ay
        // 撞牆
        let newX = ball.origin.x + deltaX
        let newY = ball.origin.y + deltaY
        if newX < 0 || newX + ball.size.width > viewWidth {
            deltaX = 0
        }
        if newY < 0 || newY + ball.size.height > viewHeight {
            deltaY = 0
        }
        for rect in walls {
            if newX + ball.size.width >= rect.origin.x && newX <= rect.origin.x + rect.size.width &&
                ball.origin.y + ball.size.height >= rect.origin.y && ball.origin.y <= rect.origin.y + rect.size.height {
                deltaX = 0
            }
            if ball.origin.x + ball.size.width >= rect.origin.x && ball.origin.x <= rect.origin.x + rect.size.width &&
                newY + ball.size.height >= rect.origin.y && newY <= rect.origin.y + rect.size.height {
                deltaY = 0
            }
        }
        
        ball.origin.x += deltaX
        ball.origin.y += deltaY
        // 掉進洞
        for rect in holes {
            if ball.center.x >= rect.origin.x && ball.center.x <= rect.origin.x + rect.size.width &&
                ball.center.y >= rect.origin.y && ball.center.y <= rect.origin.y + rect.size.height {
                // 進動動畫
                let imageView = UIImageView(frame: CGRect(x: self.ball.origin.x, y: self.ball.origin.y, width: self.ball.size.width, height: self.ball.size.height))
                imageView.image = self.ball.image
                self.addSubview(imageView)
                UIView.animate(withDuration: 1, animations: {
                    imageView.frame.origin.x = rect.origin.x
                    imageView.frame.origin.y = rect.origin.y
                    imageView.alpha = 0
                    imageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                })
                // Over 回原點重來
                self.ball.origin.x = self.ball.start.x
                self.ball.origin.y = self.ball.start.y
            }
        }
        // 過關
        for rect in stages {
            //print("x:\(rect.origin.x) y:\(rect.origin.y) width:\(rect.size.width) height:\(rect.size.height)")
            if ball.center.x >= rect.origin.x && ball.center.x <= rect.origin.x + rect.size.width &&
                ball.center.y >= rect.origin.y && ball.center.y <= rect.origin.y + rect.size.height {
                // Pass 重來
                let passAlert = UIAlertController(title: "恭喜，過關了", message: "挑戰下一關", preferredStyle: .alert)
                //let okAction = UIAlertAction(title: "重來", style: .destructive, handler: nil)
                let okAction = UIAlertAction(title: "重來", style: .destructive, handler: {
                    (action: UIAlertAction) -> Void in
                    self.ball.origin.x = self.ball.start.x
                    self.ball.origin.y = self.ball.start.y
                    self.ball.isHidden = false
                })
                passAlert.addAction(okAction)
                //self.present(passAlert, animated: true, completion: nil)
                //self.window?.rootViewController?
                self.window?.rootViewController?.present(passAlert, animated: true, completion: nil)
                
                ball.isHidden = true
            }
        }
        setNeedsDisplay()
    }
    
    
    //呈現外觀
    override func draw(_ rect: CGRect) {
        if !isInit{initState(rect)}
        
        
        backgroundColor = UIColor(colorLiteralRed: 1, green: 1, blue: 1, alpha: 1)
        // 畫 Holes
        context?.setFillColor(red: 1, green: 0, blue: 0, alpha: 1)
        for rect in holes {
            //context?.addRect(rect)
            context?.addEllipse(in: rect)
        }
        context?.drawPath(using: .fill)
        // 畫 Stages
        context?.setFillColor(red: 0, green: 1, blue: 0, alpha: 1)
        for rect in stages {
            //context?.addRect(rect)
            context?.addEllipse(in: rect)
        }
        context?.drawPath(using: .fill)
        // 畫 Walls
        context?.setFillColor(red: 0, green: 0, blue: 1, alpha: 1)
        for rect in walls {
            context?.addRect(rect)
        }
        context?.drawPath(using: .fill)
        
        if ball.isHidden == false {
            ball.image?.draw(in: CGRect(x: ball.origin.x, y: ball.origin.y, width: ball.size.width ,height: ball.size.height))
        }
        
    }
}
