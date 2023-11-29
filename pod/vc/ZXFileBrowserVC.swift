//
//  ZXFileBrowserVC.swift
//  ZXFileBrowserDemo
//
//  Created by Damon on 2021/5/12.
//

import UIKit
import ZXKitUtil
import MobileCoreServices
import QuickLook
import HDHUD

func UIImageHDBoundle(named: String?) -> UIImage? {
    guard let name = named else { return nil }
    guard let bundlePath = Bundle(for: ZXFileBrowser.self).path(forResource: "ZXFileBrowser", ofType: "bundle") else { return UIImage(named: name) }
    guard let bundle = Bundle(path: bundlePath) else { return UIImage(named: name) }
    return UIImage(named: name, in: bundle, compatibleWith: nil)
}

extension String{
    var ZXLocaleString: String {
        guard let bundlePath = Bundle(for: ZXFileBrowser.self).path(forResource: "ZXFileBrowser", ofType: "bundle") else { return NSLocalizedString(self, comment: "") }
        guard let bundle = Bundle(path: bundlePath) else { return NSLocalizedString(self, comment: "") }
        let msg = NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
        return msg
    }
}

class ZXFileBrowserVC: UIViewController {
    var mTableViewList = [ZXFileModel]()
    var extensionDirectoryPath = "" //选择的相对路径
    var operateFileModel: ZXFileModel?  //操作的文件，例如复制、粘贴等
    var currentDirectoryPath: URL { //当前的文件夹
        print(ZXFileBrowser.shared.rootDirectoryPath)
        return ZXFileBrowser.shared.rootDirectoryPath.appendingPathComponent(self.extensionDirectoryPath, isDirectory: true)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        let rightBarItem = UIBarButtonItem(title: "close".ZXLocaleString, style: .plain, target: self, action: #selector(_rightBarItemClick))
        self.navigationItem.rightBarButtonItem = rightBarItem

        self._createUI()
        self._loadData()
    }

    @objc func _rightBarItemClick() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func _leftBarItemClick() {
        var array = extensionDirectoryPath.components(separatedBy: "/")
        array.removeLast()
        extensionDirectoryPath = array.joined(separator: "/")
        self._loadData()
    }

    lazy var mTableView: UITableView = {
        let tTableView = UITableView(frame: CGRect.zero, style: UITableView.Style.grouped)
        if #available(iOS 15.0, *) {
            tTableView.sectionHeaderTopPadding = 0
        }
        tTableView.estimatedSectionHeaderHeight = 0
        tTableView.estimatedSectionFooterHeight = 0
        tTableView.rowHeight = 60
        tTableView.estimatedRowHeight = 60
        tTableView.backgroundColor = UIColor.clear
        tTableView.showsVerticalScrollIndicator = false
        tTableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        tTableView.dataSource = self
        tTableView.delegate = self
        tTableView.register(ZXFileTableViewCell.self, forCellReuseIdentifier: "ZXFileTableViewCell")
        return tTableView
    }()
    
    lazy var mEmptyLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "This folder is empty~"
        label.textColor = UIColor.zx.color(hexValue: 0x666666)
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
}

