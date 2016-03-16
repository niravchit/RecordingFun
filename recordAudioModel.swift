//
//  recordAudioModel.swift
//  RecordingFun
//
//  Created by Nirav Chitkara on 10/7/15.
//  Copyright © 2015 Chitter Org. All rights reserved.
//

import Foundation //key framework for use with Strings and Arrays
import AVFoundation

//Model of our RecordingFun app

//class inherits from NSObject, which is the root class for most classes in iOS
class RecordedAudio: NSObject{
    
    //how we pass stored audio - we need the filepath url and the name of the recorded audio
    var filePathURL: NSURL!
    var songTitle: String!
    
}

//extension   AVAudioFile{
//    
//    var title: String?
//    {
//        get{
//            return self.title
//        }
//        set{
//            self.title = newValue
//        }
//    }
//}
