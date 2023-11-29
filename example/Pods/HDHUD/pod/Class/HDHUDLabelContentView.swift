//
//  HDHUDLabelContentView.swift
//  HDHUD
//
//  Created by Damon on 2020/10/15.
//

import UIKit
#if canImport(Kingfisher)
import Kingfisher
#endif

class HDHUDLabelContentView: HDHUDContentView {

    init(content: String? = nil, icon: HDHUDIconType, direction: HDHUDContentDirection = .horizontal) {
        super.init()
        self.createUI(content: content, icon: icon, direction: direction)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: UI
    lazy var mImageView: UIImageView = {
        let tImageView = UIImageView()
        return tImageView
    }()
    lazy var mLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.numberOfLines = 0
        tLabel.textAlignment = .center
        tLabel.textColor = HDHUD.textColor
        tLabel.font = HDHUD.textFont
        return tLabel
    }()
}

extension HDHUDLabelContentView {
    func createUI(content: String?, icon: HDHUDIconType, direction: HDHUDContentDirection) {
        var imageSize = CGSize.zero
        switch icon {
            case .none:
                mImageView.image = nil
            case .warn:
                mImageView.image = HDHUD.warnImage
                imageSize = HDHUD.warnImageSize
            case .error:
                mImageView.image = HDHUD.errorImage
                imageSize = HDHUD.errorImageSize
            case .success:
                mImageView.image = HDHUD.successImage
                imageSize = HDHUD.successImageSize
            case .loading:
                #if canImport(Kingfisher)
                if let url = HDHUD.loadingImageURL {
                    mImageView.kf.setImage(with: url)
                } else {
                    mImageView.image = HDHUD.loadingImage
                }
                #else
                mImageView.image = HDHUD.loadingImage
                #endif
                imageSize = HDHUD.loadingImageSize
        }
        mLabel.text = content

        self.addSubview(mImageView)
        self.addSubview(mLabel)

        self.snp.makeConstraints { (make) in
            make.width.lessThanOrEqualTo(240)
        }

        //判断单一存在的情况
        guard let content = content, !content.isEmpty else {
            if HDHUD.displayPosition == .navigationBarMask || HDHUD.displayPosition == .tabBarMask {
                self.snp.makeConstraints { (make) in
                    make.width.equalTo(imageSize.width)
                    make.height.equalTo(imageSize.height + 20)
                }
            } else {
                self.snp.makeConstraints { (make) in
                    make.width.height.equalTo(100)
                }
            }
            mImageView.snp.makeConstraints { (make) in
                make.center.equalToSuperview()
                make.size.equalTo(imageSize)
            }
            return
        }
        guard icon != .none else {
            mLabel.snp.makeConstraints { (make) in
                make.edges.equalToSuperview().inset(15)
            }
            return
        }

        mImageView.snp.makeConstraints { (make) in
            make.size.equalTo(imageSize)
            if direction == .horizontal {
                make.left.equalToSuperview().offset(15)
                make.centerY.equalToSuperview()
            } else {
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().offset(15)
            }
        }

        mLabel.snp.makeConstraints { (make) in
            if direction == .horizontal {
                make.left.equalTo(mImageView.snp.right).offset(8)
                make.top.bottom.right.equalToSuperview().inset(15)
            } else {
                make.top.equalTo(mImageView.snp.bottom).offset(8)
                make.left.bottom.right.equalToSuperview().inset(15)
            }
        }
    }
}
