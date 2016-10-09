<p align="center">
<img src="./wilhelm.png" width=300/>
<br>
Wilhelm
<br>
<pre align="center">Version checker for iOS app featuring server-side configuration</pre>
</p>
[![Swift](https://img.shields.io/badge/Swift-3.0-green.svg)](https://github.com/apple/swift) [![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/CodeEagle/Wilhelm/master/LICENSE) [![Build Status](https://travis-ci.org/CodeEagle/CacheLeaf.svg?branch=master)](https://travis-ci.org/CodeEagle/Wilhelm)
Usage
---
```swift
  import Wilhelm
// func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    Wilhelm.handle(app: "com.tencent.xin")
// return true
//}
```
install
---
###Carthage
```
github "CodeEagle/Wilhelm"
```
Wiki
---
```swift
	/// handle works
    ///
    /// - parameter bundleIdentifier: bundle id of querying app, such as com.abc.com
    /// - parameter extraInfo:        server side control info of app
    /// - parameter language:         language to show, default cn
    /// - parameter ignore:           custom ignore title
    /// - parameter update:           custom update title
    public static func handle(app bundleIdentifier: String,
    						  extraInfo: ServerSideAppControl? = nil,
    						  language: ITCLanguage = .cn,
    						  customIgnore ignore: String? = nil,
    						  customUpdate update: String? = nil) { ... }
```
Donations
---
<pre>
<p align="center">
<img src="https://raw.githubusercontent.com/CodeEagle/CacheLeaf/master/donate.jpg" width=320/>
</p>
</pre>
License
---
Wilhelm is released under the MIT license. See LICENSE for details.
