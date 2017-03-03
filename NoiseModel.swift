//
//  NoiseModel.swift
//  VehicleEntertainSystem
//
//  Created by Zongqi Wang on 9/13/15.
//  Copyright (c) 2015 Zongqi Wang. All rights reserved.
//

import Foundation
public class NoiseModel {
    
    let DEBUG_FLAG = true
    public var vNoises = [VNoise]()
    
    public init() {
        if DEBUG_FLAG {
            println("init Noise Model")
        }
        
        // get the music plist from the main directory
        if let path = NSBundle.mainBundle().pathForResource("Noise", ofType: "plist") {
            let noisePlist = NSArray(contentsOfFile: path)!
            
            if DEBUG_FLAG {
                println(noisePlist)
            }
            
            // load the plist into the model
            // each one of the song information would be saved as vNoise
            // and then stored in the list for later access.
            for i in 0..<noisePlist.count {
                var vNoise = VNoise(songfilename: noisePlist[i] as! String, songname: noisePlist[i] as! String, songtype: "")
                self.vNoises.append(vNoise)
            }
        }
        
        if DEBUG_FLAG {
            for i in 0..<self.vNoises.count {
                println("\(i):\t\(vNoises[i])")
            }
        }

    }
    
}

/*
a class for storing the noise information.
*/
public class VNoise : Printable {
    var songfilename : String!
    var songname : String!
    // by default the type of the audio file would be mp3.
    var songfiletype : String = "mp3"
    var songtype : String!
    
    public init(songfilename: String, songname: String, songtype: String) {
        self.songfilename = songfilename
        self.songname = songname
        self.songtype = songtype
    }
    
    public var description: String {
        return "VNoise songfilename:\(songfilename), songname:\(songname), songtype:\(songtype)"
    }
}
