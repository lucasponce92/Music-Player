# Music Player Swift and UIKit Project

Hi everyone, today I'm sharing with you a piece of code from a project I was asked to collaborate in a few years ago, it's about a music player with the looks of spotify.
At the time I was recomended to use AVPlayer for this porpuses instead of AVAudioPlayer because the implementation is easier when you're trying to achieve for it to keep playing when the app is in background.
I hope someone can find it usefull.

We will be covering:
* Music playing in background
* Music playing from URL
* Custim AVPlayer
* Updating UISlider position while music is playing
* Light content in status bar

# Music playing in background

```swift
//AppDelegate

class AppDelegate: UIResponder, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.soloAmbient)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        } catch {
            
        }
        
        return true
    }
}
```

# Music playing from URL

```swift
//Custom AVPlayer

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
```
