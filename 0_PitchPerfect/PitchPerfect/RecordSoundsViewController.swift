/**
  RecordSoundsViewController.swift
  PitchPerfect
 
  This ViewController conforms to the AVAudioRecorderDelegate protocol
  That is, we will implement a function described in that protocol, and our ViewController can act as the delegate of the AVAudioRecorder
 
  Created by lmohamed on 11/19/18.
  Copyright © 2018 tribl. All rights reserved.
**/

import UIKit
import AVFoundation

// A class can inherit from ONLY 1 superclass, but can conform to any number of protocols
class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Reset the UI
        updateUI()
    }
    
    // MARK: Recording Controls
    @IBAction func recordAudio(_ sender: Any) {
        // Create a path to a file to save the recording
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        // Set this ViewController as the delegate of the AVAudioRecorder
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
        // Update the UI
        updateUI(isRecording: true)
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        // Stop the recording
        audioRecorder.stop()
        
        // Release the shared session (inactivate the shared audio session)
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
        // Update the UI
        updateUI(isRecording: false)
    }
    
    // MARK: Update UI
    private func updateUI(isRecording: Bool? = nil) {
        if let isRecording = isRecording {
            // Set the button states
            stopButton.isEnabled = isRecording
            startButton.isEnabled = !isRecording
            
            // Update the text
            let labelText = isRecording ? "Recording In Progress" : "Recording Stopped"
            recordingLabel.text = labelText
        } else {
            // If no value is passed in, assume a fresh start and prompt to record
            recordingLabel.text = "Tap to Record"
        }
    }
    
    // MARK: Audio Recorder Delegation
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        // IF the recording was successfully saved, we will perform the segue and send the file path to the next ViewController
        if flag {
            // the identifier is the name given to the segue in the storyboard
            performSegue(withIdentifier: "stopRecordingSegue", sender: audioRecorder.url)
        } else {
            print("Recording was not successfully saved")
        }
    }
    
    // MARK: Prepare for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Select the desired seugue
        if segue.identifier == "stopRecordingSegue" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController   // Ensure that the destination is the desired VC (forced upcast, because destination is of type ViewController)
            let recordedAudioRUL = sender as! URL   // `sender` is the recordedAudioURL we're sending in performSegue. Cast value we're sending to URL
            playSoundsVC.recordedAudioURL = recordedAudioRUL    // Set the value of the next view controller to the URL we're sending once performSegue is called in `audioRecorderDidFinishRecording`
        }
    }
}

