//
//  GraphViewController.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2021/04/06.
//  Copyright © 2021 FDEE. All rights reserved.
//

import UIKit
import Foundation

class DailyViewController: UIViewController {

    @IBOutlet var progress: UIView!
    @IBOutlet var sumTime: UILabel!
    @IBOutlet var taskTitle: UILabel!
    @IBOutlet var taskTime: UILabel!
    @IBOutlet var taskPersent: UILabel!
    var printTitle: [String] = []
    var printTime: [String] = []
    var printPersent: [String] = []
    var colors: [UIColor] = []
    var counts: Int = 0
    var fixed_sum: Int = 0
    let f = Float(0.003)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var daily = Daily()
        daily.load()
        print(daily.tasks)
        
        var temp = daily.tasks
        temp["breakTime"] = daily.breakTime
        counts = temp.count
        appendColors()
        
        let tasks = temp.sorted(by: { $0.1 < $1.1 } )
        
        var array: [Int] = []
        for (key, value) in tasks {
            printTitle.append(key)
            printTime.append(printTime(temp: value))
            array.append(value)
        }
        
        let width = progress.bounds.width
        let height = progress.bounds.height
        makeProgress(array, width, height)
        var p1 = ""
        var p2 = ""
        var p3 = ""
        for i in (0..<tasks.count).reversed() {
            p1 += "\(printTitle[i])\n"
            p2 += "\(printTime[i])\n"
            p3 += "\(printPersent[i])\n"
        }
        taskTitle.text = p1
        taskTime.text = p2
        taskPersent.text = p3
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}


extension DailyViewController {
    
    func appendColors() {
        for i in 1...12 {
            colors.append(UIColor(named: "Test\(i)")!)
        }
    }
    
    func printTime(temp : Int) -> String
    {
        let S = temp%60
        let H = temp/3600
        let M = temp/60 - H*60
        
        let stringS = S<10 ? "0"+String(S) : String(S)
        let stringM = M<10 ? "0"+String(M) : String(M)
        
        let returnString  = String(H) + ":" + stringM + ":" + stringS
        return returnString
    }
    
    func makeProgress(_ datas: [Int], _ width: CGFloat, _ height: CGFloat) {
        print(datas)
        fixed_sum = 0
        for i in 0..<counts {
            fixed_sum += datas[i]
        }
        var sum = Float(fixed_sum)
        sumTime.text = printTime(temp: fixed_sum)
        //그래프 간 구별선 추가
        sum += f*Float(counts)
        
        var value: Float = 1
        value = addBlock(value: value, width: width, height: height)
        for i in 0..<counts {
            let prog = CircularProgressView(frame: CGRect(x: 0, y: 0, width: width, height: height))
            prog.trackColor = UIColor.clear
            prog.progressColor = colors[i%12]
            print(value)
            prog.setProgressWithAnimation(duration: 1, value: value, from: 0)
            
            let per = Float(datas[i])/Float(sum) //그래프 퍼센트
            let fixed_per = Float(datas[i])/Float(fixed_sum)
            value -= per
            
            progress.addSubview(prog)
            printPersent.append(String(format: "%.1f", fixed_per*100) + "%")
            
            value = addBlock(value: value, width: width, height: height)
        }
        
    }
    
    func addBlock(value: Float, width: CGFloat, height: CGFloat) -> Float {
        var value = value
        let block = CircularProgressView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        block.trackColor = UIColor.clear
        block.progressColor = UIColor.black
        block.setProgressWithAnimation(duration: 1, value: value, from: 0)
        
        value -= f
        progress.addSubview(block)
        return value
    }
}
