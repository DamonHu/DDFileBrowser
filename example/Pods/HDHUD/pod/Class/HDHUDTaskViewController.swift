//
//  HDHUDTaskViewController.swift
//  HDHUD
//
//  Created by Damon on 2025/10/10.
//

import UIKit

class HDHUDTaskViewController: UIViewController {
    private var xConstraint: NSLayoutConstraint?
    private var yConstraint: NSLayoutConstraint?
    private var currentDisplayPosition = HDHUDDisplayPosition.top
    private var contentOffset = HDHUD.contentOffset
    
    var isVisible: Bool {
        return !self.mStackView.subviews.isEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._createUI()
    }
    
    lazy var mStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
}

extension HDHUDTaskViewController {
    func showToast(contentView: UIView) {
        self.view.backgroundColor = HDHUD.backgroundColor
        //更新约束
        if (self.currentDisplayPosition != HDHUD.displayPosition || self.contentOffset != HDHUD.contentOffset) {
            self.contentOffset = HDHUD.contentOffset
            self.currentDisplayPosition = HDHUD.displayPosition
            //X
            self.xConstraint?.isActive = false
            self.xConstraint = mStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: self.contentOffset.x)
            self.xConstraint?.isActive = true
            //Y
            self.yConstraint?.isActive = false
            switch HDHUD.displayPosition {
            case .top:
                self.yConstraint = mStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: self.contentOffset.y)
            case .center:
                self.yConstraint = mStackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: self.contentOffset.y)
            case .bottom:
                self.yConstraint = mStackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: self.contentOffset.y)
            case .navigationBarMask:
                self.yConstraint = mStackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.contentOffset.y)
            case .tabBarMask:
                self.yConstraint = mStackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: self.contentOffset.y)
            }
            self.yConstraint?.isActive = true
            self.view.layoutIfNeeded()
        }
        //添加内容
        self.mStackView.addArrangedSubview(contentView)
        contentView.alpha = 0
        //刷新
        UIView.animate(withDuration: 0.3) {
            contentView.alpha = 1
        }
    }
    
    func hideToast(contentView: UIView, animation: Bool) {
        if animation {
            UIView.animate(withDuration: 0.3, animations: {
                contentView.alpha = 0
            }) { _ in
                contentView.removeFromSuperview()
                if self.mStackView.arrangedSubviews.isEmpty {
                    self.view.backgroundColor = .clear
                }
            }
        } else {
            contentView.alpha = 0
            contentView.removeFromSuperview()
            if self.mStackView.arrangedSubviews.isEmpty {
                self.view.backgroundColor = .clear
            }
        }
        
    }
}

extension HDHUDTaskViewController {
    func _createUI() {
        self.view.addSubview(mStackView)
        self.xConstraint = mStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: self.contentOffset.x)
        self.yConstraint = mStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: self.contentOffset.y)
        NSLayoutConstraint.activate([
            self.xConstraint!,
            self.yConstraint!
        ])
    }
}
