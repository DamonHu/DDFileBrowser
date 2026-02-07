//
//  HDHUDLoadingContentView.swift
//  HDHUD
//
//  Created by Damon on 2026/2/7.
//

import UIKit

class HDHUDLoadingContentView: HDHUDContentView {

    init(content: String? = nil, direction: HDHUDContentDirection = .horizontal) {
        super.init()
        self.createUI(content: content, direction: direction)
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

extension HDHUDLoadingContentView {
    func createUI(content: String?, direction: HDHUDContentDirection) {
        let imageSize = HDHUD.loadingImageSize
        mImageView.image = HDHUD.loadingImage
        mLabel.text = content

        self.addSubview(mImageView)
        self.addSubview(mLabel)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(lessThanOrEqualToConstant: 240).isActive = true
        self.widthAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
        self.heightAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
        
        //判断单一存在的情况
        if content == nil || content!.isEmpty {
            mImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            mImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            mImageView.widthAnchor.constraint(equalToConstant: imageSize.width * 1.6).isActive = true
            mImageView.heightAnchor.constraint(equalToConstant: imageSize.height * 1.6).isActive = true
            return
        }
        //图文都有
        mImageView.widthAnchor.constraint(equalToConstant: imageSize.width * 1.6).isActive = true
        mImageView.heightAnchor.constraint(equalToConstant: imageSize.width * 1.6).isActive = true
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
