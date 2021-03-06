//
//  StopwatchViewController.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2021/04/30.
//  Copyright © 2021 FDEE. All rights reserved.
//

import UIKit

class StopwatchViewController: UIViewController {

    @IBOutlet var taskButton: UIButton!
    @IBOutlet var innerProgress: CircularProgressView!
    @IBOutlet var outterProgress: CircularProgressView!
    
    @IBOutlet var sumTimeLabel: UILabel!
    @IBOutlet var TIMEofSum: UILabel!
    @IBOutlet var stopWatchLabel: UILabel!
    @IBOutlet var TIMEofStopwatch_h: UILabel!
    @IBOutlet var TIMEofStopwatch_m1: UILabel!
    @IBOutlet var TIMEofStopwatch_m2: UILabel!
    @IBOutlet var TIMEofStopwatch_s1: UILabel!
    @IBOutlet var TIMEofStopwatch_s2: UILabel!
    @IBOutlet var TIMEofStopwatch_left: UILabel!
    @IBOutlet var TIMEofStopwatch_right: UILabel!
    
    @IBOutlet var targetTimeLabel: UILabel!
    @IBOutlet var TIMEofTarget: UILabel!
    @IBOutlet var finishTimeLabel: UILabel!
    
    @IBOutlet var modeTimer: UIButton!
    @IBOutlet var modeTimerLabel: UILabel!
    @IBOutlet var modeStopWatch: UIButton!
    @IBOutlet var modeStopWatchLabel: UILabel!
    @IBOutlet var log: UIButton!
    @IBOutlet var logLabel: UILabel!
    
    @IBOutlet var startStopBT: UIButton!
    @IBOutlet var startStopBTLabel: UILabel!
    @IBOutlet var resetBT: UIButton!
    @IBOutlet var resetBTLabel: UILabel!
    @IBOutlet var settingBT: UIButton!
    @IBOutlet var settingBTLabel: UILabel!
    
    @IBOutlet var smaller: UIButton!
    
    var COLOR = UIColor(named: "Background2")
    let BUTTON = UIColor(named: "Button")
    let CLICK = UIColor(named: "Click")
    let RED = UIColor(named: "Text")
    let INNER = UIColor(named: "innerColor")
    
    var timeTrigger = true
    var realTime = Timer()
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
    
    let dailyViewModel = DailyViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.view.window?.windowScene?.sizeRestrictions?.maximumSize = CGSize(width: 7680, height: 4320)
            self.view.window?.windowScene?.sizeRestrictions?.minimumSize = CGSize(width: 1300, height: 1100)
        }
        
        modeStopWatch.backgroundColor = UIColor.gray
        modeStopWatchLabel.textColor = UIColor.gray
        modeStopWatch.isUserInteractionEnabled = false
        
        setVCNum()
        setLocalizable()
        daily.load()
        setSumTime()
        
        setButtonRotation()
        setColor()
        setRadius()
        setShadow()
        setBorder()
        setDatas()
        setTimes()
        
        stopColor()
        stopEnable()
        setTask()
        
        setBackground()
        checkIsFirst()
        
        setFirstProgress()
        //저장된 daily들 로딩
        dailyViewModel.loadDailys()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        self.view.window?.windowScene?.sizeRestrictions?.minimumSize = CGSize(width: 650, height: 350)
//    }
    
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
        daily.updateTimes(seconds)
        daily.updateTask(seconds)
        if(seconds > daily.maxTime) { daily.maxTime = seconds }
        
        updateTimeLabels()
        updateProgress()
        printLogs()
        saveTimes()
    }
    
    @IBAction func taskBTAction(_ sender: Any) {
        showTaskView()
    }
    
    @IBAction func modeTimerBTAction(_ sender: Any) {
        UserDefaults.standard.set(1, forKey: "VCNum")
        goToViewController(where: "TimerViewController", isFull: true)
    }
    
    @IBAction func startStopBTAction(_ sender: Any) {
        if(task == "Enter a new subject".localized()) {
            showFirstAlert()
        } else {
            //start action
            if(isStop == true) {
                algoOfStart()
            }
            //stop action
            else {
                algoOfStop()
            }
        }
    }
    
    @IBAction func settingBTAction(_ sender: Any) {
        showSettingView()
    }
    
    @IBAction func resetBTAction(_ sender: Any) {
        resetSum_temp()
    }
    
    @IBAction func goSmaller(_ sender: Any) {
        goToViewController(where: "SmallViewController", isFull: true)
    }
    
}

extension StopwatchViewController : ChangeViewController2 {
    
