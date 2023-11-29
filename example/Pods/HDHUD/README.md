# HDHUD


## [中文文档](https://blog.hudongdong.com/ios/1178.html)


## Screenshots

<img src="./demo.gif" style="width:350px" />

## Integration

Use `cocoapods` for integration

```
pod "HDHUD"
```

## Characteristics

* Easy to use, through different parameters to achieve different display effect
* Plain text display
* Display with icon, position of icon and picture supports customization
* Progress bar display
* Loading display
* Adaptive text size
* Multiple pop-up window sequence display, overlapping display, priority display
* Specifies to close pop ups that are not shown in the sequence

## show HUD

```
//show HUD
static func show(_ content: String? = nil, icon: HDHUDIconType = .none, direction: HDHUDContentDirection = .horizontal, duration: TimeInterval = 2.5, superView: UIView? = nil, mask: Bool = true, priority: HDHUDPriority = .high, didAppear: (()->Void)? = nil, completion: (()->Void)? = nil) -> HDHUDTask

//show progress HUD
static func showProgress(_ progress: Float, direction: HDHUDContentDirection = .horizontal, superView: UIView? = nil, mask: Bool = true, priority: HDHUDPriority = .high, didAppear: (()->Void)? = nil, completion: (()->Void)? = nil) -> HDHUDProgressTask

//show customview
static func show(customView: UIView, duration: TimeInterval = 2.5, superView: UIView? = nil, mask: Bool = true, priority: HDHUDPriority = .high, didAppear: (()->Void)? = nil, completion: (()->Void)? = nil) -> HDHUDTask
```

Use the above function to call the display function. All parameters have default values. Different styles can be displayed through different parameters, such as the following

```
HDHUD.show("Text Information", icon: .warn, direction: .vertical, duration: 3.0, superView: self.view, mask: true, priority: .high) {
       //Automatically closed callback
}

//plain text
HDHUD.show("纯文本展示")

//only icon
HDHUD.show(icon: .loading)
```

`content` specifies the pop-up content to be displayed

`icon`specifies the style of the icon, representing no icon, success, failure, warning and loading respectively

`direction` can specify the arrangement direction of icons and text content. The default arrangement is horizontal or vertical

`duration` specifies the self-defined disappearance time. If it is transferred to' - 1 ', it will be displayed all the time, but it will disappear automatically after being prompted under normal circumstances

`superView` Superview is the current 'window' by default. If you want to bind a 'VC' view, you can pass it in. In this way, it will be destroyed with the destruction of 'superview', and there will be no interface conflict

`mask` whether the views below the shell layer can be clicked. When the shell layer appears, there will be a layer mask by default. You can choose whether the views below the mask respond to the click event

`priority` This is a very convenient function for daily use. It provides the following four options

```
public enum HDHUDPriority {
    case low
    case overlay
    case high
    case sequence
}
```

If no toast is currently displayed, these four options are invalid. When an existing toast is displayed and a new toast has called display, it will be displayed according to the following priority logic

* `low` If a toast is displayed, this prompt will not be displayed and the priority will be the lowest
* `overlay` The prompt and the currently displayed toast are superimposed at the same time, and the two prompts will overlap
* `high` Close the toast currently being displayed, and immediately display the toast to be displayed. The default option is that if there are multiple toast, some toast may be hidden before being displayed. This is the logic of most HUD components
* `sequence` At the end of the toast currently displayed, display the toast to be displayed and add it to the sequence to ensure that each prompt can be displayed. If there are too many toast, users may have to wait for a long time


`didAppear` Callback after HUD display

`completion` Callback after HUD disappears

## progress HUD

The progress is optimized separately, so it is not necessary to hide and display

```
//Get progress pop-up task
let task = HDHUD.showProgress(0.1, direction: .vertical, priority: priority)

//Update progress
task.progress = 0.3
```

## custom view

The function of displaying user-defined view is reserved to display the view written by yourself

```
HDHUD.show(customView: customView)
```

Note: you need to set the size constraint for your own view. You can set it with snapkit, for example

