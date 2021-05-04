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
    @IBOutlet var TIMEofStopwatch: UILabel!
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
    @IBOutlet var tempBT: UIButton!
    @IBOutlet var settingBT: UIButton!
    @IBOutlet var settingBTLabel: UILabel!
    
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
    var isBreak = false
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
    var time = Time() //맥용을 위한 구조
    //하루 그래프를 위한 구조
    var daily = Daily()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        
        modeStopWatch.backgroundColor = UIColor.gray
        modeStopWatchLabel.textColor = UIColor.gray
        modeStopWatch.isUserInteractionEnabled = false
        tempBT.alpha = 0
        
        setVCNum()
        setLocalizable()
        
        setButtonRotation()
        setColor()
        setRadius()
        setShadow()
        setBorder()
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

    override func viewWillDisappear(_ animated: Bool) {
        print("disappear in stopwatch")
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }

    @objc func deviceRotated(){
        if(isStop) {
            if UIDevice.current.orientation.isPortrait {
                //Code here
                print("Portrait")
                setPortrait()
            } else {
                //Code here
                print("Landscape")
                setLandscape()
            }
        }
    }
    
    func checkTimeTrigger() {
        realTime = Timer.scheduledTimer(timeInterval: 1, target: self,
            selector: #selector(updateCounter), userInfo: nil, repeats: true)
        timeTrigger = false
    }
    
    @objc func updateCounter(){
        //맥용 코드
        let seconds = time.getSeconds()
        sumTime = time.startSumTime + seconds
        sumTime_temp = seconds
        goalTime = time.startGoalTime - seconds
        
        updateTimeLabels()
        updateProgress()
        printLogs()
        saveTimes()
//        showNowTime()
    }
    
    @IBAction func taskBTAction(_ sender: Any) {
        showTaskView()
    }
    
    @IBAction func modeTimerBTAction(_ sender: Any) {
        UserDefaults.standard.set(1, forKey: "VCNum")
        goToViewController(where: "ViewController")
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
    
    @IBAction func settingBTAction(_ sender: Any) {
        showSettingView()
    }
}

extension StopwatchViewController : ChangeViewController2 {
    
    func setLandscape() {
        modeTimerLabel.alpha = 1
        modeStopWatchLabel.alpha = 1
        logLabel.alpha = 1
    }
    
    func setPortrait() {
        modeTimerLabel.alpha = 0
        modeStopWatchLabel.alpha = 0
        logLabel.alpha = 0
    }
    
    func changeGoalTime() {
        isFirst = true
        UserDefaults.standard.set(nil, forKey: "startTime")
        setColor()
        goalTime = UserDefaults.standard.value(forKey: "allTime") as? Int ?? 0
        showAvarage = UserDefaults.standard.value(forKey: "showPersent") as? Int ?? 0
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
        //하루 그래프 초기화
        daily.reset()
    }
    
    func changeTask() {
        setTask()
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
            shared.set(Date(), forKey: "savedTime")
        } else if(isBreak) {
            realTime.invalidate()
            timeTrigger = true
            let shared = UserDefaults.standard
            shared.set(Date(), forKey: "savedTime")
        }
    }
    
    @objc func willEnterForeground(noti: Notification) {
        print("Enter")
        finishTimeLabel.text = getFutureTime()
        if(!isStop) {
            if let savedDate = UserDefaults.standard.object(forKey: "savedTime") as? Date {
                (diffHrs, diffMins, diffSecs) = ViewController.getTimeDifference(startDate: savedDate)
                refresh(hours: diffHrs, mins: diffMins, secs: diffSecs)
                removeSavedDate()
            }
        }
    }
    
    static func getTimeDifference(startDate: Date) -> (Int, Int, Int) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: startDate, to: Date())
        return(components.hour!, components.minute!, components.second!)
    }
    
    func refresh (hours: Int, mins: Int, secs: Int) {
        let tempSeconds = hours*3600 + mins*60 + secs
        
        goalTime -= tempSeconds
        sumTime += tempSeconds
        sumTime_temp += tempSeconds
        sumTime_temp %= fixedSecond
        
        updateProgress()
        updateTimeLabels()
        startAction()
        finishTimeLabel.text = getFutureTime()
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
        TIMEofStopwatch.text = printTime(temp: sumTime_temp)
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
        TIMEofStopwatch.text = printTime(temp: sumTime_temp)
        TIMEofTarget.text = printTime(temp: goalTime)
    }
    
    func updateProgress() {
        progressPer = Float(sumTime_temp%fixedSecond) / Float(fixedSecond)
        outterProgress.setProgressWithAnimation(duration: 0.0, value: progressPer, from: beforePer)
        beforePer = progressPer
        //circle2
        let temp = Float(sumTime)/Float(totalTime)
        innerProgress.setProgressWithAnimation(duration: 0.0, value: temp, from: beforePer2)
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
        TIMEofStopwatch.textColor = UIColor.white
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
        })
    }
    
    func startColor() {
        self.view.backgroundColor = UIColor.black
        outterProgress.progressColor = COLOR!
        innerProgress.progressColor = UIColor.white
        startStopBT.backgroundColor = UIColor.clear
        TIMEofStopwatch.textColor = COLOR
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
        })
    }
    
    func stopEnable() {
        settingBT.isUserInteractionEnabled = true
        log.isUserInteractionEnabled = true
        modeTimer.isUserInteractionEnabled = true
        taskButton.isUserInteractionEnabled = true
    }
    
    func startEnable() {
        settingBT.isUserInteractionEnabled = false
        log.isUserInteractionEnabled = false
        modeTimer.isUserInteractionEnabled = false
        taskButton.isUserInteractionEnabled = false
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
    
    func setVCNum() {
        UserDefaults.standard.set(2, forKey: "VCNum")
    }
    
//    func showNowTime() {
//        let now = Date()
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "en_US")
//        dateFormatter.dateFormat = "hh:mm a"
//        let today = dateFormatter.string(from: now)
//        avarageLabel.font = UIFont(name: "HGGGothicssiP60g", size: 35)
//        nowTimeLabel.text = "\n" + "Now Time".localized()
//        avarageLabel.text = "\(today)"
//    }
    
    func setLocalizable() {
        sumTimeLabel.text = "Sum Time".localized()
        stopWatchLabel.text = "Stopwatch".localized()
        targetTimeLabel.text = "Target Time".localized()
    }
    
    func setTask() {
        task = UserDefaults.standard.value(forKey: "task") as? String ?? "Enter New Task"
        taskButton.setTitle(task, for: .normal)
    }
    
    func resetSum_temp() {
        sumTime_temp = 0
        updateTimeLabels()
    }
}


extension StopwatchViewController {
    
    func algoOfStart() {
        isStop = false
        startColor()
        resetSum_temp()
        updateProgress()
        time.setTimes(goal: goalTime, sum: sumTime, timer: 0) //맥용 코드 추가
        startAction()
        finishTimeLabel.text = getFutureTime()
        if(isFirst) {
            firstStart()
            isFirst = false
        }
//        showNowTime()
        //하루 그래프 데이터 생성
        daily.startTask(task)
    }
    
    func algoOfStop() {
        isStop = true
        timeTrigger = true
        realTime.invalidate()
        
        saveLogData()
        setTimes()
        
        stopColor()
        stopEnable()
        //하루 그래프 데이터 계산
        daily.stopTask()
        daily.save()
        //화면 회전 체크
        deviceRotated()
    }
}
