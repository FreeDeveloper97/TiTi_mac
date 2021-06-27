//
//  TodayViewController.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2021/06/10.
//  Copyright © 2021 FDEE. All rights reserved.
//

import UIKit

class TodayViewController: UIViewController {

    @IBOutlet var view1: UIView!
    @IBOutlet var view2: UIView!
    @IBOutlet var view3: UIView!
    @IBOutlet var view4: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRadius()
        setShadow(view1)
        setShadow(view2)
        setShadow(view3)
        setShadow(view4)
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension TodayViewController {
    func setRadius() {
        view1.layer.cornerRadius = 20
        view2.layer.cornerRadius = 20
        view3.layer.cornerRadius = 20
        view4.layer.cornerRadius = 20
    }
    
    func setShadow(_ view: UIView) {
        view.layer.shadowColor = UIColor(named: "shadow")?.cgColor
        view.layer.shadowOpacity = 0.6
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 6
    }
}
