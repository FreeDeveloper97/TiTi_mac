//
//  testViewController.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2021/03/30.
//  Copyright © 2021 FDEE. All rights reserved.
//

import UIKit

class testViewController: UIViewController {

    @IBOutlet var progress: UIView!
    @IBOutlet var num: UILabel!
    
    var timeTrigger = true
    var realTime = Timer()
    let sum1: Int = 75
    let sum2: Int = 35
    let sum3: Int = 15
    let sum4: Int = 45
    let sum5: Int = 60
    var datas = [75, 35, 15, 45, 60]
    var persent1: Float = 0.0
    var persent2: Float = 0.0
    var persent3: Float = 0.0
    var persent4: Float = 0.0
    var persent5: Float = 0.0
    var sum: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        sum = sum1+sum2+sum3+sum4+sum5
//        persent1 = Float(sum1)/Float(sum)
//        persent2 = Float(sum2)/Float(sum)
//        persent3 = Float(sum3)/Float(sum)
//        persent4 = Float(sum4)/Float(sum)
//        persent5 = Float(sum5)/Float(sum)
//
//
//        print(String(format: "%.1f", persent1*100)+"%")
//        print(String(format: "%.1f", persent2*100)+"%")
//        print(String(format: "%.1f", persent3*100)+"%")
//        print(String(format: "%.1f", persent4*100)+"%")
//        print(String(format: "%.1f", persent5*100)+"%")
//
//        let progress5 = CircularProgressView(frame: CGRect(x: 0, y: 0, width: width, height: height))
//        progress5.progressColor = UIColor.blue
//        progress5.trackColor = UIColor.clear
//        progress5.setProgressWithAnimation(duration: 1, value: persent1+persent2+persent3+persent4+persent5, from: 0)
//
//        let progress4 = CircularProgressView(frame: CGRect(x: 0, y: 0, width: width, height: height))
//        progress4.progressColor = UIColor.purple
//        progress4.trackColor = UIColor.clear
//        progress4.setProgressWithAnimation(duration: 1, value: persent1+persent2+persent3+persent4, from: 0)
//
//        let progress3 = CircularProgressView(frame: CGRect(x: 0, y: 0, width: width, height: height))
//        progress3.progressColor = UIColor.yellow
//        progress3.trackColor = UIColor.clear
//        progress3.setProgressWithAnimation(duration: 1, value: persent1+persent2+persent3, from: 0)
//
//        let progress2 = CircularProgressView(frame: CGRect(x: 0, y: 0, width: width, height: height))
//        progress2.progressColor = UIColor.orange
//        progress2.trackColor = UIColor.clear
//        progress2.setProgressWithAnimation(duration: 1, value: persent1+persent2, from: 0)
//
//        let progress1 = CircularProgressView(frame: CGRect(x: 0, y: 0, width: width, height: height))
//        progress1.progressColor = UIColor.red
//        progress1.trackColor = UIColor.clear
//        progress1.setProgressWithAnimation(duration: 1, value: persent1, from: 0)
//
//        progress.addSubview(progress5)
//        progress.addSubview(progress4)
//        progress.addSubview(progress3)
//        progress.addSubview(progress2)
//        progress.addSubview(progress1)
        
        let width = progress.bounds.width
        let height = progress.bounds.height
        datas.append(52)
        datas.append(23)
        datas.append(78)
        datas.append(23)
        datas.append(100)
////
        datas.append(45)
        datas.append(24)
        datas.append(64)
        datas.append(10)
        datas.append(57)
        makeProgress(datas, width, height)
        num.text = "#\(datas.count)"
//        if(timeTrigger) {
//            checkTimeTrigger()
//        }
    }
    
    func checkTimeTrigger() {
        realTime = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    @objc func update() {
        
    }
    func makeProgress(_ datas: [Int], _ width: CGFloat, _ height: CGFloat) {
        var sum = 0
        for i in 0..<datas.count {
            sum += datas[i]
        }
        var value: Float = 1
        for i in 0..<datas.count {
            let prog = CircularProgressView(frame: CGRect(x: 0, y: 0, width: width, height: height))
            prog.trackColor = UIColor.clear
            if(i%3 == 0) {
                prog.progressColor = UIColor.orange
            } else if(i%3 == 1) {
                prog.progressColor = UIColor.red
            } else {
                prog.progressColor = UIColor.yellow
            }
            print(value)
            prog.setProgressWithAnimation(duration: 1, value: value, from: 0)
            value -= Float(datas[i])/Float(sum)
            progress.addSubview(prog)
        }
        
    }
}
