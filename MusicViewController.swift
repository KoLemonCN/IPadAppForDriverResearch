//
//  MusicViewController.swift
//  VehicleEntertainSystem
//
//  Created by Zongqi Wang on 8/31/15.
//  Copyright (c) 2015 Zongqi Wang. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

protocol MusicPlayerDelegate {
    func changeMusicAudio(filename:String, type:String)
    func getMusicPlayer() -> AVAudioPlayer
    func getMusicFilename() -> String
}

class MusicViewController : UIViewController, UIGestureRecognizerDelegate, MusicCollectionDelegate {
    
    // external access to the audio player resource
    var musicPlayerDelegate :  MusicPlayerDelegate!
    
    let DEBUG_FLAG = false
    
    // the background for the interface, with blur affects applied to this background.
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    // the text area for the interface to show related informaiton of the songs. e.g. name.
    @IBOutlet weak var musicInfoTextView: UITextView!
    
    // the image holding the disc
    var discImageView  : UIImageView!
    
    // the image holding pecific song
    var coverImageView : UIImageView!
    
    // the timer to control the rotation animation of the cover image of the song.
    var coverAnimationTimer : NSTimer = NSTimer()
    
    // the model that holds all related information of a song.
    var musicModel : MusicModel!
    
    // the instance that is capable of playing audio files.
    var musicPlayer : AVAudioPlayer!
    
    // the instance of the music that is currently playing.
    var vMusic : VMusic!
    
    // the instance index for the song.
    var musicIndex = 1
    
    //
    
    /*
        The function to get the music model
    */
    func getModel() -> MusicModel {
        return self.musicModel
    }
    
    /*
        if a song is selected from collection view, play the selected song.
    */
    func setSelectedMusicFromCollection(music:VMusic) {
        if DEBUG_FLAG {
            println("change the selected music to:\(music)")
        }
        
        self.vMusic = music
        for i in 0..<self.musicModel.vMusics.count {
            if musicModel.vMusics[i].songfilename == vMusic.songfilename {
                self.musicIndex = i
            }
        }
        
        initMusicPlayer()
        resetUIViews()
        startMusicPlayer()
    
    }
    
    /*
        This function enables the system to recognize multiple gestures at the same time.
    */
    func gestureRecognizer(UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
            return true
    }
    
    var continueFromParent = false
    
    /*
        The set of instructions called to create the initial view of this interface.
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        if DEBUG_FLAG {
            println(backgroundImageView.bounds)
        }
        
        var currentTime = self.musicPlayerDelegate.getMusicPlayer().currentTime
        var volume = self.musicPlayerDelegate.getMusicPlayer().volume
        
        // initialize the model for the song lists.
        initModel()
        
        // initialize the music player to play the audio files.
        initMusicPlayer()
        
        // initialize the UI elements for the interface.
        initUI()
        
        // initialize the gestures that could be recgonized the interface.
        initGestures()
        
        if DEBUG_FLAG {
            println("viewDidLoad")
        }
        
        if continueFromParent {
            for i in 0..<self.musicModel.vMusics.count {
                if musicModel.vMusics[i].songfilename == self.musicPlayerDelegate.getMusicFilename() {
                    self.musicIndex = i
                    self.vMusic = musicModel.vMusics[i]
                }
            }
            
            resetUIViews()
            initMusicPlayer()
            self.musicPlayer.volume = volume
            //self.musicPlayer.currentTime = currentTime
            startMusicPlayer()
            continueFromParent = false
        }
        
    }
    /*
        initialize the gestures that could be recognized in this interface.
    */
    func initGestures() {
        // init the gestures associated with the specified views.
        //
        // 1, tap to play/pause the music.
        var tapGesture = UITapGestureRecognizer(target: self, action: Selector("coverImageViewTapped:"))
        coverImageView.addGestureRecognizer(tapGesture)
        coverImageView.userInteractionEnabled = true
        
        // pinch to go back
        var pinchGesture = UIPinchGestureRecognizer(target: self, action: "handlePinch:")
        self.view.addGestureRecognizer(pinchGesture)
        
        // pan gesture to adjust volume
        var panGesture = UIPanGestureRecognizer(target: self, action: "handlePan:")
        self.view.addGestureRecognizer(panGesture)
        
        // screen edge pan gesture to navigate the song list, may require new views
        var screenEdgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "handleScreenEdgePanGestureRight:")
        screenEdgePanGesture.edges = UIRectEdge.Right
        self.view.addGestureRecognizer(screenEdgePanGesture)
        
