//
//  DesignableView.swift
//  Tagi_App
//
//  Created by MAC on 03/04/21.
//

import Foundation
import UIKit

class DesignableView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var _cornerSides: String? {
      didSet {
        cornerSides = CornerSides(rawValue: _cornerSides)
      }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var shadowColor: UIColor = .clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 0.0 {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0.0 {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize.zero {
        didSet {
            updateView()
        }
    }
    
    open var cornerSides: CornerSides  = .allSides {
      didSet {
        updateView()
      }
    }
    
    
    func updateView() {
        layer.borderWidth = borderWidth
        layer.cornerRadius = cornerRadius
        layer.borderColor = borderColor.cgColor
        
        layer.shadowColor = shadowColor.cgColor
        layer.shadowRadius = shadowRadius
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = shadowOffset
    }
    
    
    
    
    func configureCornerSide() {
        guard !cornerRadius.isNaN && cornerRadius > 0 else {
          return
        }
        
        if cornerSides == .allSides {
          layer.cornerRadius = cornerRadius
        } else {
          layer.cornerRadius = 0.0
          // if a layer mask is specified, remove it
          layer.mask?.removeFromSuperlayer()
          layer.mask = cornerSidesLayer(inRect: bounds)
        }
    }
    
    private func cornerSidesLayer(inRect bounds: CGRect) -> CAShapeLayer {
      let cornerSideLayer = CAShapeLayer()
      cornerSideLayer.name = "cornerSideLayer"
      cornerSideLayer.frame = CGRect(origin: .zero, size: bounds.size)

      let cornerRadii = CGSize(width: cornerRadius, height: cornerRadius)
      let roundingCorners: UIRectCorner = cornerSides.rectCorner
      cornerSideLayer.path = UIBezierPath(roundedRect: bounds,
                                          byRoundingCorners: roundingCorners,
                                          cornerRadii: cornerRadii).cgPath
      return cornerSideLayer
    }
    
}
