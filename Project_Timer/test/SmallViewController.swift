//
//  SmallViewController.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2021/06/08.
//  Copyright © 2021 FDEE. All rights reserved.
//

import UIKit

class SmallViewController: UIViewController {

    @IBOutlet var innerProgress: UIProgressView!
    @IBOutlet var outterProgress: UIProgressView!
    @IBOutlet var startStopBT: UIButton!
    @IBOutlet var bigger: UIButton!
    
    @IBOutlet var TIMEofStopwatch_h: UILabel!
    @IBOutlet var TIMEofStopwatch_m1: UILabel!
    @IBOutlet var TIMEofStopwatch_m2: UILabel!
    @IBOutlet var TIMEofStopwatch_s1: UILabel!
    @IBOutlet var TIMEofStopwatch_s2: UILabel!
    
    @IBOutlet var TIMEofStopwatch_left: UILabel!
    @IBOutlet var TIMEofStopwatch_right: UILabel!
    
    @IBOutlet var taskName: UILabel!
    
    
    var realTime = Timer()
    var timeTrigger = true
    var COLOR = UIColor(named: "Background2")
    let INNER = UIColor(named: "innerColor")
    
    var sumTime : Int = 0
    var sumTime_temp : Int = 0 //progress -> 시작기점 누적시간으로 용도 변경
    var goalTime : Int = 0
    var breakTime : Int = 0
    var breakTime2 : Int = 0
    var diffHrs = 0
    var diffMins = 0
    var diffSecs = 0
    var isStop = true
    var isFirst = false
    var progressPer: Float = 0.0
    var fixedSecond: Int = 3600
    var fixedBreak: Int = 300
    var beforePer: Float = 0.0
    var showAvarage: Int = 0
    var array_day = [String](repeating: "", count: 7)
    var array_time = [String](repeating: "", count: 7)
    var array_break = [String](repeating: "", count: 7)
    var stopCount: Int = 0
    var VCNum: Int = 2
    var totalTime: Int = 0
    var beforePer2: Float = 0.0
    var task: String = ""
    var time = Time()
    //하루 그래프를 위한 구조
    var daily = Daily()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        
        setVCNum()
        setColor()
        setRadius()
        setShadow()
        setDatas()
        setTimes()
        
        stopColor()
        stopEnable()
        
        setBackground()
        checkIsFirst()
        
        setFirstProgress()
        
        daily.load()
        setTask()
    }
    
    @IBAction func startStopBTAction(_ sender: Any) {
        //start action
        if(isStop == true) {
            algoOfStart()
        }
        //stop action
        else {
            algoOfStop()
        }
    }
    
    @IBAction func goToBigger(_ sender: Any) {
        goToViewController(where: "StopwatchViewController")
    }
    
    func checkTimeTrigger() {
        realTime = Timer.scheduledTimer(timeInterval: 1, target: self,
            selector: #selector(updateCounter), userInfo: nil, repeats: true)
        timeTrigger = false
    }
    
    @objc func updateCounter(){
        let seconds = time.getSeconds()
        sumTime = time.startSumTime + seconds
        sumTime_temp = time.startSumTimeTemp + seconds
        goalTime = time.startGoalTime - seconds
        daily.updateTask(seconds)
        if(seconds > daily.maxTime) { daily.maxTime = seconds }
        
        updateTimeLabels()
        updateProgress()
        printLogs()
        saveTimes()
//        showNowTime()
    }
}


extension SmallViewController {
    