        // to restrict the pan gesture when screen edge pan gesture is recognized first.
        panGesture.requireGestureRecognizerToFail(screenEdgePanGesture)
    }
    
    /*
        Initialize the UI elements of the interface.
    */
    func initUI() {
        initCDViews()
    }
    
    /*
        initialize the model for the songs.
    */
    func initModel() {
        
        if DEBUG_FLAG {
            println("init MusicModel")
        }
        
        musicModel = MusicModel()
        vMusic = self.musicModel.vMusics[self.musicIndex]
    }
    
    /*
        initialize the audio player. Assuming all audio files are of type mp3.
    */
    func initMusicPlayer() {
        if !continueFromParent {
            self.musicPlayerDelegate.changeMusicAudio(vMusic.songfilename, type: vMusic.songfiletype)
        }

        musicPlayer = self.musicPlayerDelegate.getMusicPlayer()
        // keep the original volume of the songs.
        var volume : Float = 0.0
        if musicPlayer != nil {
            volume = musicPlayer.volume
        } else {
            volume = 1
        }
        
        musicPlayer.volume = volume
    }
    
    /*
        update all the UI elements according to the currently playing song.
    */
    func resetUIViews() {
        var imageName = currentMusic().songfilename
        var img = UIImage(named: imageName)!
        coverImageView.image = img.circle
        coverImageView.transform = CGAffineTransformMakeRotation(0)
        if DEBUG_FLAG {
            coverImageView.backgroundColor = UIColor.redColor()
        }
        
        // init musicInfoTextView
        // display the simple format of a song's related information.
        // Because this is not the core study of this project.
        musicInfoTextView.text = "Name: \(vMusic.songname)\nArtist: \(vMusic.artist)\nAlbum: \(vMusic.album)"
        
        // init the background
        self.backgroundImageView.image? = UIImage(named: imageName)!
    }
    
    /*
        Create the CD views.
    */
    func initCDViews() {
        // load image from file named "disc"
        discImageView = UIImageView(image: UIImage(named: "disc"))
        
        // set size and initial location
        discImageView.bounds = CGRect(x: 0, y: 0, width: 550, height: 550)
        
        // put it in the center of the view
        discImageView.center = self.view.center
        
        
        // load image for the current song
        var imageName = currentMusic().songfilename
        var img = UIImage(named: imageName)!
        
        // create image view for the image and initialize size and location
        coverImageView = UIImageView()
        coverImageView.bounds = CGRect(x: 0, y: 0, width: 450, height: 450)
        
        // change the image to a circle
        coverImageView.image = img.circle
        coverImageView.contentMode = UIViewContentMode.ScaleAspectFill
        // relocate the image to the center of the view
        coverImageView.center = self.view.center
        if DEBUG_FLAG {
            coverImageView.backgroundColor = UIColor.redColor()
        }
        
        self.view.addSubview(discImageView)
        self.view.addSubview(coverImageView)
        
        // init musicInfoTextView
        musicInfoTextView.text = "Name:\t\(vMusic.songname)\nArtist:\t\(vMusic.artist)\nAlbum:\t\(vMusic.album)"
        
        // init the background
        // if the background is found the blur effect would be automatically applied.
        self.backgroundImageView.image? = UIImage(named: imageName)!
    }
    
    /*
        If the user performed an swipe from the right edge, go to the music collectino interface.
    */
    func handleScreenEdgePanGestureRight(sender : UIScreenEdgePanGestureRecognizer) {
        
        if sender.state == UIGestureRecognizerState.Ended {
            //println("handleScreenEdgePanGestureRight present to the song list")
            performSegueWithIdentifier("MusicCollectionSegue", sender: sender)
        }
    }
    
    /*
        prepare for going to the music collection interface.
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "MusicCollectionSegue":
                let controller = segue.destinationViewController as! MusicCollectionViewController
                controller.delegate = self
                if DEBUG_FLAG {
                    println("moving to MusicCollection")
                }
                
            default:
                break
            }
        }
    }
    
    /*
        If user performed pinch gesutre, with certain sensitivity, user would go back to previous place.
    */
    func handlePinch(sender: UIPinchGestureRecognizer) {
        if sender.scale < 0.7 {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    /*
        a set of variables handling the pan gesture.
    */
    // set the initial gesture direction
    var panGestureDirection = UISwipeGestureRecognizerDirection.allZeros
    
    // the limit in pixels that trigger the pan gesture recognition
    let panGestureDirectionLimit : CGFloat = 20
    
    // the sensitivity for each pixel to change the volume
    let panGestureVolumeSensitivity : Float = 0.05
    
    // to record the initial volume
    var panGestrueVolumeOriginal : Float = -100.0
    
    // a flag to record if the pan edge gesture is being performed
    var edgeGestureIsPending : Bool = false
    
    func handlePan(sender: UIPanGestureRecognizer) {

        // first, make sure the starting point is not around the edge!
        if sender.state == UIGestureRecognizerState.Began {
            // get the location of the gesture
            var location = sender.locationInView(self.view)
            if DEBUG_FLAG {
                println("pan gesture began...\(location)")
            }
            // if the gesture begins close to the edge, 
            // then the gesture shall be ingored, 
            // because it shall be handled by pan edge gesture.
            // otherwise, the gesture would be handled in this function.
            if location.x > 1000 {
                edgeGestureIsPending = true
            } else {
                edgeGestureIsPending = false
            }
        }
        
        // if the gesture is starting from a point very close to the edge
        // terminate this function.
        if edgeGestureIsPending {
            return
        }
        
        /*
            the rest of the function deals with the pan gesture as desired.
        */
        // get the translation, including vertial and horizontal distance.
        let translation = sender.translationInView(self.view)
        // get the current speed of the gesture in vertical and horizontal.
        let velocity = sender.velocityInView(self.view)
        
        if DEBUG_FLAG {
            println("translation:\(translation)")
            println("velocity:\(velocity)")
        }

        // if no direction has been assigned, we want to decide the direction
        if panGestureDirection == UISwipeGestureRecognizerDirection.allZeros {
            
            // if the distance exceeds the limit, apply the direction assignment.
            if abs(translation.x) > panGestureDirectionLimit &&  abs(translation.x) > abs(translation.y) {
                
                // could be left or right
                if DEBUG_FLAG {
                    println("left or right \(translation.x)")
                }
                if translation.x > 0 {
                    // right
                    panGestureDirection = UISwipeGestureRecognizerDirection.Right
                } else {
                    // left
                    panGestureDirection = UISwipeGestureRecognizerDirection.Left
                }
            }
            
            // if the distance exceeds the limit, apply the direction assignment.
            if abs(translation.y) > panGestureDirectionLimit &&  abs(translation.y) > abs(translation.x) {
                
                // could be up or down
                if DEBUG_FLAG {
                    println("up or down \(translation.y)")
                }
                
                if translation.y > 0 {
                    // down
                    panGestureDirection = UISwipeGestureRecognizerDirection.Down
                } else {
                    // up
                    panGestureDirection = UISwipeGestureRecognizerDirection.Up
                }
                
            }
        }
        
        if DEBUG_FLAG {
            switch panGestureDirection {
            case UISwipeGestureRecognizerDirection.Up:
                println("up")
            case UISwipeGestureRecognizerDirection.Down:
                println("down")
            case UISwipeGestureRecognizerDirection.Left:
                println("left")
            case UISwipeGestureRecognizerDirection.Right:
                println("right")
            case UISwipeGestureRecognizerDirection.allZeros:
                println("no direction")
            default:
                println("error")
            }
        }
        
        // for up and down, change the volume
        if panGestureDirection == UISwipeGestureRecognizerDirection.Up || panGestureDirection == UISwipeGestureRecognizerDirection.Down {
            if panGestrueVolumeOriginal < 0 {
                panGestrueVolumeOriginal = musicPlayer.volume
            }
            var volumeChange =  Float(-translation.y / panGestureDirectionLimit) * panGestureVolumeSensitivity
            //println("\(volumeChange)")
            var result = panGestrueVolumeOriginal + volumeChange
            if result > 1 {
                // the volume cannot exceed 1
                musicPlayer.volume = 1
            } else if result < 0 {
                // the volume cannot be negative
                musicPlayer.volume = 0
            } else {
                musicPlayer.volume = result
            }
            if DEBUG_FLAG {
                println("setting volume:\(musicPlayer.volume)")
            }
            
        }
        
        // trigger the actions when the gesture is over.
        if sender.state == UIGestureRecognizerState.Ended {
            
            // for left and right, go to previous track or next track
            if panGestureDirection == UISwipeGestureRecognizerDirection.Left  {
                if DEBUG_FLAG {
                    println("play next song")
                }
                
                playNextMusic()
                
            }
            
            if panGestureDirection == UISwipeGestureRecognizerDirection.Right {
                if DEBUG_FLAG {
                    println("play previous song")
                }
                
                playPreviousMusic()
            }
            
            // reset to initial value
            self.panGestrueVolumeOriginal = -100.0
            self.panGestureDirection = UISwipeGestureRecognizerDirection.allZeros
        }
        
    }
    
    /*
        play the previous sound track
    */
    func playPreviousMusic() {
        self.musicPlayer.stop()
        vMusic = previousMusic()
        initMusicPlayer()
        resetUIViews()
        startMusicPlayer()
    }
    
    /*
        play the next sound track
    */
    func playNextMusic() {
        self.musicPlayer.stop()
        vMusic = nextMusic()
        initMusicPlayer()
        resetUIViews()
        startMusicPlayer()
    }
    
    /*
        the action being called whent the CD image is tapped.
    */
    func coverImageViewTapped(sender:UITapGestureRecognizer) {
        if DEBUG_FLAG {
            println("coverImageViewTapped \(sender)")
        }
        // play something
        self.toggleMusicPlayer()
    }
    
    /*
        a concise function. If the music is playing, pause it. otherwise play it.
    */
    func toggleMusicPlayer() {
        if self.musicPlayer.playing {
            pauseMusicPlayer()
        } else {
            startMusicPlayer()
        }
    }
    
    /*
        start to play the music and apply animation.
    */
    func startMusicPlayer() {
        self.musicPlayer.play()
        self.startCoverAnimation()
    }
    
    /*
        pause the currently playing music and animation.
    */
    func pauseMusicPlayer() {
        self.musicPlayer.pause()
        self.stopCoverAnimation()
    }
    
    /*
        start the cover animation
    */
    func startCoverAnimation() {
        if self.coverAnimationTimer.valid {
            return
        }
        coverAnimationTimer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: Selector("rotateCoverImage"), userInfo: nil, repeats: true)
    }
    
    /*
        the function is used to create cover rotation animation.
    */
    func rotateCoverImage() {
        let view = coverImageView
        // get the current radians
        let radians = atan2f(Float(view.transform.b), Float(view.transform.a))
        // apply the transform to rotate the view, adding 1 degree to the current radian.
        view.transform = CGAffineTransformMakeRotation(CGFloat(Double(radians) + M_PI/180.0))

        // if the music is over, restart the current music.
        // the default behavior.
        // for a complete music controller, shall provide interface to change this setting.
        // e.g. play next, repeat, random and etc...
        if musicPlayer.currentTime >= musicPlayer.duration {
            self.musicPlayer.stop()
            self.startMusicPlayer()
        }
        
    }
    
    /*
        stop the cover rotation animation.
    */
    func stopCoverAnimation() {
        if self.coverAnimationTimer.valid {
            self.coverAnimationTimer.invalidate()
        }

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        println(self.musicPlayer.currentTime)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // get rid of the background so the animation goes smoothly
    }
    
    /*
        get the current music that is being loaded by the controller.
    */
    func currentMusic() -> VMusic {
        return self.musicModel.vMusics[musicIndex]
    }
    
    /*
        load the next music from the list.
    */
    func nextMusic() -> VMusic {
        musicIndex++
        if musicIndex >= self.musicModel.vMusics.count {
            musicIndex = 0
        }
        
        return musicModel.vMusics[musicIndex]
    }
    
    /*
        load the previous music form the list.
    */
    func previousMusic() -> VMusic {
        musicIndex--
        if musicIndex < 0 {
            musicIndex = self.musicModel.vMusics.count - 1
        }
        return musicModel.vMusics[musicIndex]
    }
    
    /*
        the special function controls the data back from the unwind segue
    */
    @IBAction func unwindFromMusicCollection(segue:UIStoryboardSegue) {
        println("unwindFromMusicCollection")
        
        var found = false
        if let source = segue.sourceViewController as? MusicCollectionViewController {
            var selectedMusic = source.selectedMusic!
            for i in 0..<self.musicModel.vMusics.count {
                if musicModel.vMusics[i].songfilename == selectedMusic.songfilename {
                    self.musicIndex = i
                    self.vMusic = selectedMusic
                    found = true
                }
            }
        }
        
        // if the music from selected song was not found
        if !found {
            println("unexpected song was selected. break here for debug.")
        }
        
        initMusicPlayer()
        resetUIViews()
        startMusicPlayer()
    }
    
}