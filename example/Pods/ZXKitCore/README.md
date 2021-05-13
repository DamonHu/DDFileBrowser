# ZXKitCore

[中文文档](./README_zh.md)

`ZXKitSwift` is a development and debugging tool integrated with iOS platform, named after my favorite novel "Zhu Xian". `ZXKitCore` is the supporting framework of `ZXKitSwift`, which is mainly used by developers of `ZXKitSwift`.

> 天地不仁，以万物为刍狗
> 
> The world is not benevolent, and everything is a dog

## 1、Add plugin for ZXKit

If you need to develop a custom plug-in, you only need to implement `ZXKitPluginProtocol`. The way of implementation is very simple.

## 1. Import the core file

Project import `ZXKitCore`, you can use cocoapods to quickly import core files

```
pod 'ZXKitCore/core'
```

## 2. Implement the agreement

Declare an object and follow the `ZXKitPluginProtocol` protocol. Respectively return the unique ID of the plug-in, the corresponding icon, plug-in name, plug-in type grouping, and startup function

```
class PluginDemo: NSObject {
    var isPluginRunning = true
}

extension PluginDemo: ZXKitPluginProtocol {
    var pluginIdentifier: String {
        return "com.zxkit.pluginDemo"
    }
    
    var pluginIcon: UIImage? {
        return UIImage(named: "zxkit")
    }

    var pluginTitle: String {
        return "title"
    }

    var pluginType: ZXKitPluginType {
        return .ui
    }

    func start() {
        print("start plugin")
        isPluginRunning = true
    }
    
    var isRunning: Bool {
        return isPluginRunning
    }

    func stop() {
        print("plugin stop running")
        isPluginRunning = false
    }
}
```

## 3. Register the plug-in

After that, you can register the plug-in, you only need to register once globally

## 4. Done

After cocoapods is released and online, when the user opens `ZXKit`, your plug-in will appear on the debug collection page

## 5. More configurations

### 5.1、get floate button

```
ZXKit.floatButton
```

### 5.2、reset Float Button

```
ZXKit.resetFloatButton()
```

### 5.3、Display textField

```
ZXKit.showInput { (text) in
	print(text)
}
```

### 5.4、get textField

```
ZXKit.textField
```

## 2、NSNotification

`ZXKitCore` provides the following message notifications, you can get the frame display, hide, close, and register new plug-in timing by binding the following notifications

```
//new plug-in regist
NSNotification.Name.ZXKitPluginRegist
//show
NSNotification.Name.ZXKitShow
//hide
NSNotification.Name.ZXKitHide
//close
NSNotification.Name.ZXKitClose
```

## Default installation

We will collect excellent debugging libraries from time to time. When users execute the installation of `ZXKitSwift`, they will be installed by default. If you want to include the plug-in in the default integrated library of `ZXKitSwift`, first confirm that you are not using the `iOS` private functions and other illegal factors that affect the App Store listing, and then you can download it in [ZXKitSwift](https://github.com/ZXKitCode/ZXKitSwift) just notify us

## License

![](https://camo.githubusercontent.com/eb9066a6d8e0950066f3757c420e3a607c0929583b48ebda6fd9a6f50ccfc8f1/68747470733a2f2f7777772e6170616368652e6f72672f696d672f41534632307468416e6e69766572736172792e6a7067)

Base on Apache-2.0 License
