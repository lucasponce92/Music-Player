//
//  Global.swift
//  MICPA Radio
//
//  Created by Lucas Ponce on 10/25/19.
//  Copyright © 2019 Lucas Ponce. All rights reserved.
//

import Foundation
import MediaPlayer

class Player: AVPlayer{
    
    var timer = Timer()
    var buttonStreaming: UIButton?
    
    var playButton: PlayerMainButton?

    func playCap(button: PlayerMainButton){
        
        if button.iconStatus == button.PLAY{

            button.setImage(UIImage(named: "rounded_pause"), for: .normal)
            button.iconStatus = button.PAUSE
            
            self.play()
            playButton = button
            self.currentItem?.addObserver(self, forKeyPath: "status", options: [.old, .new], context: nil)
            
        }else if button.iconStatus == button.PAUSE{
            button.setImage(UIImage(named: "rounded_play"), for: .normal)
            button.iconStatus = button.PLAY
            self.pause()
        }
    }
    
    func pauseCap(button: PlayerMainButton){
        self.pause()
        button.setImage(UIImage(named: "rounded_play"), for: .normal)
        button.iconStatus = button.PLAY
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        if self.currentItem?.status == AVPlayerItem.Status.readyToPlay{
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
}
