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
    
    var realTime = Timer()
    var timeTrigger = true
    var count: Int = 0
    let fixedMaxTime: Int = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        
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
        
        self.innerProgress.setProgress(0, animated: true)
        self.outterProgress.setProgress(0, animated: true)
        
        self.startStopBT.layer.cornerRadius = 5
        self.bigger.layer.cornerRadius = 5
        
        printTime_center(temp: count)
    }
    
    @IBAction func startStopBTAction(_ sender: Any) {
        if(timeTrigger) {
            checkTimeTrigger()
        } else {
            realTime.invalidate()
            timeTrigger = true
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
        count += 1
        printTime_center(temp: count)
        var test: Float = Float(count)/Float(fixedMaxTime)
        UIView.animate(withDuration: 0.5) {
            self.innerProgress.setProgress(test/2, animated: true)
            self.outterProgress.setProgress(test, animated: true)
        }
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
    
    func goToViewController(where: String) {
        let vcName = self.storyboard?.instantiateViewController(withIdentifier: `where`)
        vcName?.modalPresentationStyle = .fullScreen //전체화면으로 보이게 설정
        vcName?.modalTransitionStyle = .crossDissolve //전환 애니메이션 설정
        self.present(vcName!, animated: true, completion: nil)
    }
}