    func changeGoalTime() {
        isFirst = true
        UserDefaults.standard.set(nil, forKey: "startTime")
        setColor()
        goalTime = UserDefaults.standard.value(forKey: "allTime") as? Int ?? 0
        showAvarage = UserDefaults.standard.value(forKey: "showPersent") as? Int ?? 0
        let timerTime = UserDefaults.standard.value(forKey: "second") as? Int ?? 2400
        sumTime = 0
        sumTime_temp = 0
        breakTime = 0
        breakTime2 = 0
        
        UserDefaults.standard.set(goalTime, forKey: "allTime2")
        UserDefaults.standard.set(sumTime, forKey: "sum2")
        UserDefaults.standard.set(breakTime, forKey: "breakTime")
        
        resetProgress()
        updateTimeLabels()
        finishTimeLabel.text = getFutureTime()
        
        stopColor()
        stopEnable()
        daily.reset(goalTime, timerTime) //하루 그래프 초기화
        resetSum_temp()
    }
    
    func changeTask() {
        setTask()
        resetSum_temp()
    }
}


extension StopwatchViewController {
    
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
            finishTimeLabel.text = getFutureTime()
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
        daily.updateTimes(seconds)
        daily.updateTask(seconds)
        if(seconds > daily.maxTime) { daily.maxTime = seconds }
        
