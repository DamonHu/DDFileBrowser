//
//  HDHUDProgressContentView.swift
//  HDHUD
//
//  Created by Damon on 2020/10/15.
//

import UIKit

class HDHUDProgressContentView: HDHUDContentView {
    var progress: Float = 0 {
        willSet {
            self.mLabel.text = String(format: "%.1f%%", newValue * 100)
            self.mProgressView.setProgress(newValue, animated: true)
        }
    }
    var text: String? {
        willSet {
            self.mTextLabel.text = newValue
            self.bottomConstraint?.isActive = false
            self.bottomConstraint = mTextLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: (newValue != nil && newValue!.count > 0) ? -15 : -2)
            self.bottomConstraint?.isActive = true
        }
    }
    private var bottomConstraint: NSLayoutConstraint?

    init(text: String?, direction: HDHUDContentDirection = .horizontal) {
        super.init()
        self.createUI(direction: direction)
        defer {
            self.text = text
        }
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: UI
    lazy var mImageView: UIImageView = {
        let tImageView = UIImageView()
        tImageView.translatesAutoresizingMaskIntoConstraints = false
        tImageView.image = HDHUD.loadingImage
        return tImageView
    }()

    lazy var mProgressView: UIProgressView = {
        let tProgressView = UIProgressView()
        tProgressView.layer.masksToBounds = true
        tProgressView.layer.cornerRadius = 6
        tProgressView.translatesAutoresizingMaskIntoConstraints = false
        tProgressView.trackTintColor = HDHUD.trackTintColor
        tProgressView.progressTintColor = HDHUD.progressTintColor
        return tProgressView
    }()
    
    lazy var mLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.translatesAutoresizingMaskIntoConstraints = false
        tLabel.text = "0%"
        tLabel.numberOfLines = 0
        tLabel.textAlignment = .center
        tLabel.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.00)
        tLabel.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        return tLabel
    }()
    
    lazy var mTextLabel: UILabel = {
        let tLabel = UILabel()
        tLabel.translatesAutoresizingMaskIntoConstraints = false
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
        self.addSubview(mProgressView)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        if direction == .horizontal {
            mImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
            mImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
            mImageView.widthAnchor.constraint(equalToConstant: HDHUD.loadingImageSize.width).isActive = true
            mImageView.heightAnchor.constraint(equalToConstant: HDHUD.loadingImageSize.height).isActive = true
            
            mProgressView.centerYAnchor.constraint(equalTo: self.mImageView.centerYAnchor).isActive = true
            mProgressView.leftAnchor.constraint(equalTo: mImageView.rightAnchor, constant: 15).isActive = true
            mProgressView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
            mProgressView.widthAnchor.constraint(equalToConstant: 140).isActive = true
            mProgressView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        } else {
            mImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
            mImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            mImageView.widthAnchor.constraint(equalToConstant: HDHUD.loadingImageSize.width).isActive = true
            mImageView.heightAnchor.constraint(equalToConstant: HDHUD.loadingImageSize.height).isActive = true
            
            mProgressView.topAnchor.constraint(equalTo: mImageView.bottomAnchor, constant: 15).isActive = true
            mProgressView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
            mProgressView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
            mProgressView.widthAnchor.constraint(equalToConstant: 160).isActive = true
            mProgressView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        }
        
        mProgressView.addSubview(mLabel)
        mLabel.centerYAnchor.constraint(equalTo: mProgressView.centerYAnchor).isActive = true
        mLabel.rightAnchor.constraint(equalTo: mProgressView.rightAnchor, constant: -5).isActive = true
        
        //文案描述
        self.addSubview(mTextLabel)
        mTextLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        mTextLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
        mTextLabel.topAnchor.constraint(equalTo: mProgressView.bottomAnchor, constant: 13).isActive = true
        self.bottomConstraint = mTextLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2)
        self.bottomConstraint?.isActive = true
    }
}