    func setBackground() {
        NotificationCenter.default.addObserver(self, selector: #selector(pauseWhenBackground(noti:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground(noti:)), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func pauseWhenBackground(noti: Notification) {
        print("background")
        if(!isStop) {
            realTime.invalidate()
            timeTrigger = true
            let shared = UserDefaults.standard
            shared.set(Date(), forKey: "savedTime") //나가는 시점의 시간 저장
        }
    }
    
    @objc func willEnterForeground(noti: Notification) {
        print("Enter")
        if(!isStop) {
            if let savedDate = UserDefaults.standard.object(forKey: "savedTime") as? Date {
                (diffHrs, diffMins, diffSecs) = StopwatchViewController.getTimeDifference(startDate: savedDate)
                refresh(hours: diffHrs, mins: diffMins, secs: diffSecs, start: savedDate)
                removeSavedDate()
            }
        }
    }
    
    static func getTimeDifference(startDate: Date) -> (Int, Int, Int) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: startDate, to: Date())
        return(components.hour!, components.minute!, components.second!)
    }
    
    func refresh (hours: Int, mins: Int, secs: Int, start: Date) {
        let temp = sumTime
        let seconds = time.getSeconds()
        
        sumTime = time.startSumTime + seconds
        print("before : \(temp), after : \(sumTime), term : \(sumTime - temp)")
        sumTime_temp = time.startSumTimeTemp + seconds
        goalTime = time.startGoalTime - seconds
        daily.updateTask(seconds)
        if(seconds > daily.maxTime) { daily.maxTime = seconds }
        
        printLogs()
        updateProgress()
        updateTimeLabels()
        startAction()
        //나간 시점 start, 현재 시각 Date 와 비교
        daily.addHoursInBackground(start, sumTime - temp)
    }
    
    func removeSavedDate() {
        if (UserDefaults.standard.object(forKey: "savedTime") as? Date) != nil {
            UserDefaults.standard.removeObject(forKey: "savedTime")
        }
    }
    
    func setRadius() {
        self.startStopBT.layer.cornerRadius = 5
        self.bigger.layer.cornerRadius = 5
    }
    
    func setShadow() {
        startStopBT.layer.shadowColor = UIColor(named: "darkRed")!.cgColor
        startStopBT.layer.shadowOpacity = 0.5
        startStopBT.layer.shadowOffset = CGSize.zero
        startStopBT.layer.shadowRadius = 4
        
        bigger.layer.shadowColor = UIColor.gray.cgColor
        bigger.layer.shadowOpacity = 0.7
        bigger.layer.shadowOffset = CGSize.zero
        bigger.layer.shadowRadius = 5
        
        setTIMEShadow(TIMEofStopwatch_h)
        setTIMEShadow(TIMEofStopwatch_left)
        setTIMEShadow(TIMEofStopwatch_m1)
        setTIMEShadow(TIMEofStopwatch_m2)
        setTIMEShadow(TIMEofStopwatch_right)
        setTIMEShadow(TIMEofStopwatch_s1)
        setTIMEShadow(TIMEofStopwatch_s2)
    }
    
    func setDatas() {
        goalTime = UserDefaults.standard.value(forKey: "allTime2") as? Int ?? 21600
        sumTime = UserDefaults.standard.value(forKey: "sum2") as? Int ?? 0
        showAvarage = UserDefaults.standard.value(forKey: "showPersent") as? Int ?? 0
        stopCount = UserDefaults.standard.value(forKey: "stopCount") as? Int ?? 0
        breakTime = UserDefaults.standard.value(forKey: "breakTime") as? Int ?? 0
        totalTime = UserDefaults.standard.value(forKey: "allTime") as? Int ?? 21600
        //새로운 스톱워치 시간
        sumTime_temp = 0
        fixedSecond = 3600
    }
    
    func setTimes() {
        printTime_center(temp: sumTime_temp)
    }
    
    func checkIsFirst() {
        if (UserDefaults.standard.object(forKey: "startTime") == nil) {
            isFirst = true
        }
    }
    
    func setFirstProgress() {
        innerProgress.trackTintColor = UIColor.clear
        innerProgress.progressTintColor = UIColor.white
        innerProgress.layer.cornerRadius = 4
        innerProgress.clipsToBounds = true
        innerProgress.layer.sublayers![1].cornerRadius = 4
        innerProgress.subviews[1].clipsToBounds = true

        outterProgress.trackTintColor = .darkGray
        outterProgress.progressTintColor = UIColor(named: "Blue")
        outterProgress.layer.cornerRadius = 10
        outterProgress.clipsToBounds = true
        outterProgress.layer.sublayers![1].cornerRadius = 10
        outterProgress.subviews[1].clipsToBounds = true
        
        progressPer = 0
        beforePer = progressPer
        beforePer2 = Float(sumTime)/Float(totalTime)
        UIView.animate(withDuration: 1) {
            self.outterProgress.setProgress(self.progressPer, animated: true)
            self.innerProgress.setProgress(self.beforePer2, animated: true)
        }
    }
    
    func firstStart() {
        let startTime = UserDefaults.standard
        startTime.set(Date(), forKey: "startTime")
        print("startTime SAVE")
        setLogData()
    }
    
    func startAction() {
        if(timeTrigger) {
            checkTimeTrigger()
        }
        startEnable()
        print("Start")
    }
    
    func updateTimeLabels() {
        printTime_center(temp: sumTime_temp)
    }
    
    func updateProgress() {
        progressPer = Float(sumTime_temp%fixedSecond) / Float(fixedSecond)
        beforePer = progressPer
        print(progressPer)
        
        let temp = Float(sumTime)/Float(totalTime)
        beforePer2 = temp
        
        UIView.animate(withDuration: 0.5) {
            self.outterProgress.setProgress(self.progressPer, animated: true)
            self.innerProgress.setProgress(temp, animated: true)
        }
    }
    
    func printLogs() {
        print("sum : " + String(sumTime))
        print("stopwatch : \(sumTime_temp)")
        print("target : " + String(goalTime))
    }
    
    func saveTimes() {
        UserDefaults.standard.set(sumTime, forKey: "sum2")
        UserDefaults.standard.set(goalTime, forKey: "allTime2")
    }
    
    func saveBreak() {
        UserDefaults.standard.set(breakTime, forKey: "breakTime")
        UserDefaults.standard.set(printTime(temp: breakTime), forKey: "break1")
    }
    
    func printTime(temp : Int) -> String {
        var returnString = "";
        var num = temp;
        if(num < 0) {
            num = -num;
            returnString += "+";
        }
        let S = num%60
        let H = num/3600
        let M = num/60 - H*60
        
        let stringS = S<10 ? "0"+String(S) : String(S)
        let stringM = M<10 ? "0"+String(M) : String(M)
        
        returnString += String(H) + ":" + stringM + ":" + stringS
        return returnString
    }
    
    func printTime_center(temp : Int) {
        var returnString = "";
        var num = temp;
        if(num < 0) {
            num = -num;
            returnString += "+";
        }
        let S = num%60
        let H = num/3600
        let M = num/60 - H*60
        
        let m1 = M/10
        let m2 = M%10
        let s1 = S/10
        let s2 = S%10
        print("\(H):\(m1)\(m2):\(s1)\(s2)")
        
        TIMEofStopwatch_h.text = returnString+String(H)
        TIMEofStopwatch_m1.text = String(m1)
        TIMEofStopwatch_m2.text = String(m2)
        TIMEofStopwatch_s1.text = String(s1)
        TIMEofStopwatch_s2.text = String(s2)
    }
    
    func getDatas(){
        sumTime = UserDefaults.standard.value(forKey: "second") as? Int ?? 0
        print("sumTime get complite")
        goalTime = UserDefaults.standard.value(forKey: "allTime") as? Int ?? 21600
        print("goalTime get complite")
        showAvarage = UserDefaults.standard.value(forKey: "showPersent") as? Int ?? 0
        print("showAvarage get comolite")
        sumTime_temp = 0
    }
    
    func saveLogData() {
        UserDefaults.standard.set(printTime(temp: sumTime), forKey: "time1")
    }
    
    func setLogData() {
        for i in stride(from: 0, to: 7, by: 1) {
            array_day[i] = UserDefaults.standard.value(forKey: "day"+String(i+1)) as? String ?? "NO DATA"
            array_time[i] = UserDefaults.standard.value(forKey: "time"+String(i+1)) as? String ?? "NO DATA"
            array_break[i] = UserDefaults.standard.value(forKey: "break"+String(i+1)) as? String ?? "NO DATA"
        }
        //값 옮기기, 값 저장하기
        for i in stride(from: 6, to: 0, by: -1) {
            array_day[i] = array_day[i-1]
            UserDefaults.standard.set(array_day[i], forKey: "day"+String(i+1))
            array_time[i] = array_time[i-1]
            UserDefaults.standard.set(array_time[i], forKey: "time"+String(i+1))
            array_break[i] = array_break[i-1]
            UserDefaults.standard.set(array_break[i], forKey: "break"+String(i+1))
        }
        //log 날짜 설정
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M월 d일"
        let today = dateFormatter.string(from: now)
        UserDefaults.standard.set(today, forKey: "day1")
    }
    
    func getFutureTime() -> String {
        let now = Date()
        let future = now.addingTimeInterval(TimeInterval(goalTime))
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "hh:mm a"
        let today = dateFormatter.string(from: future)
        return today
    }
    
    func stopColor() {
        self.view.backgroundColor = COLOR
        outterProgress.progressTintColor = UIColor.white
        innerProgress.progressTintColor = INNER!
        setTIMEofStopwatchColor(UIColor.white)
        UIView.animate(withDuration: 0.3) {
            self.bigger.alpha = 1
        }
    }
    
    func startColor() {
        self.view.backgroundColor = UIColor.black
        outterProgress.progressTintColor = COLOR!
        innerProgress.progressTintColor = UIColor.white
        setTIMEofStopwatchColor(COLOR!)
        UIView.animate(withDuration: 0.3) {
            self.bigger.alpha = 0
        }
    }
    
    func stopEnable() {
        bigger.isUserInteractionEnabled = true
    }
    
    func startEnable() {
        bigger.isUserInteractionEnabled = false
    }
    
    func goToViewController(where: String) {
        let vcName = self.storyboard?.instantiateViewController(withIdentifier: `where`)
        vcName?.modalPresentationStyle = .fullScreen //전체화면으로 보이게 설정
        vcName?.modalTransitionStyle = .crossDissolve //전환 애니메이션 설정
        self.present(vcName!, animated: true, completion: nil)
    }
    
    func setColor() {
        COLOR = UserDefaults.standard.colorForKey(key: "color") as? UIColor ?? UIColor(named: "Background2")
    }
    
    func setTask() {
        task = UserDefaults.standard.value(forKey: "task") as? String ?? "Enter a new subject".localized()
        taskName.text = task
    }
}


