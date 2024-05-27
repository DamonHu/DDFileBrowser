# DDFileBrowser

![](https://img.shields.io/badge/CocoaPods-supported-brightgreen) ![](https://img.shields.io/badge/Swift-5.0-brightgreen) ![](https://img.shields.io/badge/License-MIT-brightgreen) ![](https://img.shields.io/badge/version-iOS11.0-brightgreen)


iOS端沙盒文件浏览器，可查看、复制、移动、删除文件等操作，使用苹果的`Quick Look`框架实现预览，长按显示更多操作


## 集成

cocoapods快速集成

```ruby
pod 'DDFileBrowser'
```

### 使用

```swift
DDFileBrowser.shared.start()
```

你可以调用下面这个函数获取指定路径的文件类型

```swift
DDFileBrowser.shared.getFileType(filePath: path)
```

#### 指定预览的根目录

默认根目录是app的根目录，如果有特殊需求，比如只让用户查看某个目录，则可以设置根目录即可

```
DDFileBrowser.shared.rootDirectoryPath = ZXKitUtil.shared.getFileDirectory(type: .caches)
```

## 预览


|文件列表|文件类型|
|----|----|
|![](./preview/demo2.png)|![](./preview/demo1.png)|

功能示例

![](./preview/preview.gif)


## License

该项目基于MIT协议，您可以自由修改使用
