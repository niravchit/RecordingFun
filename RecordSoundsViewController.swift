//
//  RecordSoundsViewController.swift
//  RecordingFun
//
//  Created by Nirav Chitkara on 9/29/15.
//  Copyright © 2015 Chitter Org. All rights reserved.
//

import UIKit
import AVFoundation


//RecordSoundsViewController is also the delegate for AVAudioRecorder
class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordingLabel: UILabel!
    
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder: AVAudioRecorder! //global audio recorder object
    var recordedAudio: RecordedAudio! //global recorded audio object for saving files
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        //Called right when before the view shows to the user
        
        //TODO: Hide the stop button
        stopButton.hidden = true
        
        //enable recording button  
        recordButton.enabled = true
        recordingLabel.enabled = true
        recordingLabel.text = "Tap to Record"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    

    @IBAction func recordAudio(sender: UIButton) {
        //TODO: Show text telling user that recording in progress
        //TODO: Record user's voice
        
        //print("in recordAudio")
        //recordingLabel.hidden = false
        recordingLabel.text = "Recording..."
        stopButton.hidden = false
        
        //disable the record button
        recordButton.enabled = false
        
        //App can't store files anywhere in phone - has to store it in a specific directory within our app
        //.DocumentDirectory - directory container in app that can be directly accessed where user created data for app is stored
        //.UserDomainMask is the user's home director to store personal items of the user
        //better to user NSFileManager methods: URLForDirectories:inDomains:
        //NSSearchPathForDirectoriesInDomains returns an array of Strings, getting first item as type casting as a String object
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        //Set up to ensure that each recording as a different name associated with the recording time and date specifically formatted how we want
        //*Deleted* for now since managing user data in directories isn't covered in this course so don't want storage to run short
        //let currentTime = NSDate()
        //let formatter = NSDateFormatter()
        //formatter.dateFormat = "ddMMyyyy-HHmmss" //dateFormat is a get/set property so setting format to as so
        
        //Set name of the recording - using the same name for each new recording will allow files to be overwritten
        let recordingName = "my_recording.wav" //set the name for the recording
        
        let pathArray = [dirPath,recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray) //gets the file path from the components of an array of strings
        print(filePath)
        
        //Setup Audio Session
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        //Initialize audio recorder and prepare the recorder
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self //after initializing audioRecorder as an AVAudioRecorder, set it's delegate to be the RecordSoundsViewController
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
        
        
        
        
    }
    
    //*Note: Stop is no longer the segue to the next scene since we want to ensure that the recorded audio has time to process and store
    //*Note: Before we had the segue linked to the stop button, so the next scene would come pretty quickly without giving enough time to process the recording and carry over the recording to the next scene
    @IBAction func stopAudio(sender: UIButton) {
        //recordingLabel.hidden = true
        audioRecorder.stop()
        
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
        
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        //ToDo: save recorded audio
        if flag{ //if flag is true, i.e. the audio recorded successfully
            recordedAudio = RecordedAudio() //initialize recordedAudio
            recordedAudio.filePathURL = recorder.url //attribute of AVAudioRecorder when initialized
            recordedAudio.songTitle = recorder.url.lastPathComponent //gives the title from the url
            
            //ToDo: segue from this scene to the next (using performSegue() function)
            
            self.performSegueWithIdentifier("recordToSoundEffects", sender: recordedAudio) //perform the segue with the sender object of the segue be the recordedAudio object
        } else{
            print("Recording didn't save successfully, please re-record")
            recordingLabel.hidden = true //hide the recording label again
            recordButton.enabled = true //allow the recording button to be enabled again to re-record
            stopButton.hidden = true //hide the stop button until recording happens
        }
    }
    
    //gets called before a segue is about to be performed so great place to pass data
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "recordToSoundEffects" {
            if let soundEffectsVC: SoundEffectsViewController = segue.destinationViewController as? SoundEffectsViewController //check if you can downcast the destionationViewController as a SoundEffectsViewController otherwise it'll return nil since its an optional
            {
                //retrieve the recorded audio data
                let data = sender as! RecordedAudio //sender is parameter that initiates segue, which is recordAudio object which has the file path url and title
                soundEffectsVC.receivedAudio = data //set the audio data as the receivedAudio variable in the SoundEffectsViewController
            }
        }
    }
    
}

