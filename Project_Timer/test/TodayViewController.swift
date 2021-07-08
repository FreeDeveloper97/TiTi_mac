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
    @IBOutlet var inputFraim: UIView!
    @IBOutlet var input: UITextField!
    @IBOutlet var add: UIButton!
    @IBOutlet var view4_collectionView: UICollectionView!
    
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
    
    @IBOutlet var selectDayBT: UIButton!
    @IBOutlet var selectDay: UILabel!
    @IBOutlet var selectDayBgView: UIView!
    @IBOutlet var backBT: UIButton!
    
    let todayViewManager = TodayViewManager()
    var weeks: [UIView] = []
    var weeks2: [UIView] = []
    
    let todoListViewModel = TodolistViewModel()
    
    var dateIndex: Int?
    let dateFormatter = DateFormatter()
    let dailyViewModel = DailyViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        
        weeks = [sun, mon, tue, wed, thu, fri, sat]
        weeks2 = [view3_sun, view3_mon, view3_tue, view3_wed, view3_thu, view3_fri, view3_sat]
        
        todayViewManager.getColor()
        setRadius()
        setShadow(view1)
        setShadow(view2)
        setShadow(view3)
        setShadow(view4)
        setShadowDayBgView()
        
        //저장된 dailys들 로딩
        dailyViewModel.loadDailys()
        
        getColor()
        let isDumy: Bool = false //앱스토어 스크린샷을 위한 더미데이터 여부
        showDatas(isDumy: isDumy)
        showSwiftUIGraph(isDumy: isDumy)
        
        todoListViewModel.loadTodos()
        
        dateFormatter.dateFormat = "yyyy.MM.dd"
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
        
        reset()
    }
    
    @IBAction func addList(_ sender: Any) {
        guard let text = input.text, text.isEmpty == false else { return }
        let todo = TodoManager.shared.createTodo(text: text)
        todoListViewModel.addTodo(todo)
        
        view4_collectionView.reloadData()
        input.text = ""
        self.view.endEditing(true)
        self.view.layoutIfNeeded()
    }
    
    @IBAction func showCalendar(_ sender: Any) {
        showCalendar()
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
        
        inputFraim.clipsToBounds = true
        inputFraim.layer.cornerRadius = 25
        inputFraim.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        selectDayBgView.layer.cornerRadius = 12
    }
    
    func setShadow(_ view: UIView) {
        view.layer.shadowColor = UIColor(named: "shadow")?.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 5
    }
    
    func setShadowDayBgView() {
        selectDayBgView.layer.masksToBounds = false
        selectDayBgView.layer.shadowColor = todayViewManager.COLOR.cgColor
        selectDayBgView.layer.shadowOpacity = 0.5
        selectDayBgView.layer.shadowOffset = CGSize.zero
        selectDayBgView.layer.shadowRadius = 5.5
        
        selectDay.layer.shadowColor = todayViewManager.COLOR.cgColor
        selectDay.layer.shadowOpacity = 1
        selectDay.layer.shadowOffset = CGSize(width: 1, height: 0.5)
        selectDay.layer.shadowRadius = 1.5
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
        let height: CGFloat = 150
        let hostingController = UIHostingController(rootView: todayContentView(colors: [Color("D\(colorSecond)"), Color("D\(colorNow)")], frameHeight: height, height: height-3, fontSize: 10))
        hostingController.view.translatesAutoresizingMaskIntoConstraints = true
        hostingController.view.frame = timeline.bounds
        todayContentView().appendTimes(isDumy: isDumy, daily: todayViewManager.daily)
        
        addChild(hostingController)
        timeline.addSubview(hostingController.view)
        
        todayContentView().reset()
        //frame3
        let height2: CGFloat = 200
        let hostingController2 = UIHostingController(rootView: todayContentView(colors: [Color("D\(colorSecond)"), Color("D\(colorNow)")], frameHeight: height2, height: height2-5, fontSize: 15))
        hostingController2.view.translatesAutoresizingMaskIntoConstraints = true
        hostingController2.view.frame = view3_timeline.bounds
        todayContentView().appendTimes(isDumy: isDumy, daily: todayViewManager.daily)
        
        addChild(hostingController2)
        view3_timeline.addSubview(hostingController2.view)
    }
    
    func showDatas(isDumy: Bool) {
        if(dateIndex == nil) {
            todayViewManager.daily.load()
        } else {
            //배열에 있는 daily 보이기
            todayViewManager.daily = dailyViewModel.dailys[dateIndex!]
        }
        
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
            todayViewManager.setTimesColor(sumTime, view3_sumTime, maxTime, view3_maxTime)
            print("no data")
        }
    }
    
    func setHeight() {
        if(todayViewManager.array.count < 8) {
            collectionHeight.constant = CGFloat(24*todayViewManager.array.count)
        }
    }
    
    func showCalendar() {
        let setVC = storyboard?.instantiateViewController(withIdentifier: "calendarViewController") as! calendarViewController
        setVC.calendarViewControllerDelegate = self
        present(setVC,animated: true,completion: nil)
    }
    
    func reset() {
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
        view4_collectionView.reloadData()
    }
}

extension TodayViewController: selectCalendar {
    func getDailyIndex() {
        dateIndex = UserDefaults.standard.value(forKey: "dateIndex") as? Int ?? nil
        selectDay.text = dateFormatter.string(from: dailyViewModel.dates[dateIndex!])
        reset()
    }
}

extension TodayViewController: UICollectionViewDataSource {
    //몇개 표시 할까?
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == self.view4_collectionView) {
            return todoListViewModel.todos.count
        } else {
            return todayViewManager.counts
        }
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodoCell", for: indexPath) as? TodoCell else {
                return UICollectionViewCell() }
            
            var todo = todoListViewModel.todos[indexPath.item]
            let index = todayViewManager.startColor
            cell.check.tintColor = UIColor(named: "D\(index)")
            cell.colorView.backgroundColor = UIColor(named: "D\(index)")
            cell.updateUI(todo: todo)
            self.view.layoutIfNeeded()
            
            cell.doneButtonTapHandler = { isDone in
                todo.isDone = isDone
                self.todoListViewModel.updateTodo(todo)
                self.view4_collectionView.reloadData()
            }
            
            cell.deleteButtonTapHandler = {
                self.todoListViewModel.deleteTodo(todo)
                self.view4_collectionView.reloadData()
            }
            
            return cell
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

class TodoCell: UICollectionViewCell {
    @IBOutlet weak var check: UIButton!
    @IBOutlet weak var text: UILabel!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var delete: UIButton!
    
    var doneButtonTapHandler: ((Bool) -> Void)?
    var deleteButtonTapHandler: (() -> Void)?
    
    @IBAction func checkTapped(_ sender: Any) {
        check.isSelected = !check.isSelected
        let isDone = check.isSelected
        showColorView(isDone)
        delete.isHidden = !isDone
        doneButtonTapHandler?(isDone)
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        deleteButtonTapHandler?()
    }
    
    func reset() {
        delete.isHidden = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        reset()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
    func updateUI(todo: Todo) {
        check.isSelected = todo.isDone
        text.text = todo.text
        delete.isHidden = todo.isDone == false
        showColorView(todo.isDone)
    }
    
    private func showColorView(_ show: Bool) {
        if show {
            colorView.alpha = 0.5
        } else {
            colorView.alpha = 0
        }
    }
    
    
}
