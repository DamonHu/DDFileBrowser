# ZXFileBrowser

[中文文档](./README_zh.md)


The iOS sandbox file browser can view, copy, move, delete files and other operations.

This project is a built-in function plug-in of [ZXKitSwift](https://github.com/ZXKitCode/ZXKitSwift), and it can also be integrated separately and used as an independent function.

**If you have integrated `ZXKitSwift`, the file browser will be automatically displayed in the plug-in list, so there is no need to repeat the integration.**


## Independent integration

cocoapods

```ruby
pod 'ZXFileBrowser'
```

### Use

```swift
ZXFileBrowser.shared.start()
```

## Support `ZXKit`

**If you have integrated `ZXKitSwift`, the file browser will be automatically displayed in the plug-in list, so there is no need to repeat the integration.**

If you need to support `ZXKit`, you can use cocoapods to quickly integrate it

```ruby
pod 'ZXFileBrowser/zxkit'
```

then register to `ZXKit` in `AppDelegate`

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
	
	ZXKit.regist(plugin: ZXFileBrowser.shared)
	
	return true
}
```

## Preview

![](./preview.gif)


## License

![](https://camo.githubusercontent.com/eb9066a6d8e0950066f3757c420e3a607c0929583b48ebda6fd9a6f50ccfc8f1/68747470733a2f2f7777772e6170616368652e6f72672f696d672f41534632307468416e6e69766572736172792e6a7067)

Base on Apache-2.0 License
