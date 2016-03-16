//
//  SoundEffectsViewController.swift
//  RecordingFun
//
//  Created by Nirav Chitkara on 10/1/15.
//  Copyright © 2015 Chitter Org. All rights reserved.
//

import UIKit
import AVFoundation

class SoundEffectsViewController: UIViewController {
    
    //Declare global variable audioPlayer of type AVAudioPlayer
    var audioPlayer: AVAudioPlayer!
    
    //Global variable in which we will store our audio recording
    //Of type RecordedAudio from our Model class
    var receivedAudio: RecordedAudio!
    
    //Global variable audioEngine to play more complex sounds
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var audioFile: AVAudioFile! //global variable for AVAudioFile
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        //if let url = NSBundle.mainBundle().URLForResource("movie_quote", withExtension: "mp3"){
        
        audioPlayer = try! AVAudioPlayer (contentsOfURL: receivedAudio.filePathURL) //try to initialize audioPlayer with url content from the receivedAudio filepath, the variable that has our data
        audioPlayer.enableRate = true //allow for adjusting the playback rate
        
        //Create new instance of Audio Engine
        
        audioEngine = AVAudioEngine()
        
        //Initialize audio file
        try! audioFile = AVAudioFile(forReading: receivedAudio.filePathURL)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func slowSoundEffect(sender: UIButton)
    {
        audioChange(soundEffect.Slow)
    }

    @IBAction func fastSoundEffect(sender: UIButton)
    {
        audioChange(soundEffect.Fast)
    }
   
    @IBAction func chipmunkSound(sender: UIButton)
    {
        audioChange(soundEffect.Chipmunk)
    }
    
    @IBAction func vaderSound(sender: UIButton)
    {
        audioChange(soundEffect.Vader)
    }
    @IBAction func stopAudio(sender: UIButton)
    {
        audioPlayer.stop()
    }
    
    private func changePitchSoundEffect(pitchNum: Float){
        audioPlayer.stop() //stop the audio player
        audioEngine.stop() //stop the engine
        audioEngine.reset() //reset the engine
        
        audioPlayerNode = AVAudioPlayerNode() //create a new instance of an audioPlayerNode
        audioEngine.attachNode(audioPlayerNode)
        let pitchPlay = AVAudioUnitTimePitch() //create a new instance of a pitch object
        pitchPlay.pitch = pitchNum //set it to the function parameter
        audioEngine.attachNode(pitchPlay)
        audioEngine.connect(audioPlayerNode, to: pitchPlay, format: nil)
        audioEngine.connect(pitchPlay, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil) //buffer the file for the audio file
        try! audioEngine.start() //try starting the engine with a nil throw
        audioPlayerNode.play() //play the node
        
    }
    
    private func changeRateSoundEffect(rateNum: Float){
        audioPlayer.stop() //good to stop the audio player, like resetting the cache
        audioEngine.stop() //stop the audioEngine to prevent overlap
        audioEngine.reset() //reset it
        audioPlayer.rate = rateNum
        audioPlayer.currentTime = 0 //make sure effect restarts playback when pressed and not current position when pressed
        audioPlayer.play() //play sound when button is pressed
    }
    
    private enum soundEffect {case Slow, Fast, Chipmunk, Vader} //enumeration allows to go between different sound effect cases
    
    //Audio function that allows us to change between different sound effects from our enum
    private func audioChange(effect: soundEffect){
        
        //switch between different sound effects
        switch effect{
        case .Slow:
            changeRateSoundEffect(0.5)
        case .Fast:
            changeRateSoundEffect(2.0)
        case .Chipmunk:
            changePitchSoundEffect(1000.0)
        case .Vader:
            changePitchSoundEffect(-1000.0)
            
            
        }
    }

}
