//
//  GraphViewController.swift
//  Project_Timer
//
//  Created by Kang Minsang on 2021/02/23.
//  Copyright © 2021 FDEE. All rights reserved.
//

import UIKit
import SwiftUI

class GraphViewController: UIViewController {

    @IBOutlet var viewOfView: UIView!
    @IBOutlet weak var backBT: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //맥용 코드
        setBackBT()

        let hostingController = UIHostingController(rootView: ContentView())
        hostingController.view.translatesAutoresizingMaskIntoConstraints = true
        hostingController.view.frame = viewOfView.bounds
        ContentView().appendDailyDatas(isDumy: false)
//        ContentView().appendDumyDatas()
        addChild(hostingController)
        viewOfView.addSubview(hostingController.view)
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
