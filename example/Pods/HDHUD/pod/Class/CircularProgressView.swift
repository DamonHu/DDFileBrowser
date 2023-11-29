//
//  CircularProgressView.swift
//  CircularProgressView
//
//  Created by Chris Amanse on 2/10/18.
//  Copyright © 2018 Joe Christopher Paul Amanse. All rights reserved.
//

import UIKit

@IBDesignable
open class CircularProgressView: UIView {
    private var _progress: Float = 0
    @IBInspectable
    open var progress: Float {
        get {
            return _progress
        }
        set {
            _progress = min(max(0, newValue), 1)
            layoutProgressLayer()
        }
    }

    @IBInspectable
    open var trackLineWidth: CGFloat = 1 {
        didSet {
            layoutTrackLayer()
            layoutProgressLayer()
        }
    }

    @IBInspectable
    open var trackTintColor: UIColor = .white {
        didSet {
            colorTrackLayer()
        }
    }

    private var _customProgressTintColor: UIColor?
    @IBInspectable
    open var progressTintColor: UIColor? {
        get {
            return _customProgressTintColor ?? tintColor
        }
        set {
            _customProgressTintColor = newValue
            colorProgressLayer()
        }
    }

    @IBInspectable
    open var roundedProgressLineCap: Bool = false {
        didSet {
            layoutProgressLayer()
        }
    }

    private var centerSquareGuideBounds: CGRect {
        let squareSideLength = min(layer.bounds.width, layer.bounds.height)
        return CGRect(origin: .zero, size: CGSize(width: squareSideLength, height: squareSideLength))
    }
    private var centerSquareGuideFrame: CGRect {
        let squareOriginOffset = abs(layer.bounds.width - layer.bounds.height) / 2
        let squareOriginOffsetX = layer.bounds.width < layer.bounds.height ? 0 : squareOriginOffset
        let squareOriginOffsetY = layer.bounds.width < layer.bounds.height ? squareOriginOffset : 0
        return centerSquareGuideBounds.offsetBy(dx: squareOriginOffsetX, dy: squareOriginOffsetY)
    }
    private let trackLayer = CAShapeLayer()
    private var trackLayerPath: UIBezierPath {
        let trackRectInset = trackLineWidth / 2
        let trackRectWithInset = centerSquareGuideBounds.insetBy(dx: trackRectInset, dy: trackRectInset)
        return UIBezierPath(ovalIn: trackRectWithInset)
    }
    private let progressLayer = CAShapeLayer()
    private var progressLayerPath: UIBezierPath {
        let path = UIBezierPath()
        let trackRectInset = trackLineWidth / 2
        let trackRectWithInset = centerSquareGuideBounds.insetBy(dx: trackRectInset, dy: trackRectInset)
        let radius = trackRectWithInset.width / 2
        let arcCenter = CGPoint(x: trackRectWithInset.midX, y: trackRectWithInset.midY)
        let circleTopPoint = CGPoint(x: arcCenter.x, y: arcCenter.y - radius)
        path.move(to: circleTopPoint)
        path.addArc(withCenter: arcCenter, radius: radius, startAngle: -.pi / 2, endAngle: 2 * .pi - (.pi / 2), clockwise: true)
        return path
    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        setupCustomLayers()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupCustomLayers()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        layoutCustomSublayers()
    }

    private func setupCustomLayers() {
        layoutCustomSublayers()
        colorCustomSublayers()
        layer.addSublayer(trackLayer)
        layer.insertSublayer(progressLayer, above: trackLayer)
    }

    private func layoutCustomSublayers() {
        layoutTrackLayer()
        layoutProgressLayer()
    }

    private func layoutTrackLayer() {
        trackLayer.frame = centerSquareGuideFrame
        trackLayer.lineWidth = trackLineWidth
        trackLayer.path = trackLayerPath.cgPath
    }
    private func layoutProgressLayer() {
        progressLayer.frame = centerSquareGuideFrame
        progressLayer.lineWidth = trackLineWidth
        progressLayer.lineCap = roundedProgressLineCap ? CAShapeLayerLineCap.round : CAShapeLayerLineCap.butt
        progressLayer.path = progressLayerPath.cgPath
        progressLayer.strokeEnd = CGFloat(progress)
    }

    private func colorCustomSublayers() {
        colorTrackLayer()
        colorProgressLayer()
    }

    private func colorTrackLayer() {
        trackLayer.strokeColor = trackTintColor.cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
    }

    private func colorProgressLayer() {
        progressLayer.strokeColor = progressTintColor?.cgColor
        progressLayer.fillColor = UIColor.clear.cgColor
    }
}
