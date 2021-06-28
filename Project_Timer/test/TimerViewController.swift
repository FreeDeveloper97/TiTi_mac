//
//  TimerViewController.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2021/04/30.
//  Copyright © 2021 FDEE. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation

class TimerViewController: UIViewController {

    @IBOutlet var taskButton: UIButton!
    @IBOutlet var innerProgress: CircularProgressView!
    @IBOutlet var outterProgress: CircularProgressView!
    
    @IBOutlet var sumTimeLabel: UILabel!
    @IBOutlet var TIMEofSum: UILabel!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var TIMEofTimer_h: UILabel!
    @IBOutlet var TIMEofTimer_m1: UILabel!
    @IBOutlet var TIMEofTimer_m2: UILabel!
    @IBOutlet var TIMEofTimer_s1: UILabel!
    @IBOutlet var TIMEofTimer_s2: UILabel!
    
    @IBOutlet var TIMEofTimer_left: UILabel!
    @IBOutlet var TIMEofTimer_right: UILabel!
    @IBOutlet var TIMEofTimer_status: UILabel!
    
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
    @IBOutlet var setTimerBT: UIButton!
    @IBOutlet var setTimerBTLabel: UILabel!
    @IBOutlet var settingBT: UIButton!
    @IBOutlet var settingBTLabel: UILabel!
    
    let BLUE = UIColor(named: "Blue")
    let BUTTON = UIColor(named: "Button")
    let CLICK = UIColor(named: "Click")
    let RED = UIColor(named: "Text")
    let INNER = UIColor(named: "innerColor")
    
    var audioPlayer : AVPlayer!
    var timeTrigger = true
    var realTime = Timer()
    var timerTime : Int = 0
    var sumTime : Int = 0
    var goalTime : Int = 0
    var diffHrs = 0
    var diffMins = 0
    var diffSecs = 0
    var isStop = true
    var isFirst = false
    var progressPer: Float = 0.0
    var fixedSecond: Int = 0
    var fromSecond: Float = 0.0
    var showAverage: Int = 0
    var array_day = [String](repeating: "", count: 7)
    var array_time = [String](repeating: "", count: 7)
    var array_break = [String](repeating: "", count: 7)
    var VCNum: Int = 1
    var totalTime: Int = 0
    var beforePer2: Float = 0.0
    var time = Time()
    var task: String = ""
    //하루 그래프를 위한 구조
    var daily = Daily()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.view.window?.windowScene?.sizeRestrictions?.maximumSize = CGSize(width: 5000, height: 5000)
            self.view.window?.windowScene?.sizeRestrictions?.minimumSize = CGSize(width: 1300, height: 1100)
        }
        modeTimer.backgroundColor = UIColor.gray
        modeTimerLabel.textColor = UIColor.gray
        modeTimer.isUserInteractionEnabled = false
        
        getVCNum()
        setLocalizable()
        
        setButtonRotation()
        setRadius()
        setShadow()
        setBorner()
        getDatas()
        
        setTimes()
        stopColor()
        stopEnable()
        
        setBackground()
        checkIsFirst()
        setProgress()
        
        daily.load()
        setTask()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.window?.windowScene?.sizeRestrictions?.minimumSize = CGSize(width: 650, height: 350)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("disappear in timer")
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    func checkTimeTrigger() {
        realTime = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        timeTrigger = false
    }
    
    @objc func updateCounter(){
        if timerTime < 1 {
            algoOfStop()
            TIMEofTimer_status.text = "FINISH".localized()
            hideTIMEofTimer()
            playAudioFromProject()
            saveTimes()
        } else {
            if timerTime < 61 {
                setTIMEofTimerColor(RED!)
                outterProgress.progressColor = RED!
            }
            let seconds = time.getSeconds()
            goalTime = time.startGoalTime - seconds
            sumTime = time.startSumTime + seconds
            timerTime = time.startTimerTime - seconds
            daily.updateTask(seconds)
            if(seconds > daily.maxTime) { daily.maxTime = seconds }
            
            updateTimeLabels()
            saveTimes()
            printLogs()
            updateProgress()
//            showNowTime()
        }
    }

    @IBAction func taskBTAction(_ sender: Any) {
        showTaskView()
    }
    
    @IBAction func modeStopWatchBTAction(_ sender: Any) {
        goToViewController(where: "StopwatchViewController", isFull: true)
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
    
    @IBAction func settingTimerBTAction(_ sender: Any) {
        showTimerView()
    }
}

extension TimerViewController : ChangeViewController {
    
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
    
