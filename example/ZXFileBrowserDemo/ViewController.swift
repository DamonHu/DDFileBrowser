//
//  ViewController.swift
//  ZXFileBrowserDemo
//
//  Created by Damon on 2021/5/11.
//

import UIKit
import ZXKitUtil

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.createUI()
    }

    func createUI() {
        self.view.backgroundColor = UIColor.white
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 60))
        button.setTitle("写入数据", for: .normal)
        button.backgroundColor = UIColor.red
        self.view.addSubview(button)
        button.addTarget(self, action: #selector(_writeData), for: .touchUpInside)

        let button2 = UIButton(frame: CGRect(x: 100, y: 200, width: 100, height: 60))
        button2.setTitle("打开浏览器", for: .normal)
        button2.backgroundColor = UIColor.red
        self.view.addSubview(button2)
        button2.addTarget(self, action: #selector(_openBrowser), for: .touchUpInside)
    }

    @objc func _writeData() {
        print(ZXKitUtil.shared.getFileDirectory(type: .caches))
        for i in 0..<300000 {
            //写入测试数据
            let path = Bundle.main.path(forResource: "1470296169586813", ofType: "jpg")
            if let path = path, let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                do {
                    try data.write(to: ZXKitUtil.shared.getFileDirectory(type: .caches).appendingPathComponent("3333_\(i).jpg"))
                } catch  {
                    print(error)
                }
            }
        }
        
        let videoPath = Bundle.main.path(forResource: "1594468497552", ofType: "mp4")
        if let path = videoPath, let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            do {
                try data.write(to: ZXKitUtil.shared.getFileDirectory(type: .caches).appendingPathComponent("test.mp4"))
            } catch  {
                print(error)
            }
        }
        
        let zipPath = Bundle.main.path(forResource: "test", ofType: "zip")
        if let path = zipPath, let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            do {
                try data.write(to: ZXKitUtil.shared.getFileDirectory(type: .caches).appendingPathComponent("test.zip"))
            } catch  {
                print(error)
            }
        }
        
        let webPath = Bundle.main.path(forResource: "test", ofType: "html")
        if let path = webPath, let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            do {
                try data.write(to: ZXKitUtil.shared.getFileDirectory(type: .caches).appendingPathComponent("test.html"))
            } catch  {
                print(error)
            }
        }
        
        let testPath = Bundle.main.path(forResource: "test", ofType: "txt")
        if let path = testPath, let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            do {
                try data.write(to: ZXKitUtil.shared.getFileDirectory(type: .caches).appendingPathComponent("test.txt"))
            } catch  {
                print(error)
            }
        }
        
        let audioPath = Bundle.main.path(forResource: "空谷", ofType: "wav")
        if let path = audioPath, let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            do {
                try data.write(to: ZXKitUtil.shared.getFileDirectory(type: .caches).appendingPathComponent("test.wav"))
            } catch  {
                print(error)
            }
        }
        
        let docPath = Bundle.main.path(forResource: "test", ofType: "docx")
        if let path = docPath, let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            do {
                try data.write(to: ZXKitUtil.shared.getFileDirectory(type: .caches).appendingPathComponent("test.docx"))
            } catch  {
                print(error)
            }
        }
        
        let logPath = Bundle.main.path(forResource: "test", ofType: "log")
        if let path = logPath, let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            do {
                try data.write(to: ZXKitUtil.shared.getFileDirectory(type: .caches).appendingPathComponent("test.log"))
            } catch  {
                print(error)
            }
        }
        
        let pdfPath = Bundle.main.path(forResource: "test", ofType: "pdf")
        if let path = pdfPath, let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            do {
                try data.write(to: ZXKitUtil.shared.getFileDirectory(type: .caches).appendingPathComponent("test.pdf"))
            } catch  {
                print(error)
            }
        }
        
        let swiftPath = Bundle.main.path(forResource: "test", ofType: "js")
        if let path = swiftPath, let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            do {
                try data.write(to: ZXKitUtil.shared.getFileDirectory(type: .caches).appendingPathComponent("test.js"))
            } catch  {
                print(error)
            }
        }
        
        let pptPath = Bundle.main.path(forResource: "test", ofType: "pptx")
        if let path = pptPath, let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            do {
                try data.write(to: ZXKitUtil.shared.getFileDirectory(type: .caches).appendingPathComponent("test.pptx"))
            } catch  {
                print(error)
            }
        }
        
        let xlsPath = Bundle.main.path(forResource: "test", ofType: "xlsx")
        if let path = xlsPath, let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            do {
                try data.write(to: ZXKitUtil.shared.getFileDirectory(type: .caches).appendingPathComponent("test.xlsx"))
            } catch  {
                print(error)
            }
        }
        
        let dbPath = Bundle.main.path(forResource: "test", ofType: "db")
        if let path = dbPath, let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            do {
                try data.write(to: ZXKitUtil.shared.getFileDirectory(type: .caches).appendingPathComponent("test.db"))
            } catch  {
                print(error)
            }
        }
    }

    @objc func _openBrowser() {
//        ZXFileBrowser.shared.rootDirectoryPath = ZXKitUtil.shared.getFileDirectory(type: .caches)
        ZXFileBrowser.shared.start()
    }

}

