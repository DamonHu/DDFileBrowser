//
//  ZXFileBrowserVC.swift
//  ZXFileBrowserDemo
//
//  Created by Damon on 2021/5/12.
//

import UIKit
import ZXKitUtil

func UIImageHDBoundle(named: String?) -> UIImage? {
    guard let name = named else { return nil }
    guard let bundlePath = Bundle(for: ZXFileBrowser.self).path(forResource: "ZXFileBrowser", ofType: "bundle") else { return nil }
    let bundle = Bundle(path: bundlePath)
    return UIImage(named: name, in: bundle, compatibleWith: nil)
}

class ZXFileBrowserVC: UIViewController {
    var mTableViewList = [ZXFileModel]()
    var mSelectedDirectoryPath = "" //当前的文件夹
    var mSelectedFilePath: URL?      //选择操作的文件路径
    var currentDirectoryPath: URL {
        return ZXKitUtil.shared().getFileDirectory(type: .home).appendingPathComponent(self.mSelectedDirectoryPath, isDirectory: true)
    }


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
        var array = mSelectedDirectoryPath.components(separatedBy: "/")
        array.removeLast()
        mSelectedDirectoryPath = array.joined(separator: "/")
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

private extension ZXFileBrowserVC {
    func _createUI() {
        self.view.backgroundColor = UIColor.zx.color(hexValue: 0xffffff)
        self.view.addSubview(mTableView)
        mTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func _loadData() {
        if mSelectedDirectoryPath.isEmpty {
            self.navigationItem.leftBarButtonItem = nil
        } else {
            let leftBarItem = UIBarButtonItem(title: NSLocalizedString("back", comment: ""), style: .plain, target: self, action: #selector(_leftBarItemClick))
            self.navigationItem.leftBarButtonItem = leftBarItem
        }
        let manager = FileManager.default
        mTableViewList.removeAll()
        let fileDirectoryPth = self.currentDirectoryPath
        if manager.fileExists(atPath: fileDirectoryPth.path), let subPath = try? manager.contentsOfDirectory(atPath: fileDirectoryPth.path) {
            for fileName in subPath {
                let filePath = fileDirectoryPth.path.appending("/\(fileName)")
                //对象
                let fileModel = ZXFileModel(name: fileName)
                //属性
                var isDirectory: ObjCBool = false
                if manager.fileExists(atPath: filePath, isDirectory: &isDirectory) {
                    fileModel.isDirectory = isDirectory.boolValue
                    if let fileAttributes = try? manager.attributesOfItem(atPath: filePath) {
                        fileModel.modificationDate = fileAttributes[FileAttributeKey.modificationDate] as? Date ?? Date()
                        if isDirectory.boolValue {
                            fileModel.size = ZXKitUtil.shared().getFileDirectorySize(fileDirectoryPth: URL(fileURLWithPath: filePath))
                        } else {
                            fileModel.size = fileAttributes[FileAttributeKey.size] as? Double ?? 0
                        }
                    }
                    mTableViewList.append(fileModel)
                }
            }
        }
        mTableView.reloadData()
    }

    func _showMore() {
        guard let filePath = mSelectedFilePath else { return }
        let alertVC = UIAlertController(title:NSLocalizedString("File operations", comment: ""),message: filePath.lastPathComponent, preferredStyle: UIAlertController.Style.actionSheet)
        if let popoverPresentationController = alertVC.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = CGRect(x: 10, y: UIScreenHeight - 300, width: UIScreenWidth - 20, height: 300)
        }

        let alertAction1 = UIAlertAction(title: NSLocalizedString("share", comment: ""), style: UIAlertAction.Style.default) {[weak self] (alertAction) in
            guard let self = self else { return }
            self._share()
        }

        let alertAction2 = UIAlertAction(title: NSLocalizedString("copy", comment: ""), style: UIAlertAction.Style.default) {[weak self] (alertAction) in
            guard let self = self else { return }
            let rightBarItem = UIBarButtonItem(title: NSLocalizedString("paste here", comment: ""), style: .plain, target: self, action: #selector(self._copy))
            self.navigationItem.rightBarButtonItem = rightBarItem
        }

        let alertAction3 = UIAlertAction(title: NSLocalizedString("move", comment: ""), style: UIAlertAction.Style.default) {[weak self] (alertAction) in
            guard let self = self else { return }
            let rightBarItem = UIBarButtonItem(title: NSLocalizedString("move here", comment: ""), style: .plain, target: self, action: #selector(self._move))
            self.navigationItem.rightBarButtonItem = rightBarItem
        }

        let alertAction4 = UIAlertAction(title: NSLocalizedString("delete", comment: ""), style: UIAlertAction.Style.destructive) {[weak self] (alertAction) in
            guard let self = self else { return }
            self._delete(filePath: filePath)
        }

        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: UIAlertAction.Style.cancel) { (alertAction) in

        }
        alertVC.addAction(alertAction1)
        alertVC.addAction(alertAction2)
        alertVC.addAction(alertAction3)
        alertVC.addAction(alertAction4)
        alertVC.addAction(cancelAction)
        self.present(alertVC, animated: true, completion: nil)
    }

    func _share() {
        guard let filePath = mSelectedFilePath else { return }
        let activityVC = UIActivityViewController(activityItems: [filePath], applicationActivities: nil)
        if UIDevice.current.model == "iPad" {
            activityVC.modalPresentationStyle = UIModalPresentationStyle.popover
            activityVC.popoverPresentationController?.sourceView = self.view
            activityVC.popoverPresentationController?.sourceRect = CGRect(x: 10, y: UIScreenHeight - 300, width: UIScreenWidth - 20, height: 300)
        }
        self.present(activityVC, animated: true, completion: nil)
    }

    @objc func _copy() {
        let rightBarItem = UIBarButtonItem(title: NSLocalizedString("close", comment: ""), style: .plain, target: self, action: #selector(_rightBarItemClick))
        self.navigationItem.rightBarButtonItem = rightBarItem

        guard let filePath = mSelectedFilePath else { return }
        let manager = FileManager.default
        let currentPath = self.currentDirectoryPath.appendingPathComponent(filePath.lastPathComponent, isDirectory: false)
        do {
            try manager.copyItem(at: filePath, to: currentPath)
        } catch {
            print(error)
        }
        self._loadData()
    }

    @objc func _move() {
        let rightBarItem = UIBarButtonItem(title: NSLocalizedString("close", comment: ""), style: .plain, target: self, action: #selector(_rightBarItemClick))
        self.navigationItem.rightBarButtonItem = rightBarItem

        guard let filePath = mSelectedFilePath else { return }
        let manager = FileManager.default
        let currentPath = self.currentDirectoryPath.appendingPathComponent(filePath.lastPathComponent, isDirectory: false)
        do {
            try manager.moveItem(at: filePath, to: currentPath)
        } catch {
            print(error)
        }
        self._loadData()
    }

    func _delete(filePath: URL) {
        guard let filePath = mSelectedFilePath else { return }
        let manager = FileManager.default
        do {
            try manager.removeItem(at: filePath)
        } catch {
            print(error)
        }
        self._loadData()
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
            mSelectedDirectoryPath = mSelectedDirectoryPath + "/" + model.name
            self._loadData()
        } else {
            let rightBarItem = UIBarButtonItem(title: NSLocalizedString("close", comment: ""), style: .plain, target: self, action: #selector(_rightBarItemClick))
            self.navigationItem.rightBarButtonItem = rightBarItem
            self.mSelectedFilePath = self.currentDirectoryPath.appendingPathComponent(model.name, isDirectory: false)
            self._showMore()
        }
    }
}
