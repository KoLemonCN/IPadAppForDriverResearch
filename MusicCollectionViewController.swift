//
//  MusicCollectionViewController.swift
//  VehicleEntertainSystem
//
//  Created by Zongqi Wang on 9/2/15.
//  Copyright (c) 2015 Zongqi Wang. All rights reserved.
//

import UIKit

// the defined protocal for data exchange between musicview and collection view.
protocol MusicCollectionDelegate {
    func getModel() -> MusicModel
    func setSelectedMusicFromCollection(music:VMusic)
}


class MusicCollectionViewController: UIViewController {
    
    let DEBUG_FLAG = false
    
    // the music model passed from music view.
    var delegate : MusicCollectionDelegate?
    // the currently selected music
    var selectedMusic : VMusic?
    // a scroll view to contain all the cd views.
    var scrollView : UIScrollView!
    // a list of cd views.
    var cdViews : [UIImageView] = [UIImageView]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var length : Int = self.delegate!.getModel().vMusics.count
        var index : Int = Int(arc4random_uniform(UInt32(length)))
        selectedMusic = delegate!.getModel().vMusics[index]
        
        // pinch to go back
        var pinchGesture = UIPinchGestureRecognizer(target: self, action: "handlePinch:")
        self.view.addGestureRecognizer(pinchGesture)
        
        updateMusicViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateMusicViews() {
        // firstly, init as many image views as needed to hold for all songs
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.backgroundColor = UIColor.blackColor()
        scrollView.contentSize = CGSize(width: 600*delegate!.getModel().vMusics.count, height: 768)
        scrollView.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        self.view.addSubview(scrollView)
        
        if DEBUG_FLAG {
            var button = UIButton(frame: CGRect(x: 10, y: 10, width: 100, height: 100))
            button.setTitle("Test", forState: UIControlState.Normal)
            button.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
            button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(button)
        }

        
        var width : CGFloat = 500
        var height : CGFloat = 500
        var offX : CGFloat = 100
        var offY : CGFloat = self.view.center.y
        var firstOffX : CGFloat = 400
        
        for i in 0..<delegate!.getModel().vMusics.count {
            var vMusic = delegate!.getModel().vMusics[i]
            var img = UIImage(named: vMusic.artworkfilename)
            var view = UIImageView()
            view.bounds = CGRect(x: 0, y: 0, width: width, height: height)
            view.image = img?.circle
            view.contentMode = UIViewContentMode.ScaleAspectFill
            view.center = CGPoint(x: firstOffX+(offX+width)*CGFloat(i), y: offY)
            view.userInteractionEnabled = true
            self.scrollView.addSubview(view)
            cdViews.append(view)
            var tapGesture = UITapGestureRecognizer(target: self, action: Selector("cdTapped:"))
            view.addGestureRecognizer(tapGesture)
            
        }
    }
    
    func cdTapped(sender : UITapGestureRecognizer) {
        //selectedMusic = delegate!.vMusics[index]
        if DEBUG_FLAG {
            println("cdTapped")
        }
        
        for i in 0..<self.cdViews.count {
            if sender.view == self.cdViews[i] {
                selectedMusic = delegate!.getModel().vMusics[i]
            }
        }
        if DEBUG_FLAG {
            println("the selected music is: \(selectedMusic!)")
        }
        delegate!.setSelectedMusicFromCollection(selectedMusic!)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func buttonPressed(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }


    func handlePinch(sender: UIPinchGestureRecognizer) {
        if sender.scale < 0.7 {
            dismissViewControllerAnimated(true, completion: nil)
        }
        
    }

}
