//
//  MusicModel.swift
//  VehicleEntertainSystem
//
//  Created by Zongqi Wang on 9/1/15.
//  Copyright (c) 2015 Zongqi Wang. All rights reserved.
//

import Foundation

public class MusicModel {
    
    let DEBUG_FLAG = false
    public var vMusics = [VMusic]()
   
    public init() {
        if DEBUG_FLAG {
            println("init Music Model")
        }
        
        // get the music plist from the main directory
        if let path = NSBundle.mainBundle().pathForResource("Music", ofType: "plist") {
            let musicPlist = NSArray(contentsOfFile: path)!
            
            if DEBUG_FLAG {
                println(musicPlist)
            }
            
            // load the plist into the model
            // each one of the song information would be saved as vMusic
            // and then stored in the list for later access.
            for i in 0..<musicPlist.count {
                var dict : NSDictionary = musicPlist[i] as! NSDictionary
                var vMusic = VMusic(songfilename: dict["songfilename"] as! String, songname: dict["songname"] as! String, artist: dict["artist"] as! String, album: dict["album"] as! String, artworkfilename: dict["artworkfilename"] as! String)
                self.vMusics.append(vMusic)
            }
        }
        
        if DEBUG_FLAG {
            for i in 0..<self.vMusics.count {
                println("\(i):\t\(vMusics[i])")
            }
        }

        
    }

}

/*
    a class for storing the music information.
*/
public class VMusic : Printable {
    var album : String!
    var songfilename : String!
    var songname : String!
    var artist : String!
    var artworkfilename : String!
    // by default the type of the audio file would be mp3.
    var songfiletype : String = "mp3"

    public init(songfilename: String, songname: String, artist:String, album:String, artworkfilename:String) {
        self.album = album
        self.artist = artist
        self.artworkfilename = artworkfilename
        self.songfilename = songfilename
        self.songname = songname
    }
    
    public var description: String {
        return "VMusic songfilename:\(songfilename), artworkfilename:\(artworkfilename), songname\(songname), artist\(artist), album\(album)"
    }
}





