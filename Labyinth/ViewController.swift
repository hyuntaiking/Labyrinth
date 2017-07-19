//
//  ViewController.swift
//  Labyinth
//
//  Created by Hyuntai on 2017/7/17.
//  Copyright © 2017年 hyphen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollisionBehaviorDelegate {
    let app = UIApplication.shared.delegate as! AppDelegate
    var animator: UIDynamicAnimator?
    var gravity: UIGravityBehavior!
    var collision: UICollisionBehavior!
    var accelerometerX = 0.0
    var accelerometerY = 0.0
    let refreshSecond = 0.1
    // 畫面元素
    private var ball: Ball!
    private var stages: [Stage] = []
    private var holes:  [CGRect] = []
    private var goals:  [CGRect] = []
    private var walls:  [CGRect] = []

    // 隱藏最上方的狀態列
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 將螢幕關閉功能取消
        UIApplication.shared.isIdleTimerDisabled = true
        
        //動態行為建構
        animator = UIDynamicAnimator(referenceView: view)
        // 重力
        gravity = UIGravityBehavior()
        animator?.addBehavior(gravity)
        // 碰撞
        collision = UICollisionBehavior()
        collision.translatesReferenceBoundsIntoBoundary = true
        animator?.addBehavior(collision)
        
        //切換關卡
        switchStage(name: "chapter1")
        
        // 啟動加速器取得加速值
        app.mm.startAccelerometerUpdates(to: OperationQueue(), withHandler: { (data,error)  in
            if let tmp = data?.acceleration {
                self.accelerometerX =   tmp.x
                self.accelerometerY =  -tmp.y
            }
        })
        
    }
    // 切換關卡
    func switchStage(name: String) {
        // 清除元素陣列
        clearStageElement()
        
        // 建構關卡元素陣列
        switch name {
        case "stage1_1": stage1_1()
        case "stage1_2": stage1_2()
        default: chapter1()
        }
        
        // 記錄ball的起始點
        ball.start = ball.frame.origin
        
        
        // 畫面元素
        showStageElement()
        
        // 開始循環偵測
        app.refreshTimer = Timer.scheduledTimer(withTimeInterval: refreshSecond, repeats: true, block: {
            (timer) in
            //加上引力
            self.gravity.gravityDirection = CGVector(dx: 2*self.accelerometerX, dy: 2*self.accelerometerY)
            //關卡的判斷
            self.stage(ball: self.ball)
            //進洞的判斷
            self.holl(ball: self.ball)
            //進目標的判斷
            self.goal(ball: self.ball)
        })
        // 加入球
        gravity.addItem(ball)
        collision.addItem(ball)
    }
    func showStageElement() {
        // 清除所有subview
        clearViews()
        // 畫球
        view.addSubview(ball)
        // 畫牆
        for i in 0..<walls.count {
            let wall = UIView(frame: walls[i])
            wall.backgroundColor = UIColor.blue
            view.addSubview(wall)
            collision.addBoundary(withIdentifier: "wall\(i)" as NSCopying,
                                  for: UIBezierPath(rect: wall.frame))
        }
        // 畫洞
        for i in 0..<holes.count {
            let hole = HoleView(frame: holes[i])
            print("W:\(hole.frame.width) H:\(hole.frame.height)")
            view.addSubview(hole)
        }
        // 畫目標
        for i in 0..<goals.count {
            let goal = GoalView(frame: goals[i])
            view.addSubview(goal)
        }
        // 畫關卡
        for i in 0..<stages.count {
            let stage = UIImageView(frame: stages[i].frame)
            stage.image = stages[i].image
            view.addSubview(stage)
        }
        
    }
    func clearViews() {
        for v in self.view.subviews as [UIView] {
            print(v)
            v.removeFromSuperview()
        }
        collision.removeAllBoundaries()
    }
    func clearStageElement() {
        walls  = []
        holes  = []
        goals  = []
        stages = []
    }
    //掉進洞的判斷
    func holl(ball: Ball) {
        for hole in holes {
            if ball.center.x >= hole.origin.x &&
               ball.center.x <= hole.origin.x + hole.size.width &&
               ball.center.y >= hole.origin.y &&
               ball.center.y <= hole.origin.y + hole.size.height {
                gravity.removeItem(ball)
                collision.removeItem(ball)
                
                let imageView = UIImageView(frame: (ball.frame))
                ball.removeFromSuperview()
                
                imageView.image = ball.image
                view.addSubview(imageView)
                
                UIView.animate(withDuration: 1, animations: {
                    imageView.frame.origin.x = hole.origin.x
                    imageView.frame.origin.y = hole.origin.y
                    imageView.alpha = 0
                    //imageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                })
                
                ball.frame.origin = ball.start
                // Sleep 1 Sec
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: {(timer) in
                    self.view.addSubview(self.ball)
                    self.ball.frame.size = CGSize(width: self.view.frame.width*32/375, height: self.view.frame.width*32/375)
                    self.gravity.addItem(self.ball)
                    self.collision.addItem(self.ball)
                })
            }
        }
    }
    //掉進關卡的判斷
    func stage(ball: Ball) {
        for stage in stages {
            if ball.center.x >= stage.frame.origin.x &&
                ball.center.x <= stage.frame.origin.x + stage.frame.width &&
                ball.center.y >= stage.frame.origin.y &&
                ball.center.y <= stage.frame.origin.y + stage.frame.height {
                gravity.removeItem(ball)
                collision.removeItem(ball)
                
                let imageView = UIImageView(frame: (ball.frame))
                ball.removeFromSuperview()
                
                imageView.image = ball.image
                view.addSubview(imageView)
                
                UIView.animate(withDuration: 1, animations: {
                    imageView.frame.origin.x = stage.frame.origin.x
                    imageView.frame.origin.y = stage.frame.origin.y
                    imageView.alpha = 0
                    //imageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                })
                // 切換關卡
                sleep(1)
                self.view.addSubview(self.ball)
                self.gravity.addItem(self.ball)
                self.collision.addItem(self.ball)
                switchStage(name: stage.name)
            }
        }
    }
    //掉進目標的判斷
    func goal(ball: Ball) {
        for goal in goals {
            if ball.center.x >= goal.origin.x &&
                ball.center.x <= goal.origin.x + goal.size.width &&
                ball.center.y >= goal.origin.y &&
                ball.center.y <= goal.origin.y + goal.size.height {
                gravity.removeItem(ball)
                collision.removeItem(ball)
                
                let imageView = UIImageView(frame: (ball.frame))
                ball.removeFromSuperview()
                
                imageView.image = ball.image
                view.addSubview(imageView)
                
                UIView.animate(withDuration: 1, animations: {
                    imageView.frame.origin.x = goal.origin.x
                    imageView.frame.origin.y = goal.origin.y
                    imageView.alpha = 0
                    //imageView.transform = CGAffineTransform(scaleX: 1, y: 1)
                })
                
                //ball.frame.origin = ball.start
                // Sleep 1 Sec
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: {(timer) in
                    //self.view.addSubview(self.ball)
                    self.gravity.addItem(self.ball)
                    self.collision.addItem(self.ball)
                })
                // 暫代替
                switchStage(name: "chapter1")
            }
        }
    }
    func chapter1() {
        // 背景
        view.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)
        // 關卡
        stages.append(Stage(name: "stage1_1",
                            frame: CGRect(x: view.frame.width*4.8/6.8,
                                          y: view.frame.height*10/12.1,
                                          width: view.frame.width*64/375,
                                          height: view.frame.width*64/375)))
        stages.append(Stage(name: "stage1_2",
                            frame: CGRect(x: view.frame.width*3.7/6.8,
                                          y: view.frame.height*7.8/12.1,
                                          width: view.frame.width*64/375,
                                          height: view.frame.width*64/375)))
        stages.append(Stage(name: "stage1_3",
                            frame: CGRect(x: view.frame.width*5.5/6.8,
                                          y: view.frame.height*5.2/12.1,
                                          width: view.frame.width*64/375,
                                          height: view.frame.width*64/375)))
        stages.append(Stage(name: "stage1_4",
                            frame: CGRect(x: view.frame.width*3.5/6.8,
                                          y: view.frame.height*3.2/12.1,
                                          width: view.frame.width*64/375,
                                          height: view.frame.width*64/375)))
        stages.append(Stage(name: "stage1_5",
                            frame: CGRect(x: view.frame.width*4.5/6.8,
                                          y: view.frame.height*1/12.1,
                                          width: view.frame.width*64/375,
                                          height: view.frame.width*64/375)))
        // ball
        ball = Ball(image: UIImage(named: "monkey")!)
        ball.frame.size = CGSize(width: view.frame.width*64/375, height: view.frame.width*64/375)
        ball.center.x = view.frame.width * 2.5/12.1
        ball.center.y = view.frame.width * 2.5/6.8
    }
    private func stage1_1(){
        view.backgroundColor = UIColor.white
        ball = Ball(image: UIImage(named: "ball")!)
        ball.frame.size = CGSize(width: view.frame.width*32/375, height: view.frame.width*32/375)
        // ball的位置
        ball.center.x = view.frame.width * 4/5
        ball.center.y = view.frame.height * 1/7
        
        // 牆
        walls.append(CGRect(x: view.frame.width*1.8/7, y: view.frame.height*2.2/10, width: view.frame.width * 5.2/7, height: view.frame.height * 0.5/10))
        walls.append(CGRect(x: 0, y: view.frame.height*4.5/10, width: view.frame.width * 3.6/7, height: view.frame.height * 0.5/10))
        walls.append(CGRect(x: view.frame.width*5/7, y: view.frame.height*4.5/10, width: view.frame.width * 2/7, height: view.frame.height * 0.5/10))
        walls.append(CGRect(x: view.frame.width*1.8/7, y: view.frame.height*6.9/10, width: view.frame.width * 5.2/7, height: view.frame.height * 0.5/10))
        
        // 洞
        let holeSide = view.frame.width*32/375
        holes.append(CGRect(x: view.frame.width*1/7, y: view.frame.height*0.8/10, width: holeSide, height: holeSide))
        holes.append(CGRect(x: view.frame.width*1/7, y: view.frame.height*3.7/10, width: holeSide, height: holeSide))
        holes.append(CGRect(x: view.frame.width*4.5/7, y: view.frame.height*3/10, width:holeSide, height: holeSide))
        holes.append(CGRect(x: view.frame.width*4/7, y: view.frame.height*5.7/10, width: holeSide, height: holeSide))
        holes.append(CGRect(x: view.frame.width*2/7, y: view.frame.height*8.5/10, width: holeSide, height: holeSide))
        
        // 目標
        goals.append(CGRect(x: view.frame.width*5/7, y: view.frame.height*8.2/10, width: holeSide, height: holeSide))
    }
    
    private func stage1_2(){
        view.backgroundColor = UIColor.white
        ball = Ball(image: UIImage(named: "ball")!)
        ball.frame.size = CGSize(width: view.frame.width*32/375, height: view.frame.width*32/375)
        // ball的位置
        ball.center.x = view.frame.width * 0.8/6.8
        ball.center.y = view.frame.height * 0.8/12.1
        
        walls.append(CGRect(x: view.frame.width*0/7, y: view.frame.height*0/10, width: view.frame.width * 7/7, height: view.frame.height * 0.4/10))
        walls.append(CGRect(x: view.frame.width*0/7, y: view.frame.height*9.6/10, width: view.frame.width * 7/7, height: view.frame.height * 0.4/10))
        walls.append(CGRect(x: view.frame.width*0/7, y: view.frame.height*0/10, width: view.frame.width * 0.4/7, height: view.frame.height * 10/10))
        walls.append(CGRect(x: view.frame.width*6.6/7, y: view.frame.height*0/10, width: view.frame.width * 0.4/7, height: view.frame.height * 10/10))
        walls.append(CGRect(x: view.frame.width*1.4/7, y: view.frame.height*0/10, width: view.frame.width * 0.35/7, height: view.frame.height * 8.8/10))
        walls.append(CGRect(x: view.frame.width*1.4/7, y: view.frame.height*8.45/10, width: view.frame.width * 4.3/7, height: view.frame.height * 0.35/10))
        walls.append(CGRect(x: view.frame.width*2.8/7, y: view.frame.height*1.2/10, width: view.frame.width * 2.9/7, height: view.frame.height * 0.35/10))
        walls.append(CGRect(x: view.frame.width*5.35/7, y: view.frame.height*1.2/10, width: view.frame.width * 0.35/7, height: view.frame.height * 7.6/10))
        walls.append(CGRect(x: view.frame.width*2.8/7, y: view.frame.height*1.2/10, width: view.frame.width * 0.34/7, height: view.frame.height * 6.2/10))
        walls.append(CGRect(x: view.frame.width*2.8/7, y: view.frame.height*7.05/10, width: view.frame.width * 1.6/7, height: view.frame.height * 0.35/10))
        walls.append(CGRect(x: view.frame.width*4.1/7, y: view.frame.height*2.6/10, width: view.frame.width * 0.35/7, height: view.frame.height * 4.8/10))
        
        let holeSide = view.frame.width*32/375
        holes.append(CGRect(x: view.frame.width*0.5/7, y: view.frame.height*9.1/10, width: holeSide, height: holeSide))
        holes.append(CGRect(x: view.frame.width*6.0/7, y: view.frame.height*9.1/10, width: holeSide, height: holeSide))
        holes.append(CGRect(x: view.frame.width*6.0/7, y: view.frame.height*0.4/10, width: holeSide, height: holeSide))
        holes.append(CGRect(x: view.frame.width*1.8/7, y: view.frame.height*0.4/10, width: holeSide, height: holeSide))
        holes.append(CGRect(x: view.frame.width*1.8/7, y: view.frame.height*7.8/10, width: holeSide, height: holeSide))
        holes.append(CGRect(x: view.frame.width*4.7/7, y: view.frame.height*7.8/10, width: holeSide, height: holeSide))
        holes.append(CGRect(x: view.frame.width*4.7/7, y: view.frame.height*1.6/10, width: holeSide, height: holeSide))
        holes.append(CGRect(x: view.frame.width*3.2/7, y: view.frame.height*1.6/10, width: holeSide, height: holeSide))
        
        // 目標
        goals.append(CGRect(x: view.frame.width*3.3/7, y: view.frame.height*6.4/10, width: holeSide, height: holeSide))
    }
}

