
# ZXKitUtil

![](https://img.shields.io/badge/CocoaPods-supported-brightgreen) ![](https://img.shields.io/badge/Swift-5.0-brightgreen) ![](https://img.shields.io/badge/License-MIT-brightgreen) ![](https://img.shields.io/badge/version-iOS10.0-brightgreen)

[English](./README_en.md)

`ZXKitUtil`是一个常用功能的合集, 简单高效的集成常用功能。

OC版本: [HDCommonTools](https://github.com/DamonHu/HDCommonTools)

## 一、导入项目

### 通过cocoapods导入

```
pod 'ZXKitUtil'
```

如果需要`idfa`的功能，可以选择导入

```
pod 'ZXKitUtil/idfa'
```

### 通过文件导入

下载项目，将项目文件下的pod文件夹里面的内容导入项目即可

## 二、API列表

已有的数据类型操作可以通过`.zx`的语法，其他操作可以通过`ZXKitUtil.shared`单例来使用。

* 单例和`.zx`使用没区别，单例会更统一简单，`.zx`语法的好处就是不需要在使用的地方导入

### UI相关

|名称|功能说明|示例|
|----|----|----|
|func getCurrentNormalWindow()|获取当前的NormalWindow|ZXKitUtil.shared.getCurrentNormalWindow()|
|func getCurrentVC()|获取当前的ViewController|ZXKitUtil.shared.getCurrentVC()|
|func getImage(color: UIColor)|通过颜色生成一张纯色背景图|ZXKitUtil.shared.getImage(color: UIColor.red) <br/>或者<br/> UIImage.zx.getImage(color: UIColor.red)|
|func getLinearGradientImage(colors: [UIColor], directionType: ZXKitUtilGradientDirection, size: CGSize = CGSize(width: 100, height: 100))|生成线性渐变的图片|ZXKitUtil.shared.getLinearGradientImage(colors:  [UIColor.red, UIColor.black, UIColor.blue] <br/>或者<br/> UIImage.zx.getLinearGradientImage(colors: [UIColor.red, UIColor.black, UIColor.blue], directionType: .leftToRight)|
|func getRadialGradientImage(colors: [UIColor], raduis: CGFloat, size: CGSize = CGSize(width: 100, height: 100))|生成角度渐变的图片|ZXKitUtil.shared.getRadialGradientImage(colors: [UIColor.red, UIColor.black, UIColor.blue], raduis: 45) <br/>或者<br/> UIImage.zx.getRadialGradientImage(colors: [UIColor.red, UIColor.black, UIColor.blue], raduis: 45)|
|func getColor(hexString: String, alpha: CGFloat = 1.0)|通过十六进制字符串获取颜色| UIColor.zx.color(hexString: "#FFFFFF")|
|func UIColor(hexValue: Int, darkHexValue: Int = 0x333333, alpha: Float = 1.0, darkAlpha: Float = 1.0)|通过十六进制获取颜色| UIColor.zx.color(hexValue: 0xffffff)|
|UIScreenWidth|屏幕宽度||
|UIScreenHeight|屏幕高度||
|ZXKitUtil_StatusBar_Height|状态栏高度||
|ZXKitUtil_HomeIndicator_Height|Home Indicator高度||
|func ZXKitUtil_Default_NavigationBar_Height(vc: UIViewController? = nil)|导航栏高度|ZXKitUtil_Default_NavigationBar_Height()|
|func func ZXKitUtil_Default_Tabbar_Height(vc: UIViewController? = nil)|tabbar高度|ZXKitUtil_Default_Tabbar_Height()|
|func addLayerShadow(color: UIColor, offset: CGSize, radius: CGFloat, cornerRadius: CGFloat? = nil)|为view添加阴影|view.zx.addLayerShadow(color: UIColor.black, offset: CGSize(width: 2, height: 0), radius: 10)|
|func setFrame(x: CGFloat? = nil, y: CGFloat? = nil, width: CGFloat? = nil, height: CGFloat? = nil)|view单独设置Frame的某个值|view.zx.setFrame(x: 10)|
|func className() -> String|获取view的类名|button.zx.className()|

### 系统和软件信息

|名称|功能说明|示例|
|----|----|----|
|func getAppVersionString()|获取软件版本|ZXKitUtil.shared.getAppVersionString()|
|func getAppBuildVersionString()|获取软件构建版本|ZXKitUtil.shared.getAppBuildVersionString()|
|func getAppNameString()|获取软件的显示名字|ZXKitUtil.shared.getAppNameString()|
|func getIOSVersionString()|获取系统的iOS版本|ZXKitUtil.shared.getIOSVersionString()|
|func getIOSLanguageStr()|获取系统语言|ZXKitUtil.shared.getIOSLanguageStr()|
|func getBundleIdentifier()|获取软件Bundle Identifier|ZXKitUtil.shared.getBundleIdentifier()|
|func getSystemHardware()|获取本机机型标识|ZXKitUtil.shared.getSystemHardware()|
|func getSystemUpTime()|获取本机上次重启时间|ZXKitUtil.shared.getSystemUpTime()|
|func getIDFAString(idfvIfFailed: Bool = true)|模拟软件唯一标示|ZXKitUtil.shared.getIDFAString()|
|func getMacAddress()|获取手机WIFI的MAC地址，需要开启Access WiFi information|ZXKitUtil.shared.getMacAddress()|
|func openSystemSetting()|打开系统设置|ZXKitUtil.shared.openSystemSetting()|
|func openAppStorePage(openType: ZXKitUtilOpenAppStoreType, appleID: String)|打开软件对应的App Store页面|ZXKitUtil.shared.openAppStorePage(openType: .app, appleID: "1123211")|
|func openAppStoreReviewPage(openType: ZXKitUtilOpenAppStoreType, appleID: String = "")|打开软件对应的评分页面|ZXKitUtil.shared.openAppStoreReviewPage(openType: .app)|

### 软件权限

|名称|功能说明|示例|
|----|----|----|
|func requestPermission(type: ZXKitUtilPermissionType, complete: @escaping ((ZXKitUtilPermissionStatus) -> Void))|请求权限|ZXKitUtil.shared.requestPermission(type: .notification) { (status) in print("权限设置回调", status) }|
|func checkPermission(type: ZXKitUtilPermissionType, complete: @escaping ((ZXKitUtilPermissionStatus) -> Void))|检测软件权限|ZXKitUtil.shared.checkPermission(type: .notification) { (status) in print("当前权限状态", status) }|
|func requestIDFAPermission(complete: @escaping ((ZXKitUtilPermissionStatus) -> Void)) -> Void|请求软件IDFA权限|ZXKitUtil.shared.requestIDFAPermission { (status) in print("当前idfa权限状态", status) }|
|func checkIDFAPermission(type: ZXKitUtilPermissionType, complete: @escaping ((ZXKitUtilPermissionStatus) -> Void)) -> Void|检测软件idfa权限|ZXKitUtil.shared.checkIDFAPermission { (status) in print("当前权限状态", status) }|

### 多媒体操作

|名称|功能说明|示例|
|----|----|----|
|func getVideoDuration(videoURL: URL) -> Double|获取指定video的时长， 单位秒| ZXKitUtil.shared.getVideoDuration(videoURL: URL(fileURLWithPath: path))|
|func getVideoSize(videoURL: URL)|获取指定视频的分辨率，支持本地或者网络地址|ZXKitUtil.shared.getVideoSize(videoURL: URL(fileURLWithPath: path))|
|func playMusic(url: URL?, repeated: Bool = false, audioSessionCategory: AVAudioSession.Category = AVAudioSession.Category.playback)|播放音乐|ZXKitUtil.shared.playMusic(url: url, repeated: false)|
|func stopMusic()|关闭音乐播放|ZXKitUtil.shared.stopMusic()|
|func playEffect(url: URL?, vibrate: Bool = false)|播放音效，静音模式不会播放音效|ZXKitUtil.shared.playEffect(url: url, vibrate: true)|
|func startVibrate(repeated: Bool = false)|开始震动|ZXKitUtil.shared.startVibrate()|
|func stopVibrate()|结束震动|ZXKitUtil.shared.stopVibrate()|

### 文件操作

|名称|功能说明|示例|
|----|----|----|
|func getFileDirectory(type: ZXKitUtilFileDirectoryType)|获取文件夹路径|ZXKitUtil.shared.getFileDirectory(type: .documents)|
|func createFileDirectory(in type: ZXKitUtilFileDirectoryType, directoryName: String)|在指定文件夹中创建文件夹|ZXKitUtil.shared.createFileDirectory(in: .documents, directoryName: "filePath")|
|func getFileSize(filePath: URL)|获取指定文件的大小|ZXKitUtil.shared.getFileSize(filePath: url)|
|func getFileDirectorySize(fileDirectoryPth: URL)|获取指定文件夹的大小|ZXKitUtil.shared.getFileDirectorySize(fileDirectoryPth: url)|

### 其他

#### ZXKitUtil

|名称|功能说明|示例|
|----|----|----|
|func getDictionary(object: Any, debug: Bool = false) -> [String: Any]|遍历获取class\struct的所有属性名和值|ZXKitUtil.shared.getDictionary(object: testModel)|
|func runInMainThread(type: ZXMainThreadType = .default, function: @escaping ()->Void)|主线程执行function|ZXKitUtil.shared.runInMainThread(type: .sync) { ... }|

#### String

|名称|功能说明|示例|
|----|----|----|
|func subString(rang: NSRange)|截取字符串|string.zx.subString(rang: NSRange(location: 2, length: 5))|
|func unicodeDecode()|unicode转中文|"\\u54c8\\u54c8\\u54c8".zx.unicodeDecode()|
|func unicodeEncode()|字符串转unicode|"哈哈是电话费".zx.unicodeEncode()|
|func encodeString(from originType: ZXKitUtilEncodeType = .system(.utf8), to encodeType: ZXKitUtilEncodeType)|字符串修改编码显示|"5ZOI5ZOI5piv55S16K+d6LS5".zx.encodeString(from: .base64, to: .system(.utf8))|
|func aesCBCEncrypt(password: String, ivString: String = "abcdefghijklmnop")|aes cbc模式加密|string.zx.aesCBCEncrypt(password: "password")|
|func aesCBCDecrypt(password: String, ivString: String = "abcdefghijklmnop")|aes cbc解密|string.zx.aesCBCDecrypt(password: "password")|
|func hashString(hashType: ZXKitUtilHashType, lowercase: Bool = true)|字符串hash计算|string.zx. hashString(hashType: .md5) <br/> 支持md5/sha1/sha224/sha256/sha384/sha512|
|func aesGCMEncrypt(password: String, encodeType: ZXKitUtilEncodeType = .base64, nonce: AES.GCM.Nonce? = AES.GCM.Nonce())|aes gcm模式加密|string.zx.aesGCMEncrypt(password: "password")|
|func aesGCMDecrypt(password: String, encodeType: ZXKitUtilEncodeType = .base64)|aes gcm模式解密|string.zx.aesGCMDecrypt(password: "password")|
|func hmac(hashType: ZXKitUtilHashType, password: String, encodeType: ZXKitUtilEncodeType = .base64)|HMAC计算|"ZXKitUtil".zx.hmac(hashType: .sha1, password: "67FG", encodeType: .hex)|

#### Data

|名称|功能说明|示例|
|----|----|----|
|static func data(from string: String, encodeType: ZXKitUtilEncodeType)|通过字符串和编码获取数据| Data.zx.data(from: "d5a423f64b607ea7c65b311d855dc48f36114b227bd0c7a3d403f6158a9e4412", encodeType: .hex)|
|func encodeString(encodeType: ZXKitUtilEncodeType)|数据转为指定编码的字符串| data.zx.encodeString(encodeType: .hex)|
|func aesCBCEncrypt(password: String, ivString: String = "abcdefghijklmnop")|aes cbc模式加密|data.zx.aesCBCEncrypt(password: "password")|
|func aesCBCDecrypt(password: String, ivString: String = "abcdefghijklmnop")|aes cbc解密|data.zx.aesCBCDecrypt(password: "password")|
|func hashString(hashType: ZXKitUtilHashType, lowercase: Bool = true)|字符串hash计算|data.zx. hashString(hashType: .md5) <br/> 支持md5/sha1/sha224/sha256/sha384/sha512|
|func aesGCMEncrypt(password: String, encodeType: ZXKitUtilEncodeType = .base64, nonce: AES.GCM.Nonce? = AES.GCM.Nonce())|aes gcm模式加密|data.zx.aesGCMEncrypt(password: "password")|
|func aesGCMDecrypt(password: String, encodeType: ZXKitUtilEncodeType = .base64)|aes gcm模式解密|data.zx.aesGCMDecrypt(password: "password")|
|func hmac(hashType: ZXKitUtilHashType, password: String, encodeType: ZXKitUtilEncodeType = .base64)|HMAC计算|data.zx.hmac(hashType: .sha1, password: "67FG", encodeType: .hex)|



## License协议

该项目基于MIT协议，您可以自由修改使用