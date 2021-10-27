//
//  ZXKitWindow.swift
//  ZXKit
//
//  Created by Damon on 2021/4/23.
//

import UIKit

class ZXKitWindow: UIWindow {
    private var inputComplete: ((String)->Void)?

    @available(iOS 13.0, *)
    override init(windowScene: UIWindowScene) {
        super.init(windowScene: windowScene)
        self._initVC()
        self._createUI()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self._initVC()
        self._createUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: UI
    lazy var mCollectionView: UICollectionView = {
        let tCollectionViewLayout = UICollectionViewFlowLayout()
        tCollectionViewLayout.itemSize = CGSize(width: UIScreen.main.bounds.width / 4, height: UIScreen.main.bounds.width / 4)
        tCollectionViewLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
        tCollectionViewLayout.minimumLineSpacing = 0
        tCollectionViewLayout.minimumInteritemSpacing = 0
        tCollectionViewLayout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 40)
        let tCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: tCollectionViewLayout)
        tCollectionView.contentInsetAdjustmentBehavior = .never
        tCollectionView.backgroundColor = UIColor.clear
        tCollectionView.dataSource = self
        tCollectionView.delegate = self
        tCollectionView.isPagingEnabled = false
        tCollectionView.showsHorizontalScrollIndicator = false
        tCollectionView.register(ZXKitPluginCollectionViewCell.self, forCellWithReuseIdentifier: "ZXKitPluginCollectionViewCell")
        tCollectionView.register(ZXKitCollectionViewHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ZXKitCollectionViewHeaderView")
        return tCollectionView
    }()

    lazy var mInputBGView: UIView = {
        let tView = UIView()
        tView.isHidden = true
        tView.backgroundColor = UIColor.zx.color(hexValue: 0x000000, alpha: 0.7)
        let tap = UITapGestureRecognizer(target: self, action: #selector(_endTextField))
        tView.addGestureRecognizer(tap)
        return tView
    }()

    lazy var mTextField: UITextField = {
        let tTextField = UITextField()
        tTextField.leftViewMode = .always
        tTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 10))
        tTextField.backgroundColor = UIColor.zx.color(hexValue: 0xffffff, alpha: 0.8)
        tTextField.font = .systemFont(ofSize: 14)
        tTextField.placeholder = "input text".ZXLocaleString
        tTextField.clearButtonMode = .always
        tTextField.layer.borderWidth = 1.0
        tTextField.layer.borderColor = UIColor.zx.color(hexValue: 0xcccccc).cgColor
        tTextField.delegate = self
        tTextField.textColor = UIColor.zx.color(hexValue: 0x333333)
        return tTextField
    }()

    lazy var mButton: UIButton = {
        let tButton = UIButton(type: .custom)
        tButton.addTarget(self, action: #selector(_endTextField), for: .touchUpInside)
        tButton.setTitle("confirm".ZXLocaleString, for: .normal)
        tButton.setTitleColor(UIColor.zx.color(hexValue: 0xffffff), for: .normal)
        tButton.backgroundColor = UIColor.zx.color(hexValue: 0x5dae8b)
        tButton.layer.borderWidth = 1.0
        tButton.layer.borderColor = UIColor.zx.color(hexValue: 0xcccccc).cgColor
        return tButton
    }()
}

extension ZXKitWindow {
    func reloadData() {
        self.mCollectionView.reloadData()
    }

    func showInput(complete: ((String)->Void)?) {
        self.inputComplete = complete
        self.mInputBGView.isHidden = false
        self.mTextField.becomeFirstResponder()
    }

    func hideInput() {
        self.mTextField.endEditing(true)
        self.mInputBGView.isHidden = true
        self.mTextField.placeholder = "input text".ZXLocaleString
        self.mTextField.text = ""
    }
}

extension ZXKitWindow: UICollectionViewDelegate,UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return ZXKit.pluginList.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ZXKit.pluginList[section].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let plugin = ZXKit.pluginList[indexPath.section][indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ZXKitPluginCollectionViewCell", for: indexPath) as! ZXKitPluginCollectionViewCell
        cell.updateUI(plugin: plugin)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let title = ["UI".ZXLocaleString, "Data".ZXLocaleString, "Other".ZXLocaleString]
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ZXKitCollectionViewHeaderView", for: indexPath) as! ZXKitCollectionViewHeaderView
        cell.updateUI(title: title[indexPath.section])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let plugin = ZXKit.pluginList[indexPath.section][indexPath.item]
        if plugin.isRunning {
            plugin.stop()
            self.reloadData()
        } else {
            plugin.start()
            self.reloadData()
        }

    }
}

extension ZXKitWindow: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let complete = self.inputComplete {
            complete(textField.text ?? "")
            self.reloadData()
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}

private extension ZXKitWindow {

    func _initVC() {
        self.backgroundColor = UIColor.zx.color(hexValue: 0xfcecdd, alpha: 0.93)
        let rootViewController = UIViewController()

        let navigation = UINavigationController(rootViewController: rootViewController)
        navigation.navigationBar.barTintColor = UIColor.white
        //set title
        let view = UIView()
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "ZXKIT", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 18, weight: .medium), NSAttributedString.Key.foregroundColor:UIColor.black])
        view.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        rootViewController.navigationItem.titleView = view
        //navigationBar
        let leftBarItem = UIBarButtonItem(title: "close".ZXLocaleString, style: .plain, target: self, action: #selector(_leftBarItemClick))
        rootViewController.navigationItem.leftBarButtonItem = leftBarItem
        let rightBarItem = UIBarButtonItem(title: "hide".ZXLocaleString, style: .plain, target: self, action: #selector(_rightBarItemClick))
        rootViewController.navigationItem.rightBarButtonItem = rightBarItem
        //
        self.rootViewController = navigation
        self.windowLevel =  UIWindow.Level.alert
        self.isUserInteractionEnabled = true
    }

    @objc func _leftBarItemClick() {
        ZXKit.close()
    }

    @objc func _rightBarItemClick() {
        ZXKit.hide()
    }

    @objc func _endTextField() {
        self.hideInput()
    }

    func _createUI() {
        guard let navigationController = self.rootViewController as? UINavigationController, let rootViewController = navigationController.topViewController else {
            return
        }

        rootViewController.view.addSubview(mCollectionView)
        mCollectionView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(rootViewController.view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(rootViewController.view.safeAreaLayoutGuide.snp.bottom)
        }

        rootViewController.view.addSubview(mInputBGView)
        mInputBGView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(rootViewController.view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(rootViewController.view.safeAreaLayoutGuide.snp.bottom)
        }

        mInputBGView.addSubview(mTextField)
        mTextField.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width*2.0/3.0)
            $0.top.equalTo(rootViewController.view.safeAreaLayoutGuide.snp.top)
            $0.height.equalTo(38)
        }

        mInputBGView.addSubview(mButton)
        mButton.snp.makeConstraints {
            $0.left.equalTo(mTextField.snp.right)
            $0.right.equalToSuperview()
            $0.top.equalTo(mTextField)
            $0.height.equalTo(38)
        }
    }
}
