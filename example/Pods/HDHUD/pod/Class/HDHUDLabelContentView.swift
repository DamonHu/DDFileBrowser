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
        tImageView.translatesAutoresizingMaskIntoConstraints = false
        return tImageView
    }()
    
    lazy var mLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.translatesAutoresizingMaskIntoConstraints = false
        tLabel.numberOfLines = 0
        tLabel.textAlignment = .center
        tLabel.textColor = HDHUD.textColor
        tLabel.font = HDHUD.textFont
        return tLabel
    }()
}

extension HDHUDLabelContentView {
    func createUI(content: String?, icon: HDHUDIconType, direction: HDHUDContentDirection) {
        if (content == nil || content!.isEmpty) && icon == .none {
            return
        }
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
                mImageView.image = HDHUD.loadingImage
                imageSize = HDHUD.loadingImageSize
        }
        mLabel.text = content

        self.addSubview(mImageView)
        self.addSubview(mLabel)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(lessThanOrEqualToConstant: 240).isActive = true
        
        //判断单一存在的情况
        if content == nil || content!.isEmpty {
            if HDHUD.displayPosition == .navigationBarMask || HDHUD.displayPosition == .tabBarMask {
                self.widthAnchor.constraint(equalToConstant: imageSize.width).isActive = true
                self.heightAnchor.constraint(equalToConstant: imageSize.height + 20).isActive = true
            } else {
                self.widthAnchor.constraint(equalToConstant: 100).isActive = true
                self.heightAnchor.constraint(equalToConstant: 100).isActive = true
            }
            mImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            mImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            mImageView.widthAnchor.constraint(equalToConstant: imageSize.width * 1.6).isActive = true
            mImageView.heightAnchor.constraint(equalToConstant: imageSize.height * 1.6).isActive = true
            return
        }
        if icon == .none {
            mLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
            mLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
            mLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
            mLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15).isActive = true
            return
        }
        //图文都有
        mImageView.widthAnchor.constraint(equalToConstant: imageSize.width).isActive = true
        mImageView.heightAnchor.constraint(equalToConstant: imageSize.height).isActive = true
        if direction == .horizontal {
            mImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
            mImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        } else {
            mImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            mImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
        }

        //label
        if direction == .horizontal {
            mLabel.leftAnchor.constraint(equalTo: mImageView.rightAnchor, constant: 8).isActive = true
            mLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
            mLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
            mLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15).isActive = true
        } else {
            mLabel.topAnchor.constraint(equalTo: mImageView.bottomAnchor, constant: 8).isActive = true
            mLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
            mLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
            mLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15).isActive = true
        }
    }
}
