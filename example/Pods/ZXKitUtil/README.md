# ZXKitUtil

[中文说明](./README_zh.md)

`ZXKitUtil` is a collection of commonly used functions. This tool is updated and modified by [HDCommonTools](https://github.com/DamonHu/HDCommonTools), which integrates common functions simply and efficiently. In addition, ZXKitUtilCommonTools has an OC version available.

## import the project

### Import via cocoapods

```
pod 'ZXKitUtil'
```

If you need the function of `idfa`, you can choose to import

```
pod 'ZXKitUtil/idfa'
```

### Import via file

Download the project and import the contents of the `pod` folder under the project file into the project

## API list

Existing data type operations can be used through the syntax of `.zx`, and other operations can be used through the singleton of `ZXKitUtil.shared`.

* There is no difference between singleton and `.zx`, singleton will be more unified and simple. The advantage of `.zx` syntax is that it does not need to be imported where it is used

### UI related

|Name|Function description|Example|
|----|----|----|
|func getCurrentNormalWindow()|Get the current NormalWindow|ZXKitUtil.shared.getCurrentNormalWindow()|
|func getCurrentVC()|Get the current ViewController|ZXKitUtil.shared.getCurrentVC()|
|func getImage(color: UIColor)|Generate a solid color background image by color|ZXKitUtil.shared.getImage(color: UIColor.red) <br/>or<br/> UIImage.zx.getImage(color: UIColor .red)|
|func getLinearGradientImage(colors: [UIColor], directionType: ZXKitUtilGradientDirection, size: CGSize = CGSize(width: 100, height: 100))|Generate a linear gradient image|ZXKitUtil.shared.getLinearGradientImage(colors: [UIColor.red , UIColor.black, UIColor.blue] <br/>or<br/> UIImage.zx.getLinearGradientImage(colors: [UIColor.red, UIColor.black, UIColor.blue], directionType: .leftToRight)|
|func getRadialGradientImage(colors: [UIColor], raduis: CGFloat, size: CGSize = CGSize(width: 100, height: 100))|Generate an angular gradient image|ZXKitUtil.shared.getRadialGradientImage(colors: [UIColor.red , UIColor.black, UIColor.blue], raduis: 45) <br/> or<br/> UIImage.zx.getRadialGradientImage(colors: [UIColor.red, UIColor.black, UIColor.blue], raduis: 45)|
|func getColor(hexString: String, alpha: CGFloat = 1.0)|Get color by hexadecimal string| UIColor.zx.color(hexString: "#FFFFFF")|
|func UIColor(hexValue: Int, darkHexValue: Int = 0x333333, alpha: Float = 1.0, darkAlpha: Float = 1.0)|Get color by hexadecimal| UIColor.zx.color(hexValue: 0xffffff)|
|UIScreenWidth|Screen width||
|UIScreenHeight|Screen height||
|ZXKitUtil_StatusBar_Height|Status Bar Height||
|func ZXKitUtil_Default_NavigationBar_Height(vc: UIViewController? = nil)|Navigation Bar Height|ZXKitUtil_Default_NavigationBar_Height()|
|func func ZXKitUtil_Default_Tabbar_Height(vc: UIViewController? = nil)|tabbar height|ZXKitUtil_Default_Tabbar_Height()|
|func addLayerShadow(color: UIColor, offset: CGSize, radius: CGFloat, cornerRadius: CGFloat? = nil)|Add a shadow to the view|view.zx.addLayerShadow(color: UIColor.black, offset: CGSize(width: 2, height : 0), radius: 10)|
|func setFrame(x: CGFloat? = nil, y: CGFloat? = nil, width: CGFloat? = nil, height: CGFloat? = nil)|view individually sets a certain value of Frame|view.zx.setFrame(x: 10)|

### System and software information

|Name|Function description|Example|
|----|----|----|
|func getAppVersionString()|Get software version|ZXKitUtil.shared.getAppVersionString()|
|func getAppBuildVersionString()|Get software build version|ZXKitUtil.shared.getAppBuildVersionString()|
|func getIOSVersionString()|Get the iOS version of the system|ZXKitUtil.shared.getIOSVersionString()|
|func getIOSLanguageStr()|Get system language|ZXKitUtil.shared.getIOSLanguageStr()|
|func getBundleIdentifier()|Get Software Bundle Identifier|ZXKitUtil.shared.getBundleIdentifier()|
|func getSystemHardware()|Get the machine model identification|ZXKitUtil.shared.getSystemHardware()|
|func getSystemUpTime()|Get the last restart time of this machine|ZXKitUtil.shared.getSystemUpTime()|
|func getIDFAString(idfvIfFailed: Bool = true)|The unique identification of the simulation software|ZXKitUtil.shared.getIDFAString()|
|func getMacAddress()|To get the MAC address of the mobile phone WIFI, you need to enable Access WiFi information|ZXKitUtil.shared.getMacAddress()|
|func openSystemSetting()|Open system settings|ZXKitUtil.shared.openSystemSetting()|
|func openAppStorePage(openType: ZXKitUtilOpenAppStoreType, appleID: String)|Open the App Store page corresponding to the software|ZXKitUtil.shared.openAppStorePage(openType: .app, appleID: "1123211")|
|func openAppStoreReviewPage(openType: ZXKitUtilOpenAppStoreType, appleID: String = "")|Open the score page corresponding to the software|ZXKitUtil.shared.openAppStoreReviewPage(openType: .app)|

### Software permissions

|Name|Function description|Example|
|----|----|----|
|func requestPermission(type: ZXKitUtilPermissionType, complete: @escaping ((ZXKitUtilPermissionStatus) -> Void))|Request permission|ZXKitUtil.shared.requestPermission(type: .notification) {(status) in print("Permission setting callback" , status) }|
|func checkPermission(type: ZXKitUtilPermissionType, complete: @escaping ((ZXKitUtilPermissionStatus) -> Void))|Checking software permissions|ZXKitUtil.shared.checkPermission(type: .notification) {(status) in print("Current permission status ", status) }|
|func requestIDFAPermission(complete: @escaping ((ZXKitUtilPermissionStatus) -> Void)) -> Void|Detection software IDFA permission|ZXKitUtil.shared.requestIDFAPermission {(status) in print("Current idfa permission status", status)} |
|func checkIDFAPermission(type: ZXKitUtilPermissionType, complete: @escaping ((ZXKitUtilPermissionStatus) -> Void)) -> Void|Detection software idfa permission|ZXKitUtil.shared.checkIDFAPermission {(status) in print("Current Permission Status", status) }|

### Multimedia operation

|Name|Function description|Example|
|----|----|----|
|func getVideoDuration(videoURL: URL) -> Double|Get the duration of the specified video, in seconds | ZXKitUtil.shared.getVideoDuration(videoURL: URL(fileURLWithPath: path))|
|func getVideoSize(videoURL: URL)|Get the specified video resolution, support local or network address|ZXKitUtil.shared.getVideoSize(videoURL: URL(fileURLWithPath: path))|
|func playMusic(url: URL?, repeated: Bool = false, audioSessionCategory: AVAudioSession.Category = AVAudioSession.Category.playback)|Play music|ZXKitUtil.shared.playMusic(url: url, repeated: false)|
|func stopMusic()|Turn off music playback|ZXKitUtil.shared.stopMusic()|
|func playEffect(url: URL?, vibrate: Bool = false)|Play sound effects, silent mode will not play sound effects|ZXKitUtil.shared.playEffect(url: url, vibrate: true)|
|func startVibrate(repeated: Bool = false)|Start vibration|ZXKitUtil.shared.startVibrate()|
|func stopVibrate()|End vibration|ZXKitUtil.shared.stopVibrate()|

### File operations

|Name|Function description|Example|
|----|----|----|
|func getFileDirectory(type: ZXKitUtilFileDirectoryType)|Get folder path|ZXKitUtil.shared.getFileDirectory(type: .documents)|
|func createFileDirectory(in type: ZXKitUtilFileDirectoryType, directoryName: String)|Create a folder in the specified folder|ZXKitUtil.shared.createFileDirectory(in: .documents, directoryName: "filePath")|
|func getFileSize(filePath: URL)|Get the size of the specified file|ZXKitUtil.shared.getFileSize(filePath: url)|
|func getFileDirectorySize(fileDirectoryPth: URL)|Get the size of the specified folder|ZXKitUtil.shared.getFileDirectorySize(fileDirectoryPth: url)|

### Other

|Name|Function description|Example|
|----|----|----|
|func compare(anotherDate: Date, ignoreTime: Bool = false)|Compare dates and set whether to ignore time|Date().zx.compare(anotherDate: date)|
|func subString(rang: NSRange)|Intercept string|string.zx.subString(rang: NSRange(location: 2, length: 5))|
|func unicodeDecode()|unicode to Chinese|"\\u54c8\\u54c8\\u54c8".zx.unicodeDecode()|
|func unicodeEncode()|Character string to unicode|"Haha is the phone charge".zx.unicodeEncode()|
|func base64Decode(lowercase: Bool = true)|base64 decoding|"5ZOI5ZOI5piv55S16K+d6LS5".zx.base64Decode()|
|func aes256Decrypt(password: String, ivString: String = "abcdefghijklmnop")|aes256 decrypt|string.zx.aes256Decrypt(password: "password")|
|func aes256Encrypt(password: String, ivString: String = "abcdefghijklmnop")|aes256 encryption|string.zx.aes256Encrypt(password: "password")|
|func encryptString(encryType: ZXKitUtilEncryType, lowercase: Bool = true)|String encryption|string.zx.encryptString(encryType: ZXKitUtilEncryType.md5) <br/> Support md5/sha1/sha224/sha256/sha384/sha512/base64 encryption |

## other

Welcome to exchange and learn from each other

Project gitHub address: [https://github.com/ZXKitCode/util](https://github.com/ZXKitCode/util)

## License

![](https://camo.githubusercontent.com/eb9066a6d8e0950066f3757c420e3a607c0929583b48ebda6fd9a6f50ccfc8f1/68747470733a2f2f7777772e6170616368652e6f72672f696d672f41534632307468416e6e69766572736172792e6a7067)

Base on Apache-2.0 License