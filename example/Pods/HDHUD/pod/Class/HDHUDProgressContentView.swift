//
//  HDHUDProgressContentView.swift
//  HDHUD
//
//  Created by Damon on 2020/10/15.
//

import UIKit
import ZXKitUtil
#if canImport(Kingfisher)
import Kingfisher
#endif

class HDHUDProgressContentView: HDHUDContentView {
    var progress: Float = 0 {
        willSet {
            self.mLabel.text = String(format: "%.2f%%", newValue * 100)
            self.mProgressView.progress = newValue
        }
    }

    init(direction: HDHUDContentDirection = .horizontal) {
        super.init()
        self.createUI(direction: direction)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: UI
    lazy var mImageView: UIImageView = {
        let tImageView = UIImageView()
        #if canImport(Kingfisher)
        if let url = HDHUD.loadingImageURL {
            tImageView.kf.setImage(with: url)
        } else {
            tImageView.image = HDHUD.loadingImage
        }
        #else
        tImageView.image = HDHUD.loadingImage
        #endif
        return tImageView
    }()

    lazy var mProgressView: CircularProgressView = {
        let tProgressView = CircularProgressView(frame: CGRect(x: 27.5, y: 15, width: 55, height: 55))
        tProgressView.trackLineWidth = 4
        tProgressView.trackTintColor = HDHUD.trackTintColor
        tProgressView.progressTintColor = HDHUD.progressTintColor
        tProgressView.roundedProgressLineCap = true
        return tProgressView
    }()
    
    lazy var mLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.text = "0%"
        tLabel.numberOfLines = 0
        tLabel.textAlignment = .center
        tLabel.textColor = HDHUD.textColor
        tLabel.font = HDHUD.textFont
        return tLabel
    }()
}

extension HDHUDProgressContentView {
    func createUI(direction: HDHUDContentDirection) {
        self.addSubview(mImageView)
        self.addSubview(mLabel)

        self.snp.makeConstraints { (make) in
            make.width.lessThanOrEqualTo(240)
        }

        self.addSubview(mProgressView)
        mProgressView.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(15)
            if direction == .horizontal {
                make.bottom.equalToSuperview().offset(-15)
            } else {
                make.right.equalToSuperview().offset(-15)
            }
            make.width.height.equalTo(55)
        }

        self.addSubview(mImageView)
        mImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(25)
            make.center.equalTo(mProgressView)
        }

        self.addSubview(mLabel)
        mLabel.snp.makeConstraints { (make) in
            if direction == .horizontal {
                make.left.equalTo(mProgressView.snp.right).offset(8)
                make.centerY.equalTo(mProgressView)
                make.right.equalToSuperview().offset(-15)
            } else {
                make.top.equalTo(mProgressView.snp.bottom).offset(8)
                make.centerX.equalToSuperview()
                make.bottom.equalToSuperview().offset(-15)
            }
        }
    }
}
