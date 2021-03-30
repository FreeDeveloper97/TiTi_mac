//
//  testViewController.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2021/03/30.
//  Copyright © 2021 FDEE. All rights reserved.
//

import UIKit

class testViewController: UIViewController {

    @IBOutlet var progress1: CircularProgressView!
    @IBOutlet var progress2: CircularProgressView!
    @IBOutlet var progress3: CircularProgressView!
    @IBOutlet var count: UILabel!
    
    var timeTrigger = true
    var realTime = Timer()
    let total3: Int = 5
    let total2: Int = 15
    let total1: Int = 30
    var count3: Int = 0
    var count2: Int = 0
    var count1: Int = 0
    var num: Int = 0
    var persent1: Float = 0
    var persent2: Float = 0
    var persent3: Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        progress1.progressColor = UIColor.red
        progress1.trackColor = UIColor.clear
        progress1.setProgressWithAnimation(duration: 0, value: persent1, from: 0)
        progress2.progressColor = UIColor.orange
        progress2.trackColor = UIColor.clear
        progress2.setProgressWithAnimation(duration: 0, value: persent2, from: 0)
        progress3.progressColor = UIColor.yellow
        progress3.trackColor = UIColor.clear
        progress3.setProgressWithAnimation(duration: 0, value: persent3, from: 0)

        if(timeTrigger) {
            checkTimeTrigger()
        }
    }
    
    func checkTimeTrigger() {
        realTime = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    @objc func update() {
        num += 1
        count.text = "\(num)"
        if(num == 30) {
            count.textColor = UIColor.white
            realTime.invalidate()
            return
        }
        
        update1()
        update2()
        update3()
    }
    func update1() {
        let temp = persent1
        count1 = (count1+1)%total1
        persent1 = Float(count1)/Float(total1-1)
        progress1.setProgressWithAnimation(duration: 1, value: persent1, from: temp)
    }
    func update2() {
        let temp = persent2
        count2 = (count2+1)%total2
        persent2 = Float(count2)/Float(total2-1)
        progress2.setProgressWithAnimation(duration: 1, value: persent2, from: temp)
    }
    func update3() {
        let temp = persent3
        count3 = (count3+1)%total3
        persent3 = Float(count3)/Float(total3-1)
        progress3.setProgressWithAnimation(duration: 1, value: persent3, from: temp)
    }
}
