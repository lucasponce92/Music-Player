# Music Player Swift and UIKit Project

Hi everyone, today I'm sharing with you a piece of code from a project I was asked to collaborate in a few years ago, it's about a music player with the looks of spotify.
At the time I was recomended to use AVPlayer for this porpuses instead of AVAudioPlayer because the implementation is easier when you're trying to achieve for it to keep playing when the app is in background.
I hope someone can find it usefull.

We will be covering:
* Music playing in background
* Music playing from URL
* Updating UISlider position while music is playing

# Music playing in background

```swift
//AppDelegate

class AppDelegate: UIResponder, UIApplicationDelegate {
  ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions) 
}

func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
  return ApplicationDelegate.shared.application(app, open: url, options: options)
}
```