```
lazy var mCustomView2: UIView = {
     let view = UIView()
     //设置大小
     view.snp.makeConstraints { (make) in
           make.width.equalTo(200)
           make.height.equalTo(100)
     }
     return view
}()


HDHUD.show(commonView: mCustomView2)
```

You can also use frame settings directly

```
lazy var mCustomView: UIView = {
     let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
     return view
}()

//显示
HDHUD.show(commonView: mCustomView)
```

## HUD hide

**NOTE: If there are other HUDs in the sequence to be displayed, the next HUD will be displayed**

```
//Hide current HUD
HDHUD.hide()

//Hides the specified HUD
let task = HDHUD.show("竖版排列")
HDHUD.hide(task: task)
```

## Clear all HUDs, including those not shown in the sequence

```
//Clear all HUDs. Completevalid sets Whether to call back the task completion when the hud in the sequence is cleared
static func clearAll(completeValid: Bool = false) {}

//for example
HDHUD.clearAll()
```

## Custom configuration

Provides a lot of customizable options, you can easily configure the background color, pop-up color, text color and so on

```
open class HDHUD {
    ///images
    public static var warnImage = UIImageHDBoundle(named: "ic_warning")
    public static var warnImageSize = CGSize(width: 24, height: 24)
    public static var errorImage = UIImageHDBoundle(named: "ic_error")
    public static var errorImageSize = CGSize(width: 24, height: 24)
    public static var successImage = UIImageHDBoundle(named: "ic_success")
    public static var successImageSize = CGSize(width: 24, height: 24)
    public static var loadingImage = getLoadingImage()
    public static var loadingImageSize = CGSize(width: 48, height: 48)
    public static var isVibrate = false	//Whether it vibrates when displaying HUD
    #if canImport(Kingfisher)
    //如果设置了`loadingImageURL`，加载图片将会优先使用URL资源
    // If `loadingImageURL` is set, the URL resource will be used preferentially when loading images
    public static var loadingImageURL: URL? = URL(fileURLWithPath: URLPathHDBoundle(named: "loading.gif") ?? "")
    #endif
    ///color and text
    public static var contentBackgroundColor = UIColor.zx.color(hexValue: 0x000000, alpha: 0.8)
    public static var backgroundColor = UIColor.zx.color(hexValue: 0x000000, alpha: 0.3) {
        willSet {
            self.bgView.backgroundColor = newValue
        }
    }
    public static var textColor = UIColor.zx.color(hexValue: 0xFFFFFF)
    public static var textFont = UIFont.systemFont(ofSize: 16)
    public static var contentOffset = CGPoint.zero
    public static var progressTintColor = UIColor.zx.color(hexValue: 0xFF8F0C)
    public static var trackTintColor = UIColor.zx.color(hexValue: 0xFFFFFF)
}
```

In particular, the `loading` icon uses the `image ` by default, and the loop mode provided by the system is ` UIImage.animatedImage(with: imageList, duration: 0.6)`. If you want to use `GIF ` images, you can integrate this pod

```
pod "HDHUD/gif"
```

After importing, set `HDHUD.loadingImageURL`. If `loadingImageURL` is set, the URL resource will be used preferentially when loading images

## Hide button

![](./demo.png)

When the `duration` of HUD is set to `-1`, HUD will always be displayed. In order to prevent the occurrence of logical bugs which will affect the user's operation. When the `duration` is - 1, a close button will be added in the upper right corner by default, which allows the user to decide whether to close the HUD. If you do not need this function, you can set `isShowCloseButton` to false

```
HDHUD.isShowCloseButton = false
```

## broken 1.3.6 -> 2.0.0

* Modify `userInteractionOnUnderlyingViewsEnabled` to `mask`, which has the **opposite** meaning. `mask` means that the view below the mask layer does not support click response, and the default value is `false`
* Modify `autoAddCloseButton` to `isShowCloseButton`

## Project

github: [https://github.com/DamonHu/HDHUD](https://github.com/DamonHu/HDHUD)