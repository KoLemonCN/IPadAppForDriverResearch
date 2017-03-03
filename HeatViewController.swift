//
//  HeatViewController.swift
//  VehicleEntertainSystem
//
//  Created by Zongqi Wang on 8/31/15.
//  Copyright (c) 2015 Zongqi Wang. All rights reserved.
//

import UIKit

class HeatViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // pinch to go back
        var pinchGesture = UIPinchGestureRecognizer(target: self, action: "handlePinch:")
        self.view.addGestureRecognizer(pinchGesture)
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handlePinch(sender: UIPinchGestureRecognizer) {
        if sender.scale < 0.7 {
            self.navigationController?.popViewControllerAnimated(true)
        }
        
    }

}
