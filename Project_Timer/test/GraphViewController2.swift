//
//  GraphViewController.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2021/02/23.
//  Copyright © 2021 FDEE. All rights reserved.
//

import UIKit
import SwiftUI

class GraphViewController2: UIViewController {

    @IBOutlet var viewOfView: UIView!
    @IBOutlet weak var backBT: UIButton!
    
    @IBOutlet var progress: UIView!
    @IBOutlet var sumTime: UILabel!
    @IBOutlet var taskTitle: UILabel!
    @IBOutlet var taskTime: UILabel!
    @IBOutlet var taskPersent: UILabel!
    @IBOutlet var today: UILabel!
    
    @IBOutlet var time_05: UIView!
    @IBOutlet var time_06: UIView!
    @IBOutlet var time_07: UIView!
    @IBOutlet var time_08: UIView!
    @IBOutlet var time_09: UIView!
    @IBOutlet var time_10: UIView!
    @IBOutlet var time_11: UIView!
    @IBOutlet var time_12: UIView!
    @IBOutlet var time_13: UIView!
    @IBOutlet var time_14: UIView!
    @IBOutlet var time_15: UIView!
    @IBOutlet var time_16: UIView!
    @IBOutlet var time_17: UIView!
    @IBOutlet var time_18: UIView!
    @IBOutlet var time_19: UIView!
    @IBOutlet var time_20: UIView!
    @IBOutlet var time_21: UIView!
    @IBOutlet var time_22: UIView!
    @IBOutlet var time_23: UIView!
    @IBOutlet var time_24: UIView!
    @IBOutlet var time_01: UIView!
    @IBOutlet var time_02: UIView!
    @IBOutlet var time_03: UIView!
    @IBOutlet var time_04: UIView!
    
    var printTitle: [String] = []
    var printTime: [String] = []
    var printPersent: [String] = []
    var colors: [UIColor] = []
    var counts: Int = 0
    var fixed_sum: Int = 0
    let f = Float(0.003)
    var breakTime: Int = 0
    let BLUE = UIColor(named: "CC1")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRadius()
        dumyComor()
        //맥용 코드
        setBackBT()
        
        //7days
        let hostingController = UIHostingController(rootView: ContentView())
        hostingController.view.translatesAutoresizingMaskIntoConstraints = true
        hostingController.view.frame = viewOfView.bounds
        ContentView().appendDailyDatas()
//        ContentView().appendDumyDatas()
        addChild(hostingController)
        viewOfView.addSubview(hostingController.view)
        
        //today
        var daily = Daily()
        daily.load()
        
        today.text = getDay(day: daily.day)
        let temp: [String:Int] = daily.tasks
//        let temp = addDumy()
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
    override func viewDidDisappear(_ animated: Bool) {
        ContentView().reset()
    }
    //맥용 코드
    func setBackBT() {
        backBT.layer.borderWidth = 3
        backBT.layer.borderColor = UIColor.white.cgColor
        backBT.layer.cornerRadius = 10
    }
    @IBAction func backBTAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension GraphViewController2 {
    
    func setRadius() {
        time_05.layer.cornerRadius = 3
        time_06.layer.cornerRadius = 3
        time_07.layer.cornerRadius = 3
        time_08.layer.cornerRadius = 3
        time_09.layer.cornerRadius = 3
        time_10.layer.cornerRadius = 3
        time_11.layer.cornerRadius = 3
        time_12.layer.cornerRadius = 3
        time_13.layer.cornerRadius = 3
        time_14.layer.cornerRadius = 3
        time_15.layer.cornerRadius = 3
        time_16.layer.cornerRadius = 3
        time_17.layer.cornerRadius = 3
        time_18.layer.cornerRadius = 3
        time_19.layer.cornerRadius = 3
        time_20.layer.cornerRadius = 3
        time_21.layer.cornerRadius = 3
        time_22.layer.cornerRadius = 3
        time_23.layer.cornerRadius = 3
        time_24.layer.cornerRadius = 3
        time_01.layer.cornerRadius = 3
        time_02.layer.cornerRadius = 3
        time_03.layer.cornerRadius = 3
        time_04.layer.cornerRadius = 3
    }
    
    func getDay(day: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d"
        return dateFormatter.string(from: day)
    }
    
    func appendColors() {
        var i = counts%12+1
        for _ in 1...counts {
            colors.append(UIColor(named: "CC\(i)")!)
            i -= 1
            if(i == 0) {
                i = 12
            }
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
//        breakLabel.text = printTime(temp: breakTime)
        
        //그래프 간 구별선 추가
        sum += f*Float(counts)
        
        var value: Float = 1
        value = addBlock(value: value, width: width, height: height)
        for i in 0..<counts {
            let prog = CircularProgressView(frame: CGRect(x: 0, y: 0, width: width, height: height))
            prog.trackColor = UIColor.clear
            prog.progressColor = colors[i%colors.count]
            if(datas[i] == breakTime) {
                prog.progressColor = UIColor(named: "Text")!
            }
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
    
    func addDumy() -> [String:Int] {
        var temp: [String:Int] = [:]
        temp["ios 프로그래밍"] = 2100
        temp["OS 공부"] = 4680
        temp["DB 공부"] = 3900
        temp["통계학 공부"] = 2700
        temp["영어 공부"] = 2280
        temp["swift 프로그래밍"] = 2400
        temp["수업"] = 2160
        temp["시스템 분석 공부"] = 1800
        temp["문학세계 공부"] = 1200
        temp["코딩테스트 공부"] = 2200
        temp["자바스크립트 공부"] = 1980
        temp["휴식 시간"] = 2500
        temp["13번째과목"] = 2000
        temp["14번째 과목"] = 2300
        
        return temp
    }
    
    func dumyComor() {
        let timeline = [2450,1250,1000,0,0,0,0,0,0,1000,3300,3300,2400,1200,1000,3600,3600,2400,2400,1000,0,2400,23400,0]
        fillColor(time: timeline[0], view: time_24)
        fillColor(time: timeline[1], view: time_01)
        fillColor(time: timeline[2], view: time_02)
        fillColor(time: timeline[3], view: time_03)
        fillColor(time: timeline[4], view: time_04)
        fillColor(time: timeline[5], view: time_05)
        fillColor(time: timeline[6], view: time_06)
        fillColor(time: timeline[7], view: time_07)
        fillColor(time: timeline[8], view: time_08)
        fillColor(time: timeline[9], view: time_09)
        fillColor(time: timeline[10], view: time_10)
        fillColor(time: timeline[11], view: time_11)
        fillColor(time: timeline[12], view: time_12)
        fillColor(time: timeline[13], view: time_13)
        fillColor(time: timeline[14], view: time_14)
        fillColor(time: timeline[15], view: time_15)
        fillColor(time: timeline[16], view: time_16)
        fillColor(time: timeline[17], view: time_17)
        fillColor(time: timeline[18], view: time_18)
        fillColor(time: timeline[19], view: time_19)
        fillColor(time: timeline[20], view: time_20)
        fillColor(time: timeline[21], view: time_21)
        fillColor(time: timeline[22], view: time_22)
        fillColor(time: timeline[23], view: time_23)
    }
    
    func fillColor(time: Int, view: UIView) {
        if(time == 0) {
            return
        }
        view.backgroundColor = BLUE
        if(time < 1200) {
            view.alpha = 0.3
        } else if(time >= 1200 && time < 2400) {
            view.alpha = 0.6
        } else {
            view.alpha = 1
        }
    }
}