    func updateViewController() {
        showTIMEofTimer()
        stopColor()
        stopEnable()
        
        isStop = true
        realTime.invalidate()
        timeTrigger = true
        getTimeData()
        sumTime = 0
        print("reset Button complite")
        
        UserDefaults.standard.set(timerTime, forKey: "second2")
        UserDefaults.standard.set(goalTime, forKey: "allTime2")
        UserDefaults.standard.set(sumTime, forKey: "sum2")
        UserDefaults.standard.set(0, forKey: "breakTime")
        UserDefaults.standard.set(nil, forKey: "startTime")
        
        TIMEofSum.text = printTime(temp: sumTime)
        printTime_center(temp: timerTime)
        TIMEofTarget.text = printTime(temp: goalTime)
        
        persentReset()
 
        //종료 예상시간 보이기
        finishTimeLabel.text = getFutureTime()
        daily.reset() //하루 그래프 초기화
    }
    
    func changeTimer() {
        showTIMEofTimer()
        timerTime = UserDefaults.standard.value(forKey: "second") as? Int ?? 2400
        UserDefaults.standard.set(timerTime, forKey: "second2")
        printTime_center(temp: timerTime)
        finishTimeLabel.text = getFutureTime()
        fixedSecond = UserDefaults.standard.value(forKey: "second") as? Int ?? 2400
        outterProgress.setProgressWithAnimation(duration: 1.0, value: 0.0, from: fromSecond)
        fromSecond = 0.0
    }
}

extension TimerViewController: ChangeViewController2 {
    func changeGoalTime() {}
    
    func changeTask() {
        setTask()
    }
}

extension TimerViewController {
    
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
                (diffHrs, diffMins, diffSecs) = TimerViewController.getTimeDifference(startDate: savedDate)
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
        
        goalTime = time.startGoalTime - seconds
        sumTime = time.startSumTime + seconds
        print("before : \(temp), after : \(sumTime), term : \(sumTime - temp)")
        timerTime = time.startTimerTime - seconds
        daily.updateTask(seconds)
        if(seconds > daily.maxTime) { daily.maxTime = seconds }
        
