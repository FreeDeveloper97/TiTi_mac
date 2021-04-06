//
//  SetTimerViewController.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2020/10/21.
//  Copyright © 2020 FDEE. All rights reserved.
//

import UIKit

protocol ChangeViewController2 {
    func changeGoalTime()
    func changeTask()
}

class SetTimerViewController2: UIViewController {
    
    @IBOutlet var Label_timer: UILabel!
    @IBOutlet var Text_H: UITextField!
    @IBOutlet var Text_M: UITextField!
    @IBOutlet var Text_S: UITextField!
    @IBOutlet var Button_set: UIButton!
    @IBOutlet var Button_Back: UIButton!
    @IBOutlet var Label_toTime: UILabel!
    //맥용 추가
    @IBOutlet var Color1: UIButton!
    @IBOutlet var Color2: UIButton!
    @IBOutlet var Color3: UIButton!
    @IBOutlet var Color4: UIButton!
    @IBOutlet var Color5: UIButton!
    @IBOutlet var Color6: UIButton!
    @IBOutlet var Color7: UIButton!
    
    @IBOutlet var targetLabel: UILabel!
    @IBOutlet var endLabel: UILabel!
    @IBOutlet var colorLabel: UILabel!
    @IBOutlet var averageLabel: UILabel!
    @IBOutlet var controlShowAverage: UISegmentedControl!
    
    var SetTimerViewControllerDelegate : ChangeViewController2!
    
    var H = ""
    var M = ""
    var S = ""
    var h: Int = 0
    var m: Int = 0
    var s: Int = 0
    var goalTime: Int = 21600
    var showAverage: Int = 0
    
    var COLOR = UIColor(named: "Background2")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboard()
        setLocalizable()
        setRadius()
        
        goalTime = UserDefaults.standard.value(forKey: "allTime") as? Int ?? 21600
        showAverage = UserDefaults.standard.value(forKey: "showPersent") as? Int ?? 0
        COLOR = UserDefaults.standard.colorForKey(key: "color") as? UIColor ?? UIColor(named: "Background2")
        Label_timer.text = printTime(temp: goalTime)
        
        Text_H.keyboardType = .numberPad
        Text_M.keyboardType = .numberPad
        Text_S.keyboardType = .numberPad
        
        updateColor()

        Text_H.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        Text_M.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        Text_S.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        
        //종료예정시간 보이기
        Label_toTime.text = getFutureTime()
        
        controlShowAverage.selectedSegmentIndex = showAverage
    }
    @objc func textFieldDidChange(textField: UITextField){
        H = Text_H.text!
        M = Text_M.text!
        S = Text_S.text!
        
        check()
        goalTime = h * 3600 + m * 60 + s
        Label_timer.text = printTime(temp: goalTime)
        Label_toTime.text = getFutureTime()
    }
    
    @IBAction func Button_set(_ sender: UIButton) {
        //경고창 추가
        let alert = UIAlertController(title:"Do you want to set it up?".localized(),message: "The Target, Sum Time will be reset and a new record starts!".localized(),preferredStyle: UIAlertController.Style.alert)
        let cancel = UIAlertAction(title: "CANCEL", style: .default, handler: nil)
        let okAction = UIAlertAction(title: "SET", style: .destructive, handler:
                                        {
                                            action in
                                            self.SET_action()
                                        })
        alert.addAction(cancel)
        alert.addAction(okAction)
        present(alert,animated: true,completion: nil)
    }
    
    @IBAction func Button_Back_action(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func set_persent(_ sender: UISegmentedControl) {
        switch controlShowAverage.selectedSegmentIndex {
        case 0:
            showAverage = 0
            print("0")
        case 1:
            showAverage = 1
            print("1")
        default: return
        }
    }
    //맥용 추가
    @IBAction func SetColor(_ sender: UIButton) {
        let colorName: String = sender.currentTitle ?? "Background2"
        COLOR = UIColor(named: "\(colorName)")
        updateColor()
    }
    
}

extension SetTimerViewController2 {
    
    func check()
    {
        if (H != "")
        {
            h = Int(H)!
            m = 0
            s = 0
        }
        if (M != "")
        {
            if(H == "")
            {
                h = 0
            }
            m = Int(M)!
            s = 0
        }
        if (S != "")
        {
            if(H == "")
            {
                h = 0
            }
            if(M == "")
            {
                m = 0
            }
            s = Int(S)!
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
    
    func getFutureTime() -> String {
        //log 날짜 설정
        let now = Date()
        let future = now.addingTimeInterval(TimeInterval(goalTime))
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "hh:mm a"
        let today = dateFormatter.string(from: future)
        return today
    }
    
    func updateColor() {
        Label_timer.textColor = COLOR
        Button_set.setTitleColor(COLOR, for: .normal)
        Button_set.layer.borderColor = COLOR?.cgColor
        Button_Back.layer.borderColor = UIColor.white.cgColor
    }
    
    func SET_action() {
        let second = UserDefaults.standard.value(forKey: "second") as? Int ?? 2400
        UserDefaults.standard.set(second, forKey: "second2")
        UserDefaults.standard.setColor(color: COLOR, forKey: "color")
        UserDefaults.standard.set(goalTime, forKey: "allTime")
        UserDefaults.standard.set(showAverage, forKey: "showPersent")
        print("set complite")
        SetTimerViewControllerDelegate.changeGoalTime()
        self.dismiss(animated: true, completion: nil)
    }
    
    func setRadius() {
        Button_set.layer.cornerRadius = 10
        Button_set.layer.borderWidth = 3
        
        Button_Back.layer.cornerRadius = 10
        Button_Back.layer.borderWidth = 3
        
        Color1.layer.cornerRadius = 10
        Color2.layer.cornerRadius = 10
        Color3.layer.cornerRadius = 10
        Color4.layer.cornerRadius = 10
        Color5.layer.cornerRadius = 10
        Color6.layer.cornerRadius = 10
        Color7.layer.cornerRadius = 10
    }
    
    func setLocalizable() {
        targetLabel.text = "Target Time2".localized()
        endLabel.text = "End Time".localized()
        colorLabel.text = "Change Background Color".localized()
        averageLabel.text = "Average Study Time".localized()
        controlShowAverage.setTitle("Show".localized(), forSegmentAt: 0)
        controlShowAverage.setTitle("Hide".localized(), forSegmentAt: 1)
    }
}
