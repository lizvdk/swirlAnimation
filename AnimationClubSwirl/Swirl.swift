//
//  Swirl.swift
//  AnimationClubSwirl
//
//  Created by Liz Vanderkloot on 5/6/16.
//  Copyright © 2016 lizvdk. All rights reserved.
//

import UIKit

open class Swirl: UIView  {

    let svgConverter = SvgToBezierConverter()
    let svgPathData = "M67.3,243.1c24.6-24.6,34.8,0,77,0c117.4,0,127.5-111.9,58.7-111.9c-67.9,0-58.7,111.9,58.7,111.9c37.8,0,56.5-20.5,77,0"

    // MARK - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    fileprivate let circleLayer = CAShapeLayer()
    fileprivate let twistLayer = CAShapeLayer()
    fileprivate var shapeLayers = [CAShapeLayer]()

    fileprivate func commonInit() {
        shapeLayers = [circleLayer, twistLayer]

        layer.addSublayer(circleLayer)
        layer.addSublayer(twistLayer)

        for shapeLayer in shapeLayers {
            shapeLayer.lineWidth = 10.0
            shapeLayer.strokeColor = UIColor.white.cgColor
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.lineCap = kCALineCapRound
            shapeLayer.strokeEnd = 0.0
        }
    }

    override open func layoutSubviews() {
        super.layoutSubviews()

        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius: CGFloat = 90.0
        let startAngle = CGFloat(-M_PI_2)
        let endAngle = startAngle + CGFloat(M_PI * 2)
        let path = UIBezierPath(arcCenter: CGPoint.zero, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        circleLayer.path = path.cgPath
        circleLayer.position = center

        twistLayer.path = svgConverter.bezierPathFromSVGPath(svgPathData, orgSize: CGRect(x: 0, y: 0, width: 400, height: 400), newSize: bounds).cgPath
    }

    func animateSwirl() {
        let delayBetweenFillAndClearAnimations = 0.33
        let repeatAnimationDelay = 0.5

        let fillAnimation = CABasicAnimation(keyPath: "strokeEnd")
        let clearAnimation = CABasicAnimation(keyPath: "strokeStart")

        for animation in [fillAnimation, clearAnimation] {
            animation.duration = 0.66
            animation.fromValue = 0.0
            animation.toValue = 1.0
            animation.fillMode = kCAFillModeForwards
        }

        fillAnimation.beginTime = 0.0
        clearAnimation.beginTime = fillAnimation.beginTime + fillAnimation.duration + delayBetweenFillAndClearAnimations

        let group = CAAnimationGroup()
        group.animations = [fillAnimation, clearAnimation]
        group.duration = fillAnimation.duration + clearAnimation.duration + delayBetweenFillAndClearAnimations + repeatAnimationDelay
        group.repeatCount = Float.infinity

        twistLayer.add(group, forKey: nil)
        circleLayer.add(group, forKey: nil)
    }

    func stopAnimatingSwirl() {
        for shapeLayer in shapeLayers {
            shapeLayer.removeAllAnimations()
        }
    }
}