        printLogs()
        updateProgress()
        updateTimeLabes()
        startAction()
        if(timerTime < 0) {
            printTime_center(temp: timerTime)
        }
        //나간 시점 start, 현재 시각 Date 와 비교
        daily.addHoursInBackground(start, sumTime - temp)
    }
    
    func removeSavedDate() {
        if (UserDefaults.standard.object(forKey: "savedTime") as? Date) != nil {
            UserDefaults.standard.removeObject(forKey: "savedTime")
        }
    }
    
    func checkIsFirst() {
        if (UserDefaults.standard.object(forKey: "startTime") == nil) {
            isFirst = true
        }
    }
    
    func setButtonRotation() {
        startStopBT.transform = CGAffineTransform(rotationAngle: .pi*5/6)
        settingBT.transform = CGAffineTransform(rotationAngle: .pi*1/6)
        modeTimer.transform = CGAffineTransform(rotationAngle: .pi*1/6)
        log.transform = CGAffineTransform(rotationAngle: .pi*5/6)
    }
    
    func setRadius() {
        startStopBT.layer.cornerRadius = 17
        setTimerBT.layer.cornerRadius = 17
        settingBT.layer.cornerRadius = 17
        modeTimer.layer.cornerRadius = 17
        modeStopWatch.layer.cornerRadius = 17
        log.layer.cornerRadius = 17
        taskButton.layer.cornerRadius = 17
    }
    
    func setShadow() {
        startStopBT.layer.shadowColor = UIColor(named: "darkRed")!.cgColor
        startStopBT.layer.shadowOpacity = 0.5
        startStopBT.layer.shadowOffset = CGSize.zero
        startStopBT.layer.shadowRadius = 4
        
        setTimerBT.layer.shadowColor = UIColor.gray.cgColor
        setTimerBT.layer.shadowOpacity = 0.7
        setTimerBT.layer.shadowOffset = CGSize.zero
        setTimerBT.layer.shadowRadius = 5
        
        settingBT.layer.shadowColor = UIColor.gray.cgColor
        settingBT.layer.shadowOpacity = 0.7
        settingBT.layer.shadowOffset = CGSize.zero
        settingBT.layer.shadowRadius = 5
        
        modeStopWatch.layer.shadowColor = UIColor.gray.cgColor
        modeStopWatch.layer.shadowOpacity = 0.7
        modeStopWatch.layer.shadowOffset = CGSize.zero
        modeStopWatch.layer.shadowRadius = 5
        
        log.layer.shadowColor = UIColor.gray.cgColor
        log.layer.shadowOpacity = 0.7
        log.layer.shadowOffset = CGSize.zero
        log.layer.shadowRadius = 5
        
        setTIMEShadow(TIMEofSum)
        setTIMEShadow(TIMEofTarget)
        
        setTIMEShadow(TIMEofTimer_h)
        setTIMEShadow(TIMEofTimer_left)
        setTIMEShadow(TIMEofTimer_m1)
        setTIMEShadow(TIMEofTimer_m2)
        setTIMEShadow(TIMEofTimer_right)
        setTIMEShadow(TIMEofTimer_s1)
        setTIMEShadow(TIMEofTimer_s2)
    }
    
    func getDatas() {
        sumTime = UserDefaults.standard.value(forKey: "sum2") as? Int ?? 0
        goalTime = UserDefaults.standard.value(forKey: "allTime2") as? Int ?? 21600
        timerTime = UserDefaults.standard.value(forKey: "second2") as? Int ?? 2400
        showAverage = UserDefaults.standard.value(forKey: "showPersent") as? Int ?? 0
        fixedSecond = UserDefaults.standard.value(forKey: "second") as? Int ?? 2400
        totalTime = UserDefaults.standard.value(forKey: "allTime") as? Int ?? 21600
    }
    
    func setBorner() {
        startStopBT.layer.borderWidth = 5
        startStopBT.layer.borderColor = RED!.cgColor
        taskButton.layer.borderWidth = 3
    }
    
    func goToViewController(where: String, isFull: Bool) {
        let vcName = self.storyboard?.instantiateViewController(withIdentifier: `where`)
        //전체화면으로 보이게 설정
        if(isFull) { vcName?.modalPresentationStyle = .fullScreen }
        vcName?.modalTransitionStyle = .crossDissolve //전환 애니메이션 설정
        self.present(vcName!, animated: true, completion: nil)
    }
    
    func getVCNum() {
        VCNum = UserDefaults.standard.value(forKey: "VCNum") as? Int ?? 1
        print(VCNum)
    }
    
    func setProgress() {
        outterProgress.progressWidth = 40.0
        outterProgress.trackColor = UIColor.darkGray
        progressPer = Float(fixedSecond - timerTime) / Float(fixedSecond)
        fromSecond = progressPer
        outterProgress.setProgressWithAnimation(duration: 1.0, value: progressPer, from: 0.0)
        //circle2
        innerProgress.progressWidth = 15.0
        innerProgress.trackColor = UIColor.clear
        beforePer2 = Float(sumTime)/Float(totalTime)
        innerProgress.setProgressWithAnimation(duration: 1.0, value: beforePer2, from: 0.0)
    }
    
    func setTimes() {
        TIMEofSum.text = printTime(temp: sumTime)
        printTime_center(temp: timerTime)
        TIMEofTarget.text = printTime(temp: goalTime)
        finishTimeLabel.text = getFutureTime()
    }
    
    func updateTimeLabels() {
        TIMEofSum.text = printTime(temp: sumTime)
        printTime_center(temp: timerTime)
        TIMEofTarget.text = printTime(temp: goalTime)
    }
    
    func firstStop() {
        let startTime = UserDefaults.standard
        startTime.set(Date(), forKey: "startTime")
        print("startTime SAVE")
        setLogData()
    }
    
    func resetTimer() {
        timerTime = UserDefaults.standard.value(forKey: "second") as? Int ?? 2400
        UserDefaults.standard.set(timerTime, forKey: "second2")
        printTime_center(temp: timerTime)
        print("reset Timer complete")
    }
    
    func resetProgress() {
        outterProgress.setProgressWithAnimation(duration: 1.0, value: 0.0, from: fromSecond)
        fromSecond = 0.0
    }
    
    func showSettingView() {
        let setVC = storyboard?.instantiateViewController(withIdentifier: "SetViewController") as! SetViewController
            setVC.setViewControllerDelegate = self
            present(setVC,animated: true,completion: nil)
    }
    
    func showTimerView() {
        let setVC = storyboard?.instantiateViewController(withIdentifier: "SetTimerViewController") as! SetTimerViewController
            setVC.SetTimerViewControllerDelegate = self
            present(setVC,animated: true,completion: nil)
    }
    
    func showTaskView() {
        let setVC = storyboard?.instantiateViewController(withIdentifier: "taskSelectViewController") as! taskSelectViewController
            setVC.SetTimerViewControllerDelegate = self
            present(setVC,animated: true,completion: nil)
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
        
        TIMEofTimer_h.text = returnString+String(H)
        TIMEofTimer_m1.text = String(m1)
        TIMEofTimer_m2.text = String(m2)
        TIMEofTimer_s1.text = String(s1)
        TIMEofTimer_s2.text = String(s2)
    }
    
    func getTimeData(){
        timerTime = UserDefaults.standard.value(forKey: "second") as? Int ?? 2400
        print("timerTime get complite")
        goalTime = UserDefaults.standard.value(forKey: "allTime") as? Int ?? 21600
        print("goalTime get complite")
        showAverage = UserDefaults.standard.value(forKey: "showPersent") as? Int ?? 0
        print("showAverage get complite")
    }
    
    func startAction() {
        if timeTrigger { checkTimeTrigger() }
        startEnable()
        print("Start")
    }
    
    func updateTimeLabes() {
        printTime_center(temp: timerTime)
        TIMEofSum.text = printTime(temp: sumTime)
        TIMEofTarget.text = printTime(temp: goalTime)
    }
    
    func saveTimes() {
        UserDefaults.standard.set(sumTime, forKey: "sum2")
        UserDefaults.standard.set(timerTime, forKey: "second2")
        UserDefaults.standard.set(goalTime, forKey: "allTime2")
    }
    
    func printLogs() {
        print("timer : " + String(timerTime))
        print("goalTime : " + String(goalTime))
    }
    
    func updateProgress() {
        progressPer = Float(fixedSecond - timerTime) / Float(fixedSecond)
        outterProgress.setProgressWithAnimation(duration: 0.0, value: progressPer, from: fromSecond)
        fromSecond = progressPer
        //circle2
        let temp = Float(sumTime)/Float(totalTime)
        innerProgress.setProgressWithAnimation(duration: 0.0, value: temp, from: beforePer2)
        beforePer2 = temp
    }
    
    func persentReset() {
        isFirst = true
        UserDefaults.standard.set(nil, forKey: "startTime")
//        AverageLabel.textColor = UIColor.white
        fixedSecond = UserDefaults.standard.value(forKey: "second") as? Int ?? 2400
        outterProgress.setProgressWithAnimation(duration: 1.0, value: 0.0, from: fromSecond)
        fromSecond = 0.0
        //circle2
        totalTime = UserDefaults.standard.value(forKey: "allTime") as? Int ?? 21600
        innerProgress.setProgressWithAnimation(duration: 1.0, value: 0.0, from: fromSecond)
        beforePer2 = 0.0
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
        //타이머 모드의 경우 쉬는시간을 0초로 저장한다
        UserDefaults.standard.set(printTime(temp: 0), forKey: "break1")
    }
    
    private func playAudioFromProject() {
        guard let url = Bundle.main.url(forResource: "timer", withExtension: "mp3") else {
            print("error to get the mp3 file")
            return
        }
        do {
            audioPlayer = try AVPlayer(url: url)
        } catch {
            print("audio file error")
        }
        audioPlayer?.play()
    }
    
    func getFutureTime() -> String {
        let now = Date()
        let future = now.addingTimeInterval(TimeInterval(timerTime))
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "hh:mm a"
        let today = dateFormatter.string(from: future)
        return today
    }
    
    func stopColor() {
        self.view.backgroundColor = BLUE
        outterProgress.progressColor = UIColor.white
        innerProgress.progressColor = INNER!
        startStopBT.backgroundColor = RED!
        setTIMEofTimerColor(UIColor.white)
        //예상종료시간 보이기, stop 버튼 제자리로 이동
        UIView.animate(withDuration: 0.3, animations: {
            self.setTimerBT.alpha = 1
            self.settingBT.alpha = 1
            self.taskButton.layer.borderColor = UIColor.white.cgColor
            self.startStopBTLabel.textColor = UIColor.white
            self.setTimerBTLabel.alpha = 1
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
        outterProgress.progressColor = BLUE!
        innerProgress.progressColor = UIColor.white
        startStopBT.backgroundColor = UIColor.clear
        setTIMEofTimerColor(BLUE!)
        //예상종료시간 숨기기, stop 버튼 센터로 이동
        UIView.animate(withDuration: 0.3, animations: {
            self.modeTimer.alpha = 0
            self.modeStopWatch.alpha = 0
            self.log.alpha = 0
            self.modeTimerLabel.alpha = 0
            self.modeStopWatchLabel.alpha = 0
            self.logLabel.alpha = 0
            self.setTimerBT.alpha = 0
            self.settingBT.alpha = 0
            self.taskButton.layer.borderColor = UIColor.clear.cgColor
            self.startStopBTLabel.textColor = self.RED!
            self.setTimerBTLabel.alpha = 0
            self.settingBTLabel.alpha = 0
        })
    }
    
    func stopEnable() {
        settingBT.isUserInteractionEnabled = true
        setTimerBT.isUserInteractionEnabled = true
        log.isUserInteractionEnabled = true
        modeStopWatch.isUserInteractionEnabled = true
        taskButton.isUserInteractionEnabled = true
    }
    
    func startEnable() {
        settingBT.isUserInteractionEnabled = false
        setTimerBT.isUserInteractionEnabled = false
        log.isUserInteractionEnabled = false
        modeStopWatch.isUserInteractionEnabled = false
        taskButton.isUserInteractionEnabled = false
    }
    
    func setLocalizable() {
        sumTimeLabel.text = "Sum Time".localized()
        timerLabel.text = "Timer".localized()
        targetTimeLabel.text = "Target Time".localized()
    }
    
    func setTask() {
        task = UserDefaults.standard.value(forKey: "task") as? String ?? "Enter a new subject".localized()
        if(task == "Enter a new subject".localized()) {
            setFirstStart()
        } else {
            taskButton.setTitleColor(UIColor.white, for: .normal)
            taskButton.layer.borderColor = UIColor.white.cgColor
            startStopBT.isUserInteractionEnabled = true
        }
        taskButton.setTitle(task, for: .normal)
    }
    
    func checkReset() {
        if(timerTime <= 0) {
            algoOfRestart()
        }
    }
    
    func setFirstStart() {
        taskButton.setTitleColor(UIColor.systemPink, for: .normal)
        taskButton.layer.borderColor = UIColor.systemPink.cgColor
        startStopBT.isUserInteractionEnabled = false
    }
}

extension TimerViewController {
    
    func algoOfStart() {
        isStop = false
        startColor()
        showTIMEofTimer()
        checkReset()
        time.setTimes(goal: goalTime, sum: sumTime, timer: timerTime)
        startAction()
        finishTimeLabel.text = getFutureTime()
        if(isFirst) {
            firstStop()
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
        daily.save() //하루 그래프 데이터 계산
    }
    
    func algoOfRestart() {
        resetTimer()
        resetProgress()
        finishTimeLabel.text = getFutureTime()
    }
    
    func hideTIMEofTimer() {
        self.TIMEofTimer_h.alpha = 0
        self.TIMEofTimer_m1.alpha = 0
        self.TIMEofTimer_m2.alpha = 0
        self.TIMEofTimer_s1.alpha = 0
        self.TIMEofTimer_s2.alpha = 0
        self.TIMEofTimer_left.alpha = 0
        self.TIMEofTimer_right.alpha = 0
        self.TIMEofTimer_status.alpha = 1
    }
    
    func showTIMEofTimer() {
        self.TIMEofTimer_status.alpha = 0
        self.TIMEofTimer_h.alpha = 1
        self.TIMEofTimer_m1.alpha = 1
        self.TIMEofTimer_m2.alpha = 1
        self.TIMEofTimer_s1.alpha = 1
        self.TIMEofTimer_s2.alpha = 1
        self.TIMEofTimer_left.alpha = 1
        self.TIMEofTimer_right.alpha = 1
    }
    
    func setTIMEofTimerColor(_ color: UIColor) {
        self.TIMEofTimer_h.textColor = color
        self.TIMEofTimer_m1.textColor = color
        self.TIMEofTimer_m2.textColor = color
        self.TIMEofTimer_s1.textColor = color
        self.TIMEofTimer_s2.textColor = color
        self.TIMEofTimer_left.textColor = color
        self.TIMEofTimer_right.textColor = color
    }
    
    func setTIMEShadow(_ label: UILabel) {
        label.layer.shadowColor = UIColor.gray.cgColor
        label.layer.shadowOpacity = 0.7
        label.layer.shadowOffset = CGSize.zero
        label.layer.shadowRadius = 5
    }
}


extension TimerViewController {
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
            } else if(key.characters == "l") {
                goToViewController(where: "GraphViewController2", isFull: false)
            } else if(key.characters == "m") {
                goToViewController(where: "StopwatchViewController", isFull: true)
            } else if(key.characters == "t") {
                showTimerView()
            }
        }
    }
}