        printLogs()
        updateProgress()
        updateTimeLabels()
        startAction()
        //나간 시점 start, 현재 시각 Date 와 비교
        daily.addHoursInBackground(start, sumTime - temp)
        saveTimes()
    }
    
    func removeSavedDate() {
        if (UserDefaults.standard.object(forKey: "savedTime") as? Date) != nil {
            UserDefaults.standard.removeObject(forKey: "savedTime")
        }
    }
    
    func setButtonRotation() {
        startStopBT.transform = CGAffineTransform(rotationAngle: .pi*5/6)
        settingBT.transform = CGAffineTransform(rotationAngle: .pi*1/6)
        modeTimer.transform = CGAffineTransform(rotationAngle: .pi*1/6)
        log.transform = CGAffineTransform(rotationAngle: .pi*5/6)
    }
    
    func setRadius() {
        taskButton.layer.cornerRadius = 17
        startStopBT.layer.cornerRadius = 17
        settingBT.layer.cornerRadius = 17
        modeTimer.layer.cornerRadius = 17
        modeStopWatch.layer.cornerRadius = 17
        log.layer.cornerRadius = 17
        resetBT.layer.cornerRadius = 17
        
        smaller.layer.cornerRadius = 17
    }
    
    func setShadow() {
        startStopBT.layer.shadowColor = UIColor(named: "darkRed")!.cgColor
        startStopBT.layer.shadowOpacity = 0.5
        startStopBT.layer.shadowOffset = CGSize.zero
        startStopBT.layer.shadowRadius = 4
        
        settingBT.layer.shadowColor = UIColor.gray.cgColor
        settingBT.layer.shadowOpacity = 0.7
        settingBT.layer.shadowOffset = CGSize.zero
        settingBT.layer.shadowRadius = 5
        
        modeTimer.layer.shadowColor = UIColor.gray.cgColor
        modeTimer.layer.shadowOpacity = 0.7
        modeTimer.layer.shadowOffset = CGSize.zero
        modeTimer.layer.shadowRadius = 5
        
        log.layer.shadowColor = UIColor.gray.cgColor
        log.layer.shadowOpacity = 0.7
        log.layer.shadowOffset = CGSize.zero
        log.layer.shadowRadius = 5
        
        resetBT.layer.shadowColor = UIColor.gray.cgColor
        resetBT.layer.shadowOpacity = 0.7
        resetBT.layer.shadowOffset = CGSize.zero
        resetBT.layer.shadowRadius = 5
        
        smaller.layer.shadowColor = UIColor.gray.cgColor
        smaller.layer.shadowOpacity = 0.7
        smaller.layer.shadowOffset = CGSize.zero
        smaller.layer.shadowRadius = 5
        
        setTIMEShadow(TIMEofSum)
        setTIMEShadow(TIMEofTarget)
        
        setTIMEShadow(TIMEofStopwatch_h)
        setTIMEShadow(TIMEofStopwatch_left)
        setTIMEShadow(TIMEofStopwatch_m1)
        setTIMEShadow(TIMEofStopwatch_m2)
        setTIMEShadow(TIMEofStopwatch_right)
        setTIMEShadow(TIMEofStopwatch_s1)
        setTIMEShadow(TIMEofStopwatch_s2)
    }
    
    func setBorder() {
        startStopBT.layer.borderWidth = 5
        startStopBT.layer.borderColor = RED!.cgColor
        taskButton.layer.borderWidth = 3
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
        TIMEofSum.text = printTime(temp: sumTime)
//        TIMEofStopwatch.text = printTime(temp: sumTime_temp)
        printTime_center(temp: sumTime_temp)
        TIMEofTarget.text = printTime(temp: goalTime)
        finishTimeLabel.text = getFutureTime()
    }
    
    func checkIsFirst() {
        if (UserDefaults.standard.object(forKey: "startTime") == nil) {
            isFirst = true
        }
    }

    func resetProgress() {
        outterProgress.setProgressWithAnimation(duration: 1.0, value: 0.0, from: beforePer)
        beforePer = 0.0
        //circle2
        totalTime = UserDefaults.standard.value(forKey: "allTime") as? Int ?? 21600
        innerProgress.setProgressWithAnimation(duration: 1.0, value: 0.0, from: beforePer2)
        beforePer2 = 0.0
    }
    
    func setFirstProgress() {
        outterProgress.progressWidth = 40.0
        outterProgress.trackColor = UIColor.darkGray
        progressPer = 0
        beforePer = progressPer
        outterProgress.setProgressWithAnimation(duration: 1.0, value: progressPer, from: 0.0)
        //circle2
        innerProgress.progressWidth = 15.0
        innerProgress.trackColor = UIColor.clear
        beforePer2 = Float(sumTime)/Float(totalTime)
        innerProgress.setProgressWithAnimation(duration: 1.0, value: beforePer2, from: 0.0)
    }
    
    func firstStart() {
        let startTime = UserDefaults.standard
        startTime.set(Date(), forKey: "startTime")
        print("startTime SAVE")
        setLogData()
    }
    
    func showSettingView() {
        let setVC = storyboard?.instantiateViewController(withIdentifier: "SetTimerViewController2") as! SetTimerViewController2
            setVC.SetTimerViewControllerDelegate = self
            present(setVC,animated: true,completion: nil)
    }
    
    func showTaskView() {
        let setVC = storyboard?.instantiateViewController(withIdentifier: "taskSelectViewController") as! taskSelectViewController
            setVC.SetTimerViewControllerDelegate = self
            present(setVC,animated: true,completion: nil)
    }
    
    func startAction() {
        if(timeTrigger) {
            checkTimeTrigger()
        }
        startEnable()
        print("Start")
    }
    
    func updateTimeLabels() {
        TIMEofSum.text = printTime(temp: sumTime)
//        TIMEofStopwatch.text = printTime(temp: sumTime_temp)
        printTime_center(temp: sumTime_temp)
        TIMEofTarget.text = printTime(temp: goalTime)
    }
    
    func updateProgress() {
        progressPer = Float(sumTime_temp%fixedSecond) / Float(fixedSecond)
        outterProgress.setProgressWithAnimation(duration: 1.0, value: progressPer, from: beforePer)
        beforePer = progressPer
        //circle2
        let temp = Float(sumTime)/Float(totalTime)
        innerProgress.setProgressWithAnimation(duration: 1.0, value: temp, from: beforePer2)
        beforePer2 = temp
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
        outterProgress.progressColor = UIColor.white
        innerProgress.progressColor = INNER!
        startStopBT.backgroundColor = RED!
        setTIMEofStopwatchColor(UIColor.white)
        //예상종료시간 보이기, stop 버튼 제자리로 이동
        UIView.animate(withDuration: 0.3, animations: {
            self.settingBT.alpha = 1
            self.taskButton.layer.borderColor = UIColor.white.cgColor
            self.startStopBTLabel.textColor = UIColor.white
            self.settingBTLabel.alpha = 1
        })
        //animation test
        UIView.animate(withDuration: 0.5, animations: {
            self.modeTimer.alpha = 1
            self.modeStopWatch.alpha = 1
            self.log.alpha = 1
            self.modeTimerLabel.alpha = 1
            self.modeStopWatchLabel.alpha = 1
            self.logLabel.alpha = 1
            self.resetBT.alpha = 1
            self.resetBTLabel.alpha = 1
            self.smaller.alpha = 1
        })
    }
    
    func startColor() {
        self.view.backgroundColor = UIColor.black
        outterProgress.progressColor = COLOR!
        innerProgress.progressColor = UIColor.white
        startStopBT.backgroundColor = UIColor.clear
        setTIMEofStopwatchColor(COLOR!)
        //예상종료시간 숨기기, stop 버튼 센터로 이동
        UIView.animate(withDuration: 0.3, animations: {
            self.modeTimer.alpha = 0
            self.modeStopWatch.alpha = 0
            self.log.alpha = 0
            self.modeTimerLabel.alpha = 0
            self.modeStopWatchLabel.alpha = 0
            self.logLabel.alpha = 0
            self.settingBT.alpha = 0
            self.taskButton.layer.borderColor = UIColor.clear.cgColor
            self.startStopBTLabel.textColor = self.RED!
            self.settingBTLabel.alpha = 0
            self.resetBT.alpha = 0
            self.resetBTLabel.alpha = 0
            self.smaller.alpha = 0
        })
    }
    
    func stopEnable() {
        settingBT.isUserInteractionEnabled = true
        log.isUserInteractionEnabled = true
        modeTimer.isUserInteractionEnabled = true
        taskButton.isUserInteractionEnabled = true
        resetBT.isUserInteractionEnabled = true
    }
    
    func startEnable() {
        settingBT.isUserInteractionEnabled = false
        log.isUserInteractionEnabled = false
        modeTimer.isUserInteractionEnabled = false
        taskButton.isUserInteractionEnabled = false
        resetBT.isUserInteractionEnabled = false
    }
    
    func goToViewController(where: String, isFull: Bool) {
        let vcName = self.storyboard?.instantiateViewController(withIdentifier: `where`)
        //전체화면으로 보이게 설정
        if(isFull) { vcName?.modalPresentationStyle = .fullScreen }
        vcName?.modalTransitionStyle = .crossDissolve //전환 애니메이션 설정
        self.present(vcName!, animated: true, completion: nil)
    }
    
    func setColor() {
        COLOR = UserDefaults.standard.colorForKey(key: "color") as? UIColor ?? UIColor(named: "Background2")
    }
    
    func setVCNum() {
        UserDefaults.standard.set(2, forKey: "VCNum")
    }
    
    func setLocalizable() {
        sumTimeLabel.text = "Sum Time".localized()
        stopWatchLabel.text = "Stopwatch".localized()
        targetTimeLabel.text = "Target Time".localized()
    }
    
    func setTask() {
        task = UserDefaults.standard.value(forKey: "task") as? String ?? "Enter a new subject".localized()
        if(task == "Enter a new subject".localized()) {
            setFirstStart()
        } else {
            taskButton.setTitleColor(UIColor.white, for: .normal)
            taskButton.layer.borderColor = UIColor.white.cgColor
        }
        taskButton.setTitle(task, for: .normal)
    }
    
    func resetSum_temp() {
        sumTime_temp = 0
        time.startSumTimeTemp = 0
        updateTimeLabels()
        updateProgress()
    }
    
    func setFirstStart() {
        taskButton.setTitleColor(UIColor.systemPink, for: .normal)
        taskButton.layer.borderColor = UIColor.systemPink.cgColor
    }
    
    func showFirstAlert() {
        //1. 경고창 내용 만들기
        let alert = UIAlertController(title:"Enter a new subject".localized(),
            message: "",
            preferredStyle: UIAlertController.Style.alert)
        //2. 확인 버튼 만들기
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        //3. 확인 버튼을 경고창에 추가하기
        alert.addAction(ok)
        //4. 경고창 보이기
        present(alert,animated: true,completion: nil)
    }
    
    func setSumTime() {
        var tempSumTime: Int = 0
        if(daily.tasks != [:]) {
            for (_, value) in daily.tasks {
                tempSumTime += value
            }
            sumTime = tempSumTime
            daily.currentSumTime = tempSumTime
            UserDefaults.standard.set(sumTime, forKey: "sum2")
            saveLogData()
            
            let tempGoalTime = UserDefaults.standard.value(forKey: "allTime") as? Int ?? 21600
            goalTime = tempGoalTime - sumTime
            UserDefaults.standard.set(goalTime, forKey: "allTime2")
        }
    }
}


