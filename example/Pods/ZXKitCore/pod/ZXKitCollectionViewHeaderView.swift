//
//  ZXKitCollectionViewHeaderView.swift
//  ZXKit
//
//  Created by Damon on 2021/4/23.
//

import UIKit

class ZXKitCollectionViewHeaderView: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func createUI() {
//        self.contentView.backgroundColor = UIColor(displayP3Red: 112.0/255.0, green: 161.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        self.contentView.backgroundColor = UIColor.zx.color(hexValue: 0x5dae8b)
        self.contentView.addSubview(mTitleLabel)
        mTitleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview()
        }
    }

    func updateUI(title: String) {
        mTitleLabel.text = title
    }

    //MARK: UI
    lazy var mTitleLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.numberOfLines = 2
        tLabel.textAlignment = .left
        tLabel.font = .systemFont(ofSize: 18, weight: .medium)
        tLabel.textColor = UIColor.zx.color(hexValue: 0xffffff)
        return tLabel
    }()
}
