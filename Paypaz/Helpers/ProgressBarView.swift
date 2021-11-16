//
//  ProgressBarView.swift
//  progressBar
//
//  Created by ashika shanthi on 1/4/18.
//  Copyright © 2018 ashika shanthi. All rights reserved.
//

import UIKit
class ProgressBarView: UIView {
    
    var bgPath: UIBezierPath!
    var shapeLayer: CAShapeLayer!
    var progressLayer: CAShapeLayer!
    var progress: Float = 0 {
        willSet(newValue) {
            progressLayer.strokeEnd = CGFloat(newValue)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        bgPath = UIBezierPath()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        bgPath = UIBezierPath()
    }
    func simpleShape(color : UIColor,backGround:UIColor = UIColor.yellow) {//UIColor.appYellow
        bgPath = UIBezierPath()
        createCirclePath()
        shapeLayer = CAShapeLayer()
        shapeLayer.path = bgPath.cgPath
        shapeLayer.lineWidth = 8
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = backGround.cgColor
        shapeLayer.shadowRadius = 2
        shapeLayer.shadowOpacity = 1
        shapeLayer.shadowOffset = CGSize( width: 2, height: 2)
        shapeLayer.shadowColor = UIColor(red: 223/255, green: 228/255, blue: 238/255, alpha: 1.0).cgColor
        
        progressLayer = CAShapeLayer()
        progressLayer.path = bgPath.cgPath
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 8
        progressLayer.fillColor = nil
        progressLayer.strokeColor = color.cgColor
        progressLayer.strokeEnd = 0.0
        self.layer.addSublayer(shapeLayer)
        self.layer.addSublayer(progressLayer)
    }
    func simpleHalfShape(strokeColor:UIColor = UIColor.yellow,shadowColor:UIColor = UIColor(red: 0.8196078431, green: 0.8039215686, blue: 0.7803921569, alpha: 1)) {
        createHalfCirclePath()
        shapeLayer = CAShapeLayer()
        shapeLayer.path = bgPath.cgPath
        shapeLayer.lineWidth = 8
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineCap = .round
        shapeLayer.shadowRadius = 2
        shapeLayer.shadowOpacity = 1
        shapeLayer.shadowOffset = CGSize( width: 4, height: 4)
        shapeLayer.shadowColor = shadowColor.cgColor
        
        progressLayer = CAShapeLayer()
        progressLayer.path = bgPath.cgPath
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 4
        progressLayer.fillColor = nil
        progressLayer.strokeColor = UIColor.blue.cgColor//UIColor.appBlue.cgColor
        progressLayer.strokeEnd = 0.0
        
        self.layer.addSublayer(shapeLayer)
        self.layer.addSublayer(progressLayer)
    }
    func simpleHalfShapeBorder(strokeColor:UIColor = UIColor.yellow,shadowColor:UIColor = .gray) {
        createHalfCirclePath()
        shapeLayer = CAShapeLayer()
        shapeLayer.path = bgPath.cgPath
        shapeLayer.lineWidth = 1
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineCap = .round
        shapeLayer.shadowRadius = 2
        shapeLayer.shadowOpacity = 1
        shapeLayer.shadowOffset = CGSize( width: 4, height: 4)
        shapeLayer.shadowColor = shadowColor.cgColor
        
        progressLayer = CAShapeLayer()
        progressLayer.path = bgPath.cgPath
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 1
        progressLayer.fillColor = nil
        progressLayer.strokeColor = UIColor.gray.cgColor//UIColor.appGray.cgColor
        progressLayer.strokeEnd = 0.0
        
        self.layer.addSublayer(shapeLayer)
        self.layer.addSublayer(progressLayer)
    }
    func simplePerfectHalfShape(strokeColor:UIColor = UIColor.yellow,shadowColor:UIColor = UIColor(red: 0.8196078431, green: 0.8039215686, blue: 0.7803921569, alpha: 1),lineWidth : CGFloat = 8,progressStrokeColor:UIColor = UIColor.blue) {//.appBlue
        createPrefectHalfCirclePath()
        shapeLayer = CAShapeLayer()
        shapeLayer.path = bgPath.cgPath
        shapeLayer.lineWidth = lineWidth
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineCap = .round
        shapeLayer.shadowRadius = 2
        shapeLayer.shadowOpacity = 1
        shapeLayer.shadowOffset = CGSize( width: 4, height: 4)
        shapeLayer.shadowColor = shadowColor.cgColor
        
        progressLayer = CAShapeLayer()
        progressLayer.path = bgPath.cgPath
        progressLayer.lineCap = .round
        progressLayer.lineWidth = lineWidth
        progressLayer.fillColor = nil
        progressLayer.strokeColor = progressStrokeColor.cgColor
        progressLayer.strokeEnd = 0.0
        
        self.layer.addSublayer(shapeLayer)
        self.layer.addSublayer(progressLayer)
    }
    private func createCirclePath() {
        let x = self.frame.width/2
        let y = self.frame.height/2
        let center = CGPoint(x: x, y: y)
        bgPath.addArc(withCenter: center, radius: x, startAngle: CGFloat(4.71), endAngle: CGFloat(4.70), clockwise: true)
        bgPath.close()
    }
    private func createHalfCirclePath() {
        let x = self.frame.width/2
        let y = self.frame.height/2
        let center = CGPoint(x: x, y: y+20)
        bgPath.addArc(withCenter: center, radius: y+10, startAngle: CGFloat(2.4), endAngle: CGFloat(7.05), clockwise: true)
    }
    private func createPrefectHalfCirclePath() {
        let x = self.frame.width/2
        let y = self.frame.height/2
        let center = CGPoint(x: x, y: y+20)
        bgPath.addArc(withCenter: center, radius: y, startAngle: CGFloat(3.0), endAngle: CGFloat(6.5), clockwise: true)
    }
}
