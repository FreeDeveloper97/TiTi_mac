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
    
    var printTitle: [String] = []
    var printTime: [String] = []
    var printPersent: [String] = []
    var colors: [UIColor] = []
    var counts: Int = 0
    var fixed_sum: Int = 0
    let f = Float(0.003)
    var breakTime: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func getDay(day: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d"
        return dateFormatter.string(from: day)
    }
    
    func appendColors() {
        for i in 1...12 {
            colors.append(UIColor(named: "CC\(i)")!)
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
//        temp["ios 프로그래밍"] = 2100
//        temp["OS 공부"] = 4680
//        temp["DB 공부"] = 3900
//        temp["통계학 공부"] = 2700
//        temp["영어 공부"] = 2280
//        temp["swift 프로그래밍"] = 2400
//        temp["수업"] = 2160
//        temp["시스템 분석 공부"] = 1800
//        temp["문학세계 공부"] = 1200
        temp["코딩테스트 공부"] = 2200
        temp["자바스크립트 공부"] = 1980
        temp["휴식 시간"] = 2500
        
        return temp
    }
}
