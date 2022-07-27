# ZXFileBrowser

![](https://img.shields.io/badge/CocoaPods-supported-brightgreen) ![](https://img.shields.io/badge/Swift-5.0-brightgreen) ![](https://img.shields.io/badge/License-MIT-brightgreen) ![](https://img.shields.io/badge/version-iOS11.0-brightgreen)

[中文文档](./README.md)

If you need to quickly integrate multiple debugging functions, such as log viewing, network speed testing, file viewing and so on, please use [DamonHu/ZXKitSwift](https://github.com/DamonHu/ZXKitSwift)

The plug-in has been integrated in [ZXKitSwift](https://github.com/DamonHu/ZXKitSwift) by default, if you have already integrated `ZXKitSwift`, there is no need to repeat the integration


The iOS sandbox file browser can view, copy, move, delete files and other operations. Use `quick look` framework to preview and long press to display more operations.

## Independent integration

cocoapods

```ruby
pod 'ZXFileBrowser'
```

### Use

```swift
ZXFileBrowser.shared.start()
```

you can get the file type of the specified path by this function

```swift
ZXFileBrowser.shared.getFileType(filePath: path)
```


## Preview

|File List|File Type Icon|
|----|----|
|![](./preview/demo2.png)|![](./preview/demo1.png)|

Function example

![](./preview/preview.gif)

## License

The project is based on the MIT License
