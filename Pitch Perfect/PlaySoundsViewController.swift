//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Christian Whitesides on 3/12/15.
//  Copyright (c) 2015 ChristianWhitesides. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }
    
    
    func playAudioWithVariableRate(rate: Float)
    {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = rate
        audioPlayer.play()
    }
    
    func playAudioWithVariablePitch(pitch: Float)
    {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    
    @IBAction func playSlowAudio(sender: UIButton)
    {
        playAudioWithVariableRate(0.5)
    }
    
    @IBAction func playFastAudio(sender: UIButton)
    {
        playAudioWithVariableRate(1.5)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton)
    {
        playAudioWithVariablePitch(1000)
        
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton)
    {
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func playEchoAudio(sender: UIButton)
    {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var audioReverb = AVAudioUnitReverb()
        audioReverb.loadFactoryPreset(AVAudioUnitReverbPreset.Cathedral)
        audioReverb.wetDryMix = 50.0
        audioEngine.attachNode(audioReverb)
        
        audioEngine.connect(audioPlayerNode, to: audioReverb, format: nil)
        audioEngine.connect(audioReverb, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    @IBAction func playDistortedAudio(sender: UIButton)
    {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var audioDistort = AVAudioUnitDistortion()
        audioDistort.loadFactoryPreset(AVAudioUnitDistortionPreset.SpeechCosmicInterference)
        audioDistort.preGain = 15.0
        audioEngine.attachNode(audioDistort)
        
        audioEngine.connect(audioPlayerNode, to: audioDistort, format: nil)
        audioEngine.connect(audioDistort, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    
    @IBAction func stopAudioPlayback(sender: UIButton)
    {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }

}
