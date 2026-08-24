//
//  ViewController.swift
//  CALrn
//
//  Created by SJ Basak on 24/08/26.
//

import UIKit


final class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpVw()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self.view)
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        view.layer.sublayers?.first?.position = location
        CATransaction.commit()
    }
}

/// UI
private extension ViewController {
    func setUpVw() {
        view.backgroundColor = .white
        
        setUpLayer()
    }
    
    func setUpLayer() {
        let egLayer = CALayer()
        egLayer.frame = CGRect(x: 100, y: 200, width: 100, height: 100)
        egLayer.backgroundColor = UIColor.systemBlue.cgColor
        egLayer.cornerRadius = 10
        
        self.view.layer.addSublayer(egLayer)
        applyGroupAnimation(to: egLayer)
    }
    func addDot(to point: CGPoint, tint: CGColor? = nil) {
        let egLayer = CALayer()
        egLayer.frame = CGRect(x: point.x, y: point.y, width: 10, height: 10)
        egLayer.backgroundColor = tint ?? UIColor.systemBlue.cgColor
        egLayer.cornerRadius = 5
        
        self.view.layer.addSublayer(egLayer)
    }
    
    func applyBasicAnimation(to layer: CALayer) {
        let positioningAnimation = CABasicAnimation(keyPath: "position")
        positioningAnimation.fromValue = CGPoint(x: 100, y: 200)
        positioningAnimation.toValue = CGPoint(x: 250, y: 400)
        positioningAnimation.duration = 1.0
        positioningAnimation.timingFunction = .init(name: .easeInEaseOut)
        positioningAnimation.autoreverses = true
        positioningAnimation.repeatCount = .infinity
        
        layer.add(positioningAnimation, forKey: "positioningAnimation")
    }
    
    func applyKFAnimation(to layer: CALayer) {
        let path = UIBezierPath()
        
        let source         = CGPoint(x: 100, y: 200)
        let controlPoint1  = CGPoint(x: 350, y: 200)
        
        let destination    = CGPoint(x: 350, y: 500)
        let controlPoint2  = CGPoint(x: 100, y: 500)
        
        path.move(to: source)
        path
            .addCurve(
                to: destination,
                controlPoint1: controlPoint1,
                controlPoint2: controlPoint2
            )
        
        self.addDot(to: source, tint: UIColor.red.cgColor)
        self.addDot(to: destination, tint: UIColor.red.cgColor)
        self.addDot(to: controlPoint1)
        self.addDot(to: controlPoint2)
        
        let pathAnimation = CAKeyframeAnimation(keyPath: "position")
        pathAnimation.path = path.cgPath
        pathAnimation.duration = 4.0
        pathAnimation.timingFunctions = [CAMediaTimingFunction(name: .easeInEaseOut)]
        pathAnimation.rotationMode = .rotateAuto
        pathAnimation.repeatCount = .infinity
        pathAnimation.autoreverses = true
        
        layer.add(pathAnimation, forKey: "pathAnimation")
    }
    
    func applyGroupAnimation(to layer: CALayer) {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 0.5
        scaleAnimation.toValue = 2.0
        
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0
        rotateAnimation.toValue = CGFloat.pi * 2
        
        let group = CAAnimationGroup()
        group.animations = [scaleAnimation, rotateAnimation]
        group.duration = 2.5
        group.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        group.autoreverses = true
        group.repeatCount = .infinity
        
        layer.add(group, forKey: "groupAnimation")
    }
}
