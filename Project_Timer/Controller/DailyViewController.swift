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
    var sum: Int = 0
    
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
        //19 37 70
        var R: CGFloat = 1
        var G: CGFloat = 8
        var B: CGFloat = 40
        let perR = (255-R)/CGFloat(counts)
        let perG = (255-G)/CGFloat(counts)
        let perB = (255-B)/CGFloat(counts)
        R = 255
        G = 255
        B = 255
        
        for _ in 0..<counts {
            colors.append(UIColor(R, G, B, 1.0))
            R -= perR
            G -= perG
            B -= perB
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
        sum = 0
        for i in 0..<datas.count {
            sum += datas[i]
        }
        
        sumTime.text = printTime(temp: sum)
        
        var value: Float = 1
        for i in 0..<counts {
            let prog = CircularProgressView(frame: CGRect(x: 0, y: 0, width: width, height: height))
            prog.trackColor = UIColor.clear
            prog.progressColor = colors[i%7]
            print(value)
            prog.setProgressWithAnimation(duration: 1, value: value, from: 0)
            let per = Float(datas[i])/Float(sum)
            value -= per
            progress.addSubview(prog)
            printPersent.append(String(format: "%.1f", per*100) + "%")
        }
        
    }
}