private extension ZXFileBrowserVC {
    func _createUI() {
        self.view.backgroundColor = UIColor.zx.color(hexValue: 0xffffff)
        self.view.addSubview(mTableView)
        mTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.view.addSubview(mEmptyLabel)
        mEmptyLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    func _loadData() {
        if extensionDirectoryPath.isEmpty {
            self.navigationItem.leftBarButtonItem = nil
        } else {
            let leftBarItem = UIBarButtonItem(title: "back".ZXLocaleString, style: .plain, target: self, action: #selector(_leftBarItemClick))
            self.navigationItem.leftBarButtonItem = leftBarItem
        }
        mTableViewList.removeAll()
        let manager = FileManager.default
        let fileDirectoryPth = self.currentDirectoryPath
        
        if let subPath = try? manager.contentsOfDirectory(atPath: fileDirectoryPth.path) {
            let total = subPath.count
            if total <= 100 {
                self.mTableViewList = subPath.map({ fileName in
                    let filePath = fileDirectoryPth.path.appending("/\(fileName)")
                    //对象
                    let fileModel = ZXFileModel(name: fileName, filepath: URL(fileURLWithPath: filePath))
                    return fileModel
                })
                self.mEmptyLabel.isHidden = !self.mTableViewList.isEmpty
                self.mTableView.reloadData()
            } else {
                //大于100个显示进度条
                HDHUD.show(icon: .loading, mask: true, didAppear: { [weak self] in
                    guard let self = self else { return }
                    for i in 0..<total {
                        let fileName = subPath[i]
                        let filePath = fileDirectoryPth.path.appending("/\(fileName)")
                        //对象
                        let fileModel = ZXFileModel(name: fileName, filepath: URL(fileURLWithPath: filePath))
                        self.mTableViewList.append(fileModel)
                    }
                    self.mEmptyLabel.isHidden = !self.mTableViewList.isEmpty
                    self.mTableView.reloadData()
                    HDHUD.hide()
                })
            }
        } else {
            self.mEmptyLabel.isHidden = !self.mTableViewList.isEmpty
            self.mTableView.reloadData()
        }
    }

    func _showMore(model: ZXFileModel) {
        let alertVC = UIAlertController(title: "File operations".ZXLocaleString, message: model.name, preferredStyle: UIAlertController.Style.actionSheet)
        if let popoverPresentationController = alertVC.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = CGRect(x: 10, y: UIScreenHeight - 300, width: UIScreenWidth - 20, height: 300)
        }

        let alertAction1 = UIAlertAction(title: "share".ZXLocaleString, style: UIAlertAction.Style.default) {[weak self] (alertAction) in
            guard let self = self else { return }
            self._share()
        }

        let alertAction2 = UIAlertAction(title: "copy".ZXLocaleString, style: UIAlertAction.Style.default) {[weak self] (alertAction) in
            guard let self = self else { return }
            let rightBarItem = UIBarButtonItem(title: "paste here".ZXLocaleString, style: .plain, target: self, action: #selector(self._copy))
            self.navigationItem.rightBarButtonItem = rightBarItem
        }

        let alertAction3 = UIAlertAction(title: "move".ZXLocaleString, style: UIAlertAction.Style.default) {[weak self] (alertAction) in
            guard let self = self else { return }
            let rightBarItem = UIBarButtonItem(title: "move here".ZXLocaleString, style: .plain, target: self, action: #selector(self._move))
            self.navigationItem.rightBarButtonItem = rightBarItem
        }
        
        let alertAction4 = UIAlertAction(title: "hash value".ZXLocaleString, style: UIAlertAction.Style.default) {[weak self] (alertAction) in
            guard let self = self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self._hash()
            }
        }
        
        let alertAction5 = UIAlertAction(title: "size".ZXLocaleString, style: UIAlertAction.Style.default) {[weak self] (alertAction) in
            guard let self = self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self._size()
            }
        }

        let alertAction6 = UIAlertAction(title: "delete".ZXLocaleString, style: UIAlertAction.Style.destructive) {[weak self] (alertAction) in
            guard let self = self else { return }
            self._delete()
        }
        
        
        
        let cancelAction = UIAlertAction(title: "cancel".ZXLocaleString, style: UIAlertAction.Style.cancel) { (alertAction) in

        }
        alertVC.addAction(alertAction1)
        alertVC.addAction(alertAction2)
        alertVC.addAction(alertAction3)
        if model.fileType != .folder {
            alertVC.addAction(alertAction4)
        }
        alertVC.addAction(alertAction5)
        alertVC.addAction(alertAction6)
        alertVC.addAction(cancelAction)
        self.present(alertVC, animated: true, completion: nil)
    }

    func _share() {
        let activityVC = UIActivityViewController(activityItems: [self.operateFileModel!.filepath], applicationActivities: nil)
        if UIDevice.current.model == "iPad" {
            activityVC.modalPresentationStyle = UIModalPresentationStyle.popover
            activityVC.popoverPresentationController?.sourceView = self.view
            activityVC.popoverPresentationController?.sourceRect = CGRect(x: 10, y: UIScreenHeight - 300, width: UIScreenWidth - 20, height: 300)
        }
        self.present(activityVC, animated: true, completion: nil)
    }

    @objc func _copy() {
        let rightBarItem = UIBarButtonItem(title: "close".ZXLocaleString, style: .plain, target: self, action: #selector(_rightBarItemClick))
        self.navigationItem.rightBarButtonItem = rightBarItem

        guard let operateFileModel = self.operateFileModel else { return }
        let manager = FileManager.default
        //同名
        let currentPath = self.currentDirectoryPath.appendingPathComponent(operateFileModel.name, isDirectory: false)
        do {
            try manager.copyItem(at: operateFileModel.filepath, to: currentPath)
        } catch {
            print(error)
        }
        self._loadData()
    }

    @objc func _move() {
        let rightBarItem = UIBarButtonItem(title: "close".ZXLocaleString, style: .plain, target: self, action: #selector(_rightBarItemClick))
        self.navigationItem.rightBarButtonItem = rightBarItem

        guard let operateFileModel = self.operateFileModel else { return }
        let manager = FileManager.default
        let currentPath = self.currentDirectoryPath.appendingPathComponent(operateFileModel.name, isDirectory: false)
        do {
            try manager.moveItem(at: operateFileModel.filepath, to: currentPath)
        } catch {
            print(error)
        }
        self._loadData()
    }

    func _delete() {
        guard let operateFileModel = self.operateFileModel else { return }
        let manager = FileManager.default
        do {
            try manager.removeItem(at: operateFileModel.filepath)
        } catch {
            print(error)
        }
        self._loadData()
    }
    
    func _hash() {
        guard let operateFileModel = self.operateFileModel else { return }
        var hashValue = ""
        do {
            let data = try Data(contentsOf: operateFileModel.filepath)

            hashValue = "MD5: \n" + data.zx.hashString(hashType: .md5) + "\n\n" + "SHA1: \n" + data.zx.hashString(hashType: .sha1) + "\n\n" + "SHA256: \n" + data.zx.hashString(hashType: .sha256) + "\n\n" + "SHA384: \n" + data.zx.hashString(hashType: .sha384) + "\n\n" + "SHA512: \n" + data.zx.hashString(hashType: .sha512)
        } catch  {
            print(error)
            hashValue = error.localizedDescription
        }
        
        let alertVC = UIAlertController(title: "Hash Value".ZXLocaleString, message: hashValue, preferredStyle: UIAlertController.Style.alert)
        let alertAction1 = UIAlertAction(title: "copy".ZXLocaleString, style: UIAlertAction.Style.default) { _ in
            UIPasteboard.general.string = hashValue
        }
        
        let cancelAction = UIAlertAction(title: "close".ZXLocaleString, style: UIAlertAction.Style.cancel) { _ in

        }
        alertVC.addAction(alertAction1)
        alertVC.addAction(cancelAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func _size() {
        guard let operateFileModel = self.operateFileModel else { return }
        HDHUD.show(icon: .loading, didAppear: {
            var size: Double = operateFileModel.size
            if size == 0 {
                if operateFileModel.fileType == .folder {
                    size = ZXKitUtil.shared.getFileDirectorySize(fileDirectoryPth: operateFileModel.filepath)
                    operateFileModel.size = size
                } else {
                    size = ZXKitUtil.shared.getFileSize(filePath: operateFileModel.filepath)
                    operateFileModel.size = size
                }
            }
            var sizeString =  "\(Int(size))B"
            if size > 1024 * 1024 {
                sizeString = "\(Int(size/1024/1024))MB"
            } else if size > 1024 {
                sizeString = "\(Int(size/1024))KB"
            }
            let alertVC = UIAlertController(title: "size".ZXLocaleString, message: sizeString, preferredStyle: UIAlertController.Style.alert)
            let cancelAction = UIAlertAction(title: "close".ZXLocaleString, style: UIAlertAction.Style.cancel) { _ in

            }
            alertVC.addAction(cancelAction)
            self.present(alertVC, animated: true, completion: nil)
            HDHUD.hide()
        })
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
        if model.fileType == .folder {
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

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.mTableViewList[indexPath.row]
        if model.fileType == .folder {
            extensionDirectoryPath = extensionDirectoryPath + "/" + model.name
            self._loadData()
        } else {
            let rightBarItem = UIBarButtonItem(title: "close".ZXLocaleString, style: .plain, target: self, action: #selector(_rightBarItemClick))
            self.navigationItem.rightBarButtonItem = rightBarItem
            self.operateFileModel = model
            //preview
            let previewVC = QLPreviewController()
            previewVC.delegate = self
            previewVC.dataSource = self
            self.navigationController?.pushViewController(previewVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        let model = self.mTableViewList[indexPath.row]
        self.operateFileModel = model
        self._showMore(model: model)
        return true
    }
    
    func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {

    }
}

extension ZXFileBrowserVC: QLPreviewControllerDelegate, QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return self.operateFileModel!.filepath as QLPreviewItem
    }
}
