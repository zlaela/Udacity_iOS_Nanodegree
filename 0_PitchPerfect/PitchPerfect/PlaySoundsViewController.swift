/**
  PlaySoundsViewController.swift
  PitchPerfect

  Created by lmohamed on 11/25/18.
  Copyright © 2018 tribl. All rights reserved.
**/

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    var recordedAudioURL: URL!
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    enum ButtonType: Int { case slow = 0, fast, squirrel, vader, echo, reverb }
    
    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var rabbitButton: UIButton!
    @IBOutlet weak var squirrelButton: UIButton!
    @IBOutlet weak var vaderButton: UIButton!
    @IBOutlet weak var parrotButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!

    @IBAction func doForButton(_ sender: UIButton) {
        // Get the value corresponding to the button's tag and manipulate the sound accordingly
        switch (ButtonType(rawValue: sender.tag)!) {
            case .slow:
                playSound(rate: 0.5)
                break
            case .fast:
                playSound(rate: 1.5)
                break
            case .squirrel:
                playSound(pitch: 1000)
                break
            case .vader:
                playSound(pitch: -1000)
                break
            case .echo:
                playSound(echo: true)
                break
            case .reverb:
                playSound(reverb: true)
                break
        }
        configureUI(.playing)
    }
    
    @IBAction func stopButtonPressed() {
        stopAudio()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(.notPlaying)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
    }
}
