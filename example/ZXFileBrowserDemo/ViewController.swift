//
//  ViewController.swift
//  ZXFileBrowserDemo
//
//  Created by Damon on 2021/5/11.
//

import UIKit
import ZXKitCore
import ZXKitUtil

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.createUI()
        ZXKit.regist(plugin: ZXFileBrowser.shared)



        
    }

    func createUI() {
        self.view.backgroundColor = UIColor.white
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        button.backgroundColor = UIColor.red
        self.view.addSubview(button)
        button.addTarget(self, action: #selector(_click), for: .touchUpInside)
    }

    @objc func _click() {
        ZXKit.show()


        let path = Bundle.main.path(forResource: "1470296169586813", ofType: "jpg")
        if let path = path, let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            do {
                try data.write(to: ZXKitUtil.shared.getFileDirectory(type: .caches).appendingPathComponent("3333.jpg"))
            } catch  {
                print(error)
            }
        }
    }

}

