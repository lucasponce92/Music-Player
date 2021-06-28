//
//  PlayerVC.swift
//  MICPA Radio
//
//  Created by Lucas Ponce on 12/2/19.
//  Copyright © 2019 Lucas Ponce. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerVC: UIViewController {
    
    @IBOutlet weak var playButton: PlayerMainButton!
    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var audioProgress: UILabel!
    @IBOutlet weak var audioLength: UILabel!
    var dragging = false
    var player: Player?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        playButton.iconStatus = playButton.PLAY

        self.player = Player(url: URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3")!)
        
        slider.minimumValue = 0
        
        let duration : CMTime = (self.player?.currentItem?.asset.duration)!
        let seconds : Float64 = CMTimeGetSeconds(duration)
        
        slider.maximumValue = Float(seconds)
        slider.isContinuous = true
        slider.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: .valueChanged)
        
        audioLength.text = secondsToHoursMinutesSeconds(seconds: Int(seconds))
        
        self.player?.addPeriodicTimeObserver(forInterval: CMTime.init(value: 1, timescale: 1), queue: .main, using: { time in
            
            if !self.dragging{
                let progress : Float64 = CMTimeGetSeconds(time)
                
                self.audioProgress.text = self.secondsToHoursMinutesSeconds(seconds: Int(progress))
                self.slider.setValue(Float(progress), animated: true)
            }
        })
        
        self.player?.actionAtItemEnd = .none

        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd(notification:)), name: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem)
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        self.player!.playCap(button: playButton)
    }
    
    @objc func onSliderValChanged(slider: UISlider, event: UIEvent) {
        
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                self.dragging = true
                
            case .moved:
                
                let seconds : Int64 = Int64(slider.value)
                let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
                
                let progress : Float64 = CMTimeGetSeconds(targetTime)
                
                self.audioProgress.text = self.secondsToHoursMinutesSeconds(seconds: Int(progress))
                
            case .ended:
                let seconds : Int64 = Int64(slider.value)
                let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
                
                self.player!.seek(to: targetTime)
                self.dragging = false

            default:
                break
            }
        }
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        
        self.player?.pauseCap(button: playButton)
        
        let targetTime:CMTime = CMTimeMake(value: 0, timescale: 1)
        self.player?.seek(to: targetTime)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.audioProgress.text = "00:00"
            self.slider.setValue(0, animated: true)
        })
    }
    
    @IBAction func play(_ sender: PlayerMainButton) {
        
        self.player?.playCap(button: playButton)
    }
    
    @IBAction func backward15(_ sender: UIButton) {
        
        let seconds : Int64 = Int64(slider.value)
        let targetTime:CMTime = CMTimeMake(value: seconds-15, timescale: 1)
        
        self.player!.seek(to: targetTime)
    }
    
    @IBAction func forward16(_ sender: UIButton) {
        
        let seconds : Int64 = Int64(slider.value)
        let targetTime:CMTime = CMTimeMake(value: seconds+15, timescale: 1)
        
        self.player!.seek(to: targetTime)
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> String {
        
        let (h, m, s) = (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
        
        var hour = String()
        var minute = String()
        var second = String()
        
        if h < 10 {
            hour = "0\(h)"
        }else{
            hour = String(h)
        }
        
        if m < 10 {
            minute = "0\(m)"
        }else{
            minute = String(m)
        }
        
        if s < 10 {
            second = "0\(s)"
        }else{
            second = String(s)
        }
        
        var response = String()
        
        if h > 0 { response += "\(hour):"}
        response += "\(minute):"
        response += second
        
        return response
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
}

class PlayerMainButton: UIButton{
    
    var iconStatus: String?
    
    let PLAY = "PLAY"
    let PAUSE = "PAUSE"
    let STOP = "STOP"
}
