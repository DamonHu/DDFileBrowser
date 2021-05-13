//
//  ZXFileBrowserVC.swift
//  ZXFileBrowserDemo
//
//  Created by Damon on 2021/5/12.
//

import UIKit
import ZXKitUtil

class ZXFileBrowserVC: UIViewController {
    var mTableViewList = [ZXFileModel]()
    var mSelectedPath = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        let rightBarItem = UIBarButtonItem(title: NSLocalizedString("close", comment: ""), style: .plain, target: self, action: #selector(_rightBarItemClick))
        self.navigationItem.rightBarButtonItem = rightBarItem

        self._createUI()
        self._loadData()
    }

    @objc func _rightBarItemClick() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func _leftBarItemClick() {
        print(mSelectedPath)
        var array = mSelectedPath.components(separatedBy: "/")
        array.removeLast()
        mSelectedPath = array.joined(separator: "/")
        self._loadData()
    }

    lazy var mTableView: UITableView = {
        let tTableView = UITableView(frame: CGRect.zero, style: UITableView.Style.grouped)
        tTableView.rowHeight = 60
        tTableView.backgroundColor = UIColor.clear
        tTableView.showsVerticalScrollIndicator = false
        tTableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        tTableView.dataSource = self
        tTableView.delegate = self
        tTableView.register(ZXFileTableViewCell.self, forCellReuseIdentifier: "ZXFileTableViewCell")
        return tTableView
    }()
}

extension ZXFileBrowserVC {
    func _createUI() {
        self.view.backgroundColor = UIColor.zx.color(hexValue: 0xffffff)
        self.view.addSubview(mTableView)
        mTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func _loadData() {
        if mSelectedPath.isEmpty {
            self.navigationItem.leftBarButtonItem = nil
        } else {
            let leftBarItem = UIBarButtonItem(title: NSLocalizedString("back", comment: ""), style: .plain, target: self, action: #selector(_leftBarItemClick))
            self.navigationItem.leftBarButtonItem = leftBarItem
        }
        let manager = FileManager.default
        mTableViewList.removeAll()
        let fileDirectoryPth = ZXKitUtil.shared().getFileDirectory(type: .home).appendingPathComponent(mSelectedPath, isDirectory: true)
        if manager.fileExists(atPath: fileDirectoryPth.path), let subPath = try? manager.contentsOfDirectory(atPath: fileDirectoryPth.path) {
            for fileName in subPath {
                let filePath = fileDirectoryPth.path.appending("/\(fileName)")
                //对象
                let fileModel = ZXFileModel(name: fileName)
                //属性
                var isDirectory: ObjCBool = false
                if manager.fileExists(atPath: filePath, isDirectory: &isDirectory), let fileAttributes = try? manager.attributesOfItem(atPath: filePath) {
                    fileModel.isDirectory = isDirectory.boolValue
                    fileModel.modificationDate = fileAttributes[FileAttributeKey.modificationDate] as? Date ?? Date()
                    if isDirectory.boolValue {
                        fileModel.size = ZXKitUtil.shared().getFileDirectorySize(fileDirectoryPth: URL(fileURLWithPath: filePath))
                    } else {
                        fileModel.size = fileAttributes[FileAttributeKey.size] as? Double ?? 0
                    }

                    mTableViewList.append(fileModel)
                }
            }
        }
        mTableView.reloadData()
    }
}

extension ZXFileBrowserVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mTableViewList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.mTableViewList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ZXFileTableViewCell") as! ZXFileTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        if model.isDirectory {
            cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        } else {
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }

        cell.updateUI(model: model)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.mTableViewList[indexPath.row]
        if model.isDirectory {
            print(model.name)
            mSelectedPath = mSelectedPath + "/" + model.name
            self._loadData()
        } else {
            print(model.name, "文件操作")
        }

    }
}
