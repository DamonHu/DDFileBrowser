//
//  ZXKit.swift
//  ZXKit
//
//  Created by Damon on 2021/4/23.
//

import UIKit

extension String{
    var ZXLocaleString: String {
        guard let bundlePath = Bundle(for: ZXKit.self).path(forResource: "ZXKitCore", ofType: "bundle") else { return NSLocalizedString(self, comment: "") }
        guard let bundle = Bundle(path: bundlePath) else { return NSLocalizedString(self, comment: "") }
        let msg = NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
        return msg
    }
}

public extension NSNotification.Name {
    static let ZXKitPluginRegist = NSNotification.Name("ZXKitPluginRegist")
    static let ZXKitShow = NSNotification.Name("ZXKitShow")
    static let ZXKitHide = NSNotification.Name("ZXKitHide")
    static let ZXKitClose = NSNotification.Name("ZXKitClose")
}

public class ZXKit: NSObject {
    private static var window: ZXKitWindow?
    private static var floatWindow: ZXKitFloatWindow?
    static var pluginList = [[ZXKitPluginProtocol](), [ZXKitPluginProtocol](), [ZXKitPluginProtocol]()]
    
    public static var floatButton: UIButton? {
        return self.floatWindow?.mButton
    }

    public static var textField: UITextField? {
        return self.window?.mTextField
    }


    public static func resetFloatButton() {
        self.floatButton?.backgroundColor = UIColor.zx.color(hexValue: 0x5dae8b)
        self.floatButton?.setTitle("Z".ZXLocaleString, for: UIControl.State.normal)
        self.floatButton?.titleLabel?.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        self.floatButton?.layer.borderColor = UIColor.zx.color(hexValue: 0xffffff).cgColor
        self.floatButton?.zx.addLayerShadow(color: UIColor.zx.color(hexValue: 0x333333), offset: CGSize(width: 2, height: 2), radius: 4, cornerRadius: 30)
        self.floatButton?.layer.borderWidth = 4.0
        self.floatButton?.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
    }

    public static func regist(plugin: ZXKitPluginProtocol) {
        var index = 0
        switch plugin.pluginType {
            case .ui:
                index = 0
            case .data:
                index = 1
            case .other:
                index = 2
        }
        if !self.pluginList[index].contains(where: { (tPlugin) -> Bool in
            return tPlugin.pluginIdentifier == plugin.pluginIdentifier
        }) {
            self.pluginList[index].append(plugin)
        }
        if let window = self.window, !window.isHidden {
            DispatchQueue.main.async {
                window.reloadData()
            }
        }
        NotificationCenter.default.post(name: .ZXKitPluginRegist, object: self.pluginList)
    }

    public static func show() {
        NotificationCenter.default.post(name: .ZXKitShow, object: nil)
        DispatchQueue.main.async {
            self.floatWindow?.isHidden = true
            if let window = self.window {
                window.isHidden = false
            } else {
                if #available(iOS 13.0, *) {
                    for windowScene:UIWindowScene in ((UIApplication.shared.connectedScenes as? Set<UIWindowScene>)!) {
                        if windowScene.activationState == .foregroundActive {
                            self.window = ZXKitWindow(windowScene: windowScene)
                            self.window?.frame = UIScreen.main.bounds
                        }
                    }
                }
                if self.window == nil {
                    self.window = ZXKitWindow(frame: UIScreen.main.bounds)
                }
                self.window?.isHidden = false
                self.window?.reloadData()
            }
        }
    }

    public static func hide() {
        NotificationCenter.default.post(name: .ZXKitHide, object: nil)
        DispatchQueue.main.async {
            self.window?.isHidden = true
            //float window
            if let window = self.floatWindow {
                window.isHidden = false
            } else {
                if #available(iOS 13.0, *) {
                    for windowScene:UIWindowScene in ((UIApplication.shared.connectedScenes as? Set<UIWindowScene>)!) {
                        if windowScene.activationState == .foregroundActive {
                            self.floatWindow = ZXKitFloatWindow(windowScene: windowScene)
                            self.floatWindow?.frame = CGRect(x: UIScreen.main.bounds.size.width - 80, y: 100, width: 60, height: 60)
                        }
                    }
                }
                if self.floatWindow == nil {
                    self.floatWindow = ZXKitFloatWindow(frame: CGRect(x: UIScreen.main.bounds.size.width - 80, y: 100, width: 60, height: 60))
                }
                self.floatWindow?.isHidden = false
            }
        }
    }

    public static func close() {
        NotificationCenter.default.post(name: .ZXKitClose, object: nil)
        DispatchQueue.main.async {
            self.window?.isHidden = true
            self.floatWindow?.isHidden = true
        }
    }

    public static func showInput(complete: ((String)->Void)?) {
        ZXKit.show()
        self.window?.showInput(complete: complete)
    }
}
