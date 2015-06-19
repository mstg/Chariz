# ![Chariz](https://i.imgur.com/9RHFBv4.png) [![Build Status](https://travis-ci.org/CharizTeam/Chariz.svg)](https://travis-ci.org/CharizTeam/Chariz)
A package management app for OS X.

License: [GNU GPL v2](https://www.gnu.org/licenses/gpl-2.0.html)

## Building
Building Chariz requires [CocoaPods](https://cocoapods.org/). Install it with `gem install cocoapods` before following the instructions below. (You'll need to prefix that command with `sudo` if you haven't installed your own copy of Ruby.)

```
$ git clone --recursive https://github.com/CharizTeam/Chariz.git
$ cd Chariz
$ pod install
$ open Chariz.xcworkspace
```

Note that the `.xcodeproj` is the Chariz app itself, while `.xcworkspace` contains the cpm and CocoaPods modules. Chariz will not compile from the standalone `.xcodeproj`.