extension SmallViewController {
    
    func algoOfStart() {
        isStop = false
        startColor()
//        resetSum_temp()
        updateProgress()
        time.setTimes(goal: goalTime, sum: sumTime, timer: 0)
        startAction()
        if(isFirst) {
            firstStart()
            isFirst = false
        }
//        showNowTime()
        daily.startTask(task) //하루 그래프 데이터 생성
    }
    
    func algoOfStop() {
        isStop = true
        timeTrigger = true
        realTime.invalidate()
        
        saveLogData()
        setTimes()
        
        stopColor()
        stopEnable()
        time.startSumTimeTemp = sumTime_temp //기준시간 저장
        daily.save() //하루 그래프 데이터 계산
    }
    
    func setTIMEofStopwatchColor(_ color: UIColor) {
        TIMEofStopwatch_h.textColor = color
        TIMEofStopwatch_m1.textColor = color
        TIMEofStopwatch_s1.textColor = color
        TIMEofStopwatch_m2.textColor = color
        TIMEofStopwatch_s2.textColor = color
        TIMEofStopwatch_left.textColor = color
        TIMEofStopwatch_right.textColor = color
    }
    
    func setTIMEShadow(_ label: UILabel) {
        label.layer.shadowColor = UIColor.gray.cgColor
        label.layer.shadowOpacity = 0.7
        label.layer.shadowOffset = CGSize.zero
        label.layer.shadowRadius = 5
    }
    
    func setVCNum() {
        UserDefaults.standard.set(3, forKey: "VCNum")
    }
}