extension StopwatchViewController {
    
    func algoOfStart() {
        isStop = false
        startColor()
//        resetSum_temp()
        updateProgress()
        time.setTimes(goal: goalTime, sum: sumTime, timer: 0)
        startAction()
        finishTimeLabel.text = getFutureTime()
        if(isFirst) {
            firstStart()
            isFirst = false
        }
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
        //dailys 저장
        dailyViewModel.addDaily(daily)
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
}

extension StopwatchViewController {
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {

        for press in presses {
            guard let key = press.key else { continue }
            if key.characters == " " {
                print("space bar")
                //start action
                if(isStop == true) {
                    algoOfStart()
                }
                //stop action
                else {
                    algoOfStop()
                }
            } else if(key.characters == "s") {
                DispatchQueue.main.async {
                    self.view.window?.windowScene?.sizeRestrictions?.maximumSize = CGSize(width: 650, height: 350)
                    self.view.window?.windowScene?.sizeRestrictions?.minimumSize = CGSize(width: 650, height: 350)
                }
                goToViewController(where: "SmallViewController", isFull: true)
            } else if(key.characters == "l") {
                goToViewController(where: "GraphViewController2", isFull: false)
            } else if(key.characters == "m") {
                goToViewController(where: "TimerViewController", isFull: true)
            }
        }
    }
}
