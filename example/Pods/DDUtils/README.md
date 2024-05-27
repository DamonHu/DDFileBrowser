# DDUtils

![](https://img.shields.io/badge/CocoaPods-supported-brightgreen) ![](https://img.shields.io/badge/Swift-5.0-brightgreen) ![](https://img.shields.io/badge/License-MIT-brightgreen) ![](https://img.shields.io/badge/version-iOS10.0-brightgreen)


`DDUtils` is a collection of commonly used features, developed based on Swift, that can be quickly implemented on iOS devices.

### [中文文档](https://ddceo.com/blog/1281.html)

## import the project

### Import via cocoapods

```
pod 'DDUtils'
```

If you need the function of `idfa`, you can choose to import

```
pod 'DDUtils/idfa'
```

### Import via file

Download the project and import the contents of the `pod` folder under the project file into the project

## API list

Existing data type operations can be used through the syntax of `.zx`, and other operations can be used through the singleton of `DDUtils.shared`.

* There is no difference between singleton and `.zx`, singleton will be more unified and simple. The advantage of `.zx` syntax is that it does not need to be imported where it is used

### UI related

|Name|Function description|Example|
|----|----|----|
|func getCurrentNormalWindow()|Get the current NormalWindow|DDUtils.shared.getCurrentNormalWindow()|
|func getCurrentVC()|Get the current ViewController|DDUtils.shared.getCurrentVC()|
|func getImage(color: UIColor)|Generate a solid color background image by color|DDUtils.shared.getImage(color: UIColor.red) <br/>or<br/> UIImage.dd.getImage(color: UIColor .red)|
|func getLinearGradientImage(colors: [UIColor], directionType: DDUtilsGradientDirection, size: CGSize = CGSize(width: 100, height: 100))|Generate a linear gradient image|DDUtils.shared.getLinearGradientImage(colors: [UIColor.red , UIColor.black, UIColor.blue] <br/>or<br/> UIImage.dd.getLinearGradientImage(colors: [UIColor.red, UIColor.black, UIColor.blue], directionType: .leftToRight)|
|func getRadialGradientImage(colors: [UIColor], raduis: CGFloat, size: CGSize = CGSize(width: 100, height: 100))|Generate an angular gradient image|DDUtils.shared.getRadialGradientImage(colors: [UIColor.red , UIColor.black, UIColor.blue], raduis: 45) <br/> or<br/> UIImage.dd.getRadialGradientImage(colors: [UIColor.red, UIColor.black, UIColor.blue], raduis: 45)|
|func getColor(hexString: String, alpha: CGFloat = 1.0)|Get color by hexadecimal string| UIColor.dd.color(hexString: "#FFFFFF")|
|func UIColor(hexValue: Int, darkHexValue: Int = 0x333333, alpha: Float = 1.0, darkAlpha: Float = 1.0)|Get color by hexadecimal| UIColor.dd.color(hexValue: 0xffffff)|
|UIScreenWidth|Screen width||
|UIScreenHeight|Screen height||
|DDUtils_StatusBar_Height|Status Bar height||
|DDUtils_HomeIndicator_Height|Home Indicator height||
|func DDUtils_Default_NavigationBar_Height(vc: UIViewController? = nil)|Navigation Bar Height|DDUtils_Default_NavigationBar_Height()|
|func func DDUtils_Default_Tabbar_Height(vc: UIViewController? = nil)|tabbar height|DDUtils_Default_Tabbar_Height()|
|func addLayerShadow(color: UIColor, offset: CGSize, radius: CGFloat, cornerRadius: CGFloat? = nil)|Add a shadow to the view|view.dd.addLayerShadow(color: UIColor.black, offset: CGSize(width: 2, height : 0), radius: 10)|
|func setFrame(x: CGFloat? = nil, y: CGFloat? = nil, width: CGFloat? = nil, height: CGFloat? = nil)|view individually sets a certain value of Frame|view.dd.setFrame(x: 10)|
|func className() -> String| get view's class name|button.dd.className()|

### System and software information

|Name|Function description|Example|
|----|----|----|
|func getAppVersionString()|Get software version|DDUtils.shared.getAppVersionString()|
|func getAppBuildVersionString()|Get software build version|DDUtils.shared.getAppBuildVersionString()|
|func getAppNameString()|get app's Name|DDUtils.shared.getAppNameString()|
|func getIOSVersionString()|Get the iOS version of the system|DDUtils.shared.getIOSVersionString()|
|func getIOSLanguageStr()|Get system language|DDUtils.shared.getIOSLanguageStr()|
|func getBundleIdentifier()|Get Software Bundle Identifier|DDUtils.shared.getBundleIdentifier()|
|func getSystemHardware()|Get the machine model identification|DDUtils.shared.getSystemHardware()|
|func getSystemUpTime()|Get the last restart time of this machine|DDUtils.shared.getSystemUpTime()|
|func getIDFAString(idfvIfFailed: Bool = true)|The unique identification of the simulation software|DDUtils.shared.getIDFAString()|
|func getMacAddress()|To get the MAC address of the mobile phone WIFI, you need to enable Access WiFi information|DDUtils.shared.getMacAddress()|
|func openSystemSetting()|Open system settings|DDUtils.shared.openSystemSetting()|
|func openAppStorePage(openType: DDUtilsOpenAppStoreType, appleID: String)|Open the App Store page corresponding to the software|DDUtils.shared.openAppStorePage(openType: .app, appleID: "1123211")|
|func openAppStoreReviewPage(openType: DDUtilsOpenAppStoreType, appleID: String = "")|Open the score page corresponding to the software|DDUtils.shared.openAppStoreReviewPage(openType: .app)|

### Software permissions

|Name|Function description|Example|
|----|----|----|
|func requestPermission(type: DDUtilsPermissionType, complete: @escaping ((DDUtilsPermissionStatus) -> Void))|Request permission|DDUtils.shared.requestPermission(type: .notification) {(status) in print("Permission setting callback" , status) }|
|func checkPermission(type: DDUtilsPermissionType, complete: @escaping ((DDUtilsPermissionStatus) -> Void))|Checking software permissions|DDUtils.shared.checkPermission(type: .notification) {(status) in print("Current permission status ", status) }|
|func requestIDFAPermission(complete: @escaping ((DDUtilsPermissionStatus) -> Void)) -> Void|request idfa permission|DDUtils.shared.requestIDFAPermission {(status) in print("Current idfa permission status", status)} |
|func checkIDFAPermission(type: DDUtilsPermissionType, complete: @escaping ((DDUtilsPermissionStatus) -> Void)) -> Void|check software idfa permission|DDUtils.shared.checkIDFAPermission {(status) in print("Current Permission Status", status) }|

### Multimedia operation

|Name|Function description|Example|
|----|----|----|
|func getVideoDuration(videoURL: URL) -> Double|Get the duration of the specified video, in seconds | DDUtils.shared.getVideoDuration(videoURL: URL(fileURLWithPath: path))|
|func getVideoSize(videoURL: URL)|Get the specified video resolution, support local or network address|DDUtils.shared.getVideoSize(videoURL: URL(fileURLWithPath: path))|
|func playMusic(url: URL?, repeated: Bool = false, audioSessionCategory: AVAudioSession.Category = AVAudioSession.Category.playback)|Play music|DDUtils.shared.playMusic(url: url, repeated: false)|
|func stopMusic()|Turn off music playback|DDUtils.shared.stopMusic()|
|func playEffect(url: URL?, vibrate: Bool = false)|Play sound effects, silent mode will not play sound effects|DDUtils.shared.playEffect(url: url, vibrate: true)|
|func startVibrate(repeated: Bool = false)|Start vibration|DDUtils.shared.startVibrate()|
|func stopVibrate()|End vibration|DDUtils.shared.stopVibrate()|

### File operations

|Name|Function description|Example|
|----|----|----|
|func getFileDirectory(type: DDUtilsFileDirectoryType)|Get folder path|DDUtils.shared.getFileDirectory(type: .documents)|
|func createFileDirectory(in type: DDUtilsFileDirectoryType, directoryName: String)|Create a folder in the specified folder|DDUtils.shared.createFileDirectory(in: .documents, directoryName: "filePath")|
|func getFileSize(filePath: URL)|Get the size of the specified file|DDUtils.shared.getFileSize(filePath: url)|
|func getFileDirectorySize(fileDirectoryPth: URL)|Get the size of the specified folder|DDUtils.shared.getFileDirectorySize(fileDirectoryPth: url)|

### Other

#### DDUtils

|Name|Function description|Example|
|----|----|----|
|func getDictionary(object: Any, debug: Bool = false) -> [String: Any]| get all key and value from class\struct|DDUtils.shared.getDictionary(object: testModel)|
|func runInMainThread(type: ZXMainThreadType = .default, function: @escaping ()->Void)|run function in main thread|DDUtils.shared.runInMainThread(type: .sync) { ... }|


#### String

|Name|Function description|Example|
|----|----|----|
|func subString(rang: NSRange)|截取字符串|string.dd.subString(rang: NSRange(location: 2, length: 5))|
|func unicodeDecode()|unicode转中文|"\\u54c8\\u54c8\\u54c8".dd.unicodeDecode()|
|func unicodeEncode()|字符串转unicode|"哈哈是电话费".dd.unicodeEncode()|
|func encodeString(from originType: DDUtilsEncodeType = .system(.utf8), to encodeType: DDUtilsEncodeType)|字符串修改编码显示|"5ZOI5ZOI5piv55S16K+d6LS5".dd.encodeString(from: .base64, to: .system(.utf8))|
|func aesCBCEncrypt(password: String, ivString: String = "abcdefghijklmnop")|aes cbc Encrypt |string.dd.aesCBCEncrypt(password: "password")|
|func aesCBCDecrypt(password: String, ivString: String = "abcdefghijklmnop")|aes cbc Decrypt |string.dd.aesCBCDecrypt(password: "password")|
|func hashString(hashType: DDUtilsHashType, lowercase: Bool = true)|get hash value of the string|string.dd.hashString(hashType: .md5) <br/> Support md5/sha1/sha224/sha256/sha384/sha512|
|func aesGCMEncrypt(password: String, encodeType: DDUtilsEncodeType = .base64, nonce: AES.GCM.Nonce? = AES.GCM.Nonce())|aes gcm Encrypt |string.dd.aesGCMEncrypt(password: "password")|
|func aesGCMDecrypt(password: String, encodeType: DDUtilsEncodeType = .base64)|aes gcm Decrypt |string.dd.aesGCMDecrypt(password: "password")|
|func hmac(hashType: DDUtilsHashType, password: String, encodeType: DDUtilsEncodeType = .base64)|HMAC|"DDUtils".dd.hmac(hashType: .sha1, password: "67FG", encodeType: .hex)|

#### Data

|Name|Function description|Example|
|----|----|----|
|static func data(from string: String, encodeType: DDUtilsEncodeType)|get data from string with encodeType | Data.dd.data(from: "d5a423f64b607ea7c65b311d855dc48f36114b227bd0c7a3d403f6158a9e4412", encodeType: .hex)|
|func encodeString(encodeType: DDUtilsEncodeType)| encode data to string with encodeType | data.dd.encodeString(encodeType: .hex)|
|func aesCBCEncrypt(password: String, ivString: String = "abcdefghijklmnop")|aes cbc Encrypt|data.dd.aesCBCEncrypt(password: "password")|
|func aesCBCDecrypt(password: String, ivString: String = "abcdefghijklmnop")|aes cbc Decrypt|data.dd.aesCBCDecrypt(password: "password")|
|func hashString(hashType: DDUtilsHashType, lowercase: Bool = true)|get hash value of the string|data.dd. hashString(hashType: .md5) <br/> 支持md5/sha1/sha224/sha256/sha384/sha512|
|func aesGCMEncrypt(password: String, encodeType: DDUtilsEncodeType = .base64, nonce: AES.GCM.Nonce? = AES.GCM.Nonce())|aes gcm Encrypt|data.dd.aesGCMEncrypt(password: "password")|
|func aesGCMDecrypt(password: String, encodeType: DDUtilsEncodeType = .base64)|aes gcm Decrypt|data.dd.aesGCMDecrypt(password: "password")|
|func hmac(hashType: DDUtilsHashType, password: String, encodeType: DDUtilsEncodeType = .base64)|HMAC|data.dd.hmac(hashType: .sha1, password: "67FG", encodeType: .hex)|


## License

The project is based on the MIT License