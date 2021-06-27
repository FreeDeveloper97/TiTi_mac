//
//  TodayViewController.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2021/06/10.
//  Copyright © 2021 FDEE. All rights reserved.
//

import UIKit
import SwiftUI

class TodayViewController: UIViewController {
    //frame1
    @IBOutlet var frame1: UIView!
    @IBOutlet var view1: UIView!
    @IBOutlet var today: UILabel!
    @IBOutlet var sumTime: UILabel!
    @IBOutlet var maxTime: UILabel!
    @IBOutlet var timeline: UIView!
    @IBOutlet var mon: UIView!
    @IBOutlet var tue: UIView!
    @IBOutlet var wed: UIView!
    @IBOutlet var thu: UIView!
    @IBOutlet var fri: UIView!
    @IBOutlet var sat: UIView!
    @IBOutlet var sun: UIView!
    
    //frame2
    @IBOutlet var frame2: UIView!
    @IBOutlet var view2: UIView!
    @IBOutlet var today2: UILabel!
    @IBOutlet var progress: UIView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var collectionHeight: NSLayoutConstraint!//196
    
    //frame3
    @IBOutlet var frame3: UIView!
    @IBOutlet var view3: UIView!
    @IBOutlet var view3_timeline: UIView!
    @IBOutlet var view3_progress: UIView!
    @IBOutlet var view3_collectionView: UICollectionView!
    @IBOutlet var view3_today: UILabel!
    @IBOutlet var view3_mon: UIView!
    @IBOutlet var view3_tue: UIView!
    @IBOutlet var view3_wed: UIView!
    @IBOutlet var view3_thu: UIView!
    @IBOutlet var view3_fri: UIView!
    @IBOutlet var view3_sat: UIView!
    @IBOutlet var view3_sun: UIView!
    @IBOutlet var view3_sumTime: UILabel!
    @IBOutlet var view3_maxTime: UILabel!
    
    //frame4
    @IBOutlet var view4: UIView!
    
    @IBOutlet var color1: UIButton!
    @IBOutlet var color2: UIButton!
    @IBOutlet var color3: UIButton!
    @IBOutlet var color4: UIButton!
    @IBOutlet var color5: UIButton!
    @IBOutlet var color6: UIButton!
    @IBOutlet var color7: UIButton!
    @IBOutlet var color8: UIButton!
    @IBOutlet var color9: UIButton!
    @IBOutlet var color10: UIButton!
    @IBOutlet var color11: UIButton!
    @IBOutlet var color12: UIButton!
    
    @IBOutlet var datePicker: UIButton!
    
    let todayViewManager = TodayViewManager()
    var weeks: [UIView] = []
    var weeks2: [UIView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weeks = [mon, tue, wed, thu, fri, sat, sun]
        weeks2 = [view3_mon, view3_tue, view3_wed, view3_thu, view3_fri, view3_sat, view3_sun]
        
        setRadius()
        setShadow(view1)
        setShadow(view2)
        setShadow(view3)
        setShadow(view4)
        
        getColor()
        let isDumy: Bool = false //앱스토어 스크린샷을 위한 더미데이터 여부
        showSwiftUIGraph(isDumy: isDumy)
        showDatas(isDumy: isDumy)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        todayContentView().reset()
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeColor(_ sender: UIButton) {
        let i = Int(sender.tag)
        todayViewManager.setStartColorIndex(i)
        
        for view in self.progress.subviews {
            view.removeFromSuperview()
        }
        for view in self.view3_progress.subviews {
            view.removeFromSuperview()
        }
        
        todayViewManager.reset()
        todayContentView().reset()
        self.viewDidLoad()
        self.view.layoutIfNeeded()
        collectionView.reloadData()
        view3_collectionView.reloadData()
    }
}

extension TodayViewController {
    func setRadius() {
        view1.layer.cornerRadius = 25
        view2.layer.cornerRadius = 25
        view3.layer.cornerRadius = 25
        view4.layer.cornerRadius = 25
        
        color1.layer.cornerRadius = 5
        color2.layer.cornerRadius = 5
        color3.layer.cornerRadius = 5
        color4.layer.cornerRadius = 5
        color5.layer.cornerRadius = 5
        color6.layer.cornerRadius = 5
        color7.layer.cornerRadius = 5
        color8.layer.cornerRadius = 5
        color9.layer.cornerRadius = 5
        color10.layer.cornerRadius = 5
        color11.layer.cornerRadius = 5
        color12.layer.cornerRadius = 5
    }
    
    func setShadow(_ view: UIView) {
        view.layer.shadowColor = UIColor(named: "shadow")?.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 5
    }
    
    func getColor() {
        todayViewManager.startColor = UserDefaults.standard.value(forKey: "startColor") as? Int ?? 1
    }
    
    func showSwiftUIGraph(isDumy: Bool) {
        let startColor = todayViewManager.startColor
        let colorNow: Int = startColor
        var colorSecond: Int = 0
        if(!todayViewManager.reverseColor) {
            colorSecond = startColor+1 == 13 ? 1 : startColor+1
        } else {
            colorSecond = startColor-1 == 0 ? 12 : startColor-1
        }
        //frame1
        let hostingController = UIHostingController(rootView: todayContentView(colors: [Color("D\(colorSecond)"), Color("D\(colorNow)")], frameHeight: 128, height: 125))
        hostingController.view.translatesAutoresizingMaskIntoConstraints = true
        hostingController.view.frame = timeline.bounds
        todayContentView().appendTimes(isDumy: isDumy)
        
        addChild(hostingController)
        timeline.addSubview(hostingController.view)
        
        todayContentView().reset()
        //frame3
        let hostingController2 = UIHostingController(rootView: todayContentView(colors: [Color("D\(colorSecond)"), Color("D\(colorNow)")], frameHeight: 97, height: 93))
        hostingController2.view.translatesAutoresizingMaskIntoConstraints = true
        hostingController2.view.frame = view3_timeline.bounds
        todayContentView().appendTimes(isDumy: isDumy)
        
        addChild(hostingController2)
        view3_timeline.addSubview(hostingController2.view)
    }
    
    func showDatas(isDumy: Bool) {
        todayViewManager.daily.load()
        if(isDumy) {
            todayViewManager.setDumyDaily()
        }
        if(todayViewManager.daily.tasks != [:]) {
            todayViewManager.setTasksColor()
            todayViewManager.setDay(today, today2, view3_today)
            todayViewManager.setWeek(weeks)
            todayViewManager.setWeek(weeks2)
            todayViewManager.getTasks()
            todayViewManager.makeProgress(progress, view3_progress)
            todayViewManager.showTimes(sumTime, view3_sumTime, maxTime, view3_maxTime)
            
            setHeight()
        } else {
            print("no data")
        }
    }
    
    func setHeight() {
        if(todayViewManager.array.count < 8) {
            collectionHeight.constant = CGFloat(24*todayViewManager.array.count)
        }
    }
}



extension TodayViewController: UICollectionViewDataSource {
    //몇개 표시 할까?
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return todayViewManager.counts
    }
    //셀 어떻게 표시 할까?
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView == self.collectionView) {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "todayCell", for: indexPath) as? todayCell else {
                return UICollectionViewCell()
            }
            let counts = todayViewManager.counts
            let color = todayViewManager.colors[counts - indexPath.item - 1]
            cell.colorView.backgroundColor = color
            cell.colorView.layer.cornerRadius = 2
            cell.taskName.text = todayViewManager.arrayTaskName[counts - indexPath.item - 1]
            cell.taskTime.text = todayViewManager.arrayTaskTime[counts - indexPath.item - 1]
            cell.taskTime.textColor = color
            
            
            return cell
        }
        else if(collectionView == self.view3_collectionView) {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "todayCell2", for: indexPath) as? todayCell2 else {
                return UICollectionViewCell()
            }
            let counts = todayViewManager.counts
            let color = todayViewManager.colors[counts - indexPath.item - 1]
            cell.check.textColor = color
            cell.taskName.text = todayViewManager.arrayTaskName[counts - indexPath.item - 1]
            cell.taskTime.text = todayViewManager.arrayTaskTime[counts - indexPath.item - 1]
            cell.taskTime.textColor = color
            cell.background.backgroundColor = color
            
            return cell
        }
        else {
        return UICollectionViewCell()
        }
        
    }
}

class todayCell: UICollectionViewCell {
    @IBOutlet var colorView: UIView!
    @IBOutlet var taskName: UILabel!
    @IBOutlet var taskTime: UILabel!
}

class todayCell2: UICollectionViewCell {
    @IBOutlet var check: UILabel!
    @IBOutlet var taskName: UILabel!
    @IBOutlet var taskTime: UILabel!
    @IBOutlet var background: UIView!
}
