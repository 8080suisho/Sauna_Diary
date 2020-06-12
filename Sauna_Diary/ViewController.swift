//
//  ViewController.swift
//  Sauna_Diary
//
//  Created by 諸星水晶 on 2020/05/19.
//  Copyright © 2020 諸星水晶. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1 : UIButton!
    @IBOutlet var button3 : UIButton!
    
    @IBAction func back(sender: UIStoryboardSegue){
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        button1.layer.cornerRadius = 10
        button3.layer.cornerRadius = 10
        
    }


}

