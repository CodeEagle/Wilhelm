//
//  ViewController.swift
//  WilhelmVanAstrea
//
//  Created by LawLincoln on 2016/10/9.
//  Copyright © 2016年 LawLincoln. All rights reserved.
//

import UIKit
import Wilhelm
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let control = Wilhelm.ServerSideAppControl(version: "6.1.0", forceUpdate: false)
        let lang: Wilhelm.ITCLanguage = .cn
        Wilhelm.handle(app: "net.luoo.LuooFM", extraInfo: control, language: lang)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
