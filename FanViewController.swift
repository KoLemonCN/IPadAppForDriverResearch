//
//  FanViewController.swift
//  VehicleEntertainSystem
//
//  Created by Zongqi Wang on 8/31/15.
//  Copyright (c) 2015 Zongqi Wang. All rights reserved.
//

import UIKit
import AVFoundation

protocol NoisePlayerDelegate {
    func changeNoiseAudio(filename:String, type:String)
    func getNoisePlayer() -> AVAudioPlayer
}

class FanViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var tableView: UITableView!
    var noiseModel : NoiseModel!
    var noisePlayerDelegate : NoisePlayerDelegate!
    // the instance that is capable of playing audio files.
    var audioPlayer : AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // pinch to go back
        var pinchGesture = UIPinchGestureRecognizer(target: self, action: "handlePinch:")
        self.view.addGestureRecognizer(pinchGesture)
        
        self.noiseModel = NoiseModel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.noiseModel.vNoises.count
    }

    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //NoiseCollectionCell
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
    
        cell.textLabel?.text = noiseModel.vNoises[indexPath.row].songname
        
        return cell
    }
    
    func handlePinch(sender: UIPinchGestureRecognizer) {
        self.noisePlayerDelegate.getNoisePlayer().stop()
        
        if sender.scale < 0.7 {
            self.navigationController?.popViewControllerAnimated(true)
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("selected in \(indexPath.row)")
        
        noisePlayerDelegate.changeNoiseAudio(self.noiseModel.vNoises[indexPath.row].songfilename,  type:self.noiseModel.vNoises[indexPath.row].songfiletype)
        noisePlayerDelegate.getNoisePlayer().play()

    }

}
