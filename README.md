## Music Player Swift and UIKit Project

Hi everyone, today I'm sharing with you a piece of code from a project I was asked to collaborate in a few years ago, it's about a music player with the looks of spotify.
At the time I was recomended to use AVPlayer for this porpuses instead of AVAudioPlayer because the implementation is easier when you're trying to achieve for it to keep playing when the app is in background.
I hope someone can find it usefull.

We will be covering:
* [Music playing in background](#background)
* Custom AVPlayer
* Music playing from URL
* Updating UISlider position while music is playing
* Light content in status bar (Bonus)

<a name="background"/>

## Music playing in background

Implement de following code on your AppDelegate file, this will allow the music or audio files to keep playing when the app is on background
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

## Custom AVPlayer

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

## Music playing from URL

You can initialize the player with AVPlayer(url:"yoururl"), it will fetch your audio file, playlist, or anything automatically. In this case we use our custom class and fetch a random .mp3 I found online, replace it with your own .mp3 audio file
```swift
class PlayerVC: UIViewController {
    
    var dragging = false
    var player: Player?
    @IBOutlet weak var playButton: PlayerMainButton!
    @IBOutlet weak var slider: UISlider!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.player = Player(url: URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3")!)
        self.player!.playCap(button: playButton)
  }
}
```
You can see we're passing a button to the playCap func. We do this to keep track of our main player button and be able to asign different icons and functionalities according to the player mode (.playing or .pause)

## Updating UISlider position while music is playing

```swift
self.player?.addPeriodicTimeObserver(forInterval: CMTime.init(value: 1, timescale: 1), queue: .main, using: { time in
            
            if !self.dragging{
                let progress : Float64 = CMTimeGetSeconds(time)
                self.slider.setValue(Float(progress), animated: true)
            }
        })
```

## Light content in status bar

Use this code in your first ViewController to override the status bar preferences
```swift
override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
```

## Final thoughts

Even tho this code will allow you to develop an audio player, there are better ways to achieve this target, SwiftUI and its binding variables allow you to keep track of what's happening with the audio file, at the same time you update the view, and I will be covering it in a future project (very soon)

Download the complete project to see it working
