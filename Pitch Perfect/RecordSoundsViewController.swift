//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Christian Whitesides on 3/8/15.
//  Copyright (c) 2015 ChristianWhitesides. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var tapToRecord: UILabel!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var continueRecording: UILabel!
    
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    
    override func viewWillAppear(animated: Bool)
    {
        stopButton.hidden = true
        pauseButton.hidden = true
        pauseButton.enabled = true
        resumeButton.hidden = true
        recordButton.enabled = true
        recordingInProgress.hidden = true
        tapToRecord.hidden = false
        continueRecording.hidden = true
    }

    
    //
    // Function: recordAudio
    //
    // Description:
    //
    //   From the AVFoundation framework, we're using the AVAudioRecorder library to
    //   record audio (line 23).
    //
    //   Line 67 provides a path to the .DocumentDirectory in our app. Lines 67 - 75
    //   help us access the filePath of each recording, which is required in order to
    //   record (lines 80-84) and, later, for playback.
    //
    //   To ensure that each recording has a unique file name, lines 69 - 72 establish
    //   the format of each file's name, which includes the current date and time of the
    //   recording.
    //
    
    @IBAction func recordAudio(sender: UIButton)
    {
        stopButton.hidden = false
        pauseButton.hidden = false
        resumeButton.hidden = true
        recordButton.enabled = false
        recordingInProgress.hidden = false
        tapToRecord.hidden = true
        continueRecording.hidden = true
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func pauseRecordingAudio(sender: UIButton)
    {
        pauseButton.enabled = false
        resumeButton.hidden = false
        recordingInProgress.hidden = true
        continueRecording.hidden = false
        audioRecorder.pause()
    }
    
    @IBAction func resumeRecordingAudio(sender: UIButton)
    {
        pauseButton.enabled = true
        resumeButton.hidden = true
        recordingInProgress.hidden = false
        continueRecording.hidden = true
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool)
    {
        if(flag) {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            println("Recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    @IBAction func stopRecording(sender: UIButton)
    {
        recordingInProgress.hidden = true
        
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
}

