//
//  DummyViewController.swift
//  VehicleEntertainSystem
//
//  Created by Zongqi Wang on 8/31/15.
//  Copyright (c) 2015 Zongqi Wang. All rights reserved.
//

import Foundation
import UIKit

class DummyViewController : UIViewController {
    
    var dummyInfo : String?
    var dummyImage : UIImage?
    
    @IBOutlet weak var dummyUIImageView: UIImageView!
    @IBOutlet weak var dummyUITextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateUI()
        
    }
    
    func updateUI() {
        println("updatingui: dummyinfo=\(dummyInfo)")
        if let text = dummyInfo {
            dummyUITextView.text = text
        }
        if let image = dummyImage {
            dummyUIImageView.image = image
        }
    }
    
    @IBAction func pinched(sender: UIPinchGestureRecognizer) {
        if sender.scale < 0.7 {
            self.navigationController?.popViewControllerAnimated(true)
        }

    }
    
    
}