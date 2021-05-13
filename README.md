# ZXFileBrowser

[中文文档](./README_zh.md)


The iOS sandbox file browser can view, copy, move, delete files and other operations.

This project is a built-in function plug-in of [ZXKitSwift](https://github.com/ZXKitCode/ZXKitSwift), it only needs to integrate `ZXKitSwift` and it can be used without configuration. You can also integrate it separately and use it as an independent function.


## Independent integration

cocoapods

```ruby
pod 'ZXFileBrowser'
```

### Use

```swift
ZXFileBrowser.shared().start()
```

## Support `ZXKit`

If you need to support `ZXKit`, you can use cocoapods to quickly integrate it, and then register to use it in the list display

```ruby
pod 'ZXFileBrowser/zxkit'
```

```swift
//ZXKit registration
ZXKit.regist(plugin: ZXFileBrowser.shared())
```

## Preview

![](./preview.gif)


## License

![](https://camo.githubusercontent.com/eb9066a6d8e0950066f3757c420e3a607c0929583b48ebda6fd9a6f50ccfc8f1/68747470733a2f2f7777772e6170616368652e6f72672f696d672f41534632307468416e6e69766572736172792e6a7067)

Base on Apache-2.0 License
