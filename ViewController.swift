//
//  ViewController.swift
//  VehicleEntertainSystem
//
//  Created by Zongqi Wang on 8/31/15.
//  Copyright (c) 2015 Zongqi Wang. All rights reserved.
//

import UIKit
import AVFoundation
/*
    an extension for the images get shaped.
    the source code is available from the github.
*/
extension UIImage {
    var rounded: UIImage {
        let imageView = UIImageView(image: self)
        imageView.layer.cornerRadius = size.height < size.width ? size.height/2 : size.width/2
        imageView.layer.masksToBounds = true
        UIGraphicsBeginImageContext(imageView.bounds.size)
        imageView.layer.renderInContext(UIGraphicsGetCurrentContext())
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    var circle: UIImage {
        let square = size.width < size.height ? CGSize(width: size.width, height: size.width) : CGSize(width: size.height, height: size.height)
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: square))
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.image = self
        imageView.layer.cornerRadius = square.width/2
        imageView.layer.masksToBounds = true
        UIGraphicsBeginImageContext(imageView.bounds.size)
        imageView.layer.renderInContext(UIGraphicsGetCurrentContext())
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }

}

class ViewController: UIViewController, NoisePlayerDelegate, MusicPlayerDelegate {

    var noisePlayer : AVAudioPlayer!
    var musicPlayer : AVAudioPlayer!
    var musicFilename = "Alan Walker - Fade"
    
    @IBOutlet weak var centerScrollview: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // there are three pages of icons to be displayed
        // user could swipe to explore.
        // the content and attributes of the UI elements were set in the storyboard.
        centerScrollview.contentSize.width = 1024 * 3
        
        let noiseUrl = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Fan 01", ofType: "mp3")!)
        noisePlayer = AVAudioPlayer(contentsOfURL: noiseUrl, error: nil)
        
        let musicUrl = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(musicFilename, ofType: "mp3")!)
        musicPlayer = AVAudioPlayer(contentsOfURL: musicUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func iconTapped(sender: UITapGestureRecognizer) {
        performSegueWithIdentifier("dummySegue", sender: sender)
    }
    
    @IBAction func musicTapped(sender: UITapGestureRecognizer) {
        performSegueWithIdentifier("musicSegue", sender: sender)
    }
    
    @IBAction func heatTapped(sender: UITapGestureRecognizer) {
        performSegueWithIdentifier("heatSegue", sender: sender)
    }
    
    @IBAction func fanTapped(sender: UITapGestureRecognizer) {
        performSegueWithIdentifier("fanSegue", sender: sender)
    }
    
    /*
        This function is used to prepare for a segue to next view.
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "dummySegue":
                    // for development purpose, the dummy interface is chosen as default.
                    let controller = segue.destinationViewController as! DummyViewController
                    let view = sender?.view as! UIImageView
                    controller.dummyImage = view.image
                    controller.dummyInfo = "This section is under development."
            case "musicSegue":
                let controller = segue.destinationViewController as! MusicViewController
                controller.musicPlayerDelegate = self
                controller.continueFromParent = true
                println("Prepare for music segue")
            case "heatSegue":
                println("Prepare for heat segue")
            case "fanSegue":
                //
                let controller = segue.destinationViewController as! FanViewController
                controller.noisePlayerDelegate = self
                if noisePlayer.playing {
                    noisePlayer.pause()
                }
                println("Prepare for fan segue")
            default:
                break
            }
        }
    }
    
    func changeNoiseAudio(filename:String, type:String) {
        if noisePlayer.playing {
            noisePlayer.stop()
        }
        let noiseUrl = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(filename, ofType: type)!)
        noisePlayer = AVAudioPlayer(contentsOfURL: noiseUrl, error: nil)
        noisePlayer.volume = 0.2
        noisePlayer.numberOfLoops = -1
        noisePlayer.play()
    }
    
    
    func getNoisePlayer() -> AVAudioPlayer {
        return self.noisePlayer
    }
    
    func changeMusicAudio(filename:String, type:String) {
        if musicPlayer.playing {
            musicPlayer.stop()
        }
        let musicUrl = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(filename, ofType: type)!)
        musicPlayer = AVAudioPlayer(contentsOfURL: musicUrl, error: nil)
        self.musicPlayer.numberOfLoops = -1
        self.musicFilename = filename
    }
    
    func getMusicPlayer() -> AVAudioPlayer {
        return self.musicPlayer
    }
    
    func getMusicFilename() -> String {
        return musicFilename
    }

}

