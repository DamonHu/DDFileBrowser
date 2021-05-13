# ZXFileBrowser

iOS端沙盒文件浏览器，可查看、复制、移动、删除文件等操作。

该项目是[ZXKitSwift](https://github.com/ZXKitCode/ZXKitSwift)的内置功能插件，也可以单独集成当做独立功能使用。

**如果您已经集成了`ZXKitSwift`，插件列表中会自动显示该文件浏览器，不需要再重复集成。**


## 独立集成

cocoapods快速集成

```ruby
pod 'ZXFileBrowser'
```

### 使用

```swift
ZXFileBrowser.shared().start()
```

## 支持`ZXKit`

**如果您已经集成了`ZXKitSwift`，插件列表中会自动显示该文件浏览器，不需要再重复集成。**

如果需要支持`ZXKit`，可以使用cocoapods快速集成

```ruby
pod 'ZXFileBrowser/zxkit'
```

之后可在`AppDelegate`的启动函数中注册到`ZXKit`即可

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
	
	//ZXKit注册
	ZXKit.regist(plugin: ZXFileBrowser.shared())
	
	return true
}

```

## 预览

![](./preview.gif)


## License

![](https://camo.githubusercontent.com/eb9066a6d8e0950066f3757c420e3a607c0929583b48ebda6fd9a6f50ccfc8f1/68747470733a2f2f7777772e6170616368652e6f72672f696d672f41534632307468416e6e69766572736172792e6a7067)

Base on Apache-2.0 License
