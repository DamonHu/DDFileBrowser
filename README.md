# ZXFileBrowser

![](https://img.shields.io/badge/CocoaPods-supported-brightgreen) ![](https://img.shields.io/badge/Swift-5.0-brightgreen) ![](https://img.shields.io/badge/License-MIT-brightgreen) ![](https://img.shields.io/badge/version-iOS11.0-brightgreen)

[English](./README_en.md)

如果您需要的是快速集成多个调试功能，例如日志查看、网速测试、文件查看等功能，请使用 [DamonHu/ZXKitSwift](https://github.com/DamonHu/ZXKitSwift)。

**该插件已经默认集成在[ZXKitSwift](https://github.com/DamonHu/ZXKitSwift)中，如果您已经集成了`ZXKitSwift`，无需重复集成该插件**


iOS端沙盒文件浏览器，可查看、复制、移动、删除文件等操作，使用苹果的`Quick Look`框架实现预览，长按显示更多操作


## 集成

cocoapods快速集成

```ruby
pod 'ZXFileBrowser'
```

### 使用

```swift
ZXFileBrowser.shared.start()
```

你可以调用下面这个函数获取指定路径的文件类型

```swift
ZXFileBrowser.shared.getFileType(filePath: path)
```

## 预览


|文件列表|文件类型|
|----|----|
|![](./preview/demo2.png)|![](./preview/demo1.png)|

功能示例

![](./preview/preview.gif)


## License

该项目基于MIT协议，您可以自由修改使用
