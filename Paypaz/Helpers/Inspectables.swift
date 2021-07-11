//
//  Inspectables.swift
//  Paypaz
//
//  Created by iOSDeveloper on 08/04/21.
//  Copyright © 2021 iOSDeveloper. All rights reserved.
//

import Foundation
import UIKit
import IQKeyboardManagerSwift

//MARK:- ---- Button -----
@IBDesignable
class RoundButton:UIButton {
    
   @IBInspectable var cornerRadius : CGFloat = 0
   @IBInspectable var border_Color : UIColor? {
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }
    @IBInspectable var border_Width: Double {
        get {
            return Double(self.layer.borderWidth)
        }
        set {
            self.layer.borderWidth = CGFloat(newValue)
        }
    }
    @IBInspectable var showShadow   : Bool = false
    @IBInspectable var shadow_Color : UIColor? {
        get {
            return UIColor(cgColor: self.layer.shadowColor!)
        }
        set {
            self.layer.shadowColor = newValue?.cgColor
        }
    }
    @IBInspectable var shadow_Radius : CGFloat {
        get {
            return self.layer.shadowRadius
        }
        set {
            self.layer.shadowRadius = newValue
        }
    }
    @IBInspectable var shadow_Opacity : Float {
        get {
            return self.layer.shadowOpacity
        }
        set {
            self.layer.shadowOpacity = newValue
        }
    }
    @IBInspectable var shadow_Height : Double = 2.0
    @IBInspectable var shadow_Width  : Double = 2.0
    
    override func layoutSubviews() {
        super.layoutSubviews()
      
        clipsToBounds      = true
        
        if showShadow
        {
            self.layer.shadowOffset   = CGSize(width: shadow_Width, height: shadow_Height)
            self.layer.masksToBounds  = false
        }
        let corner_Radius  = (cornerRadius * layer.frame.height)/100
        layer.cornerRadius = corner_Radius
    }
    
}
@IBDesignable
class RightImageButton : RoundButton {

    @IBInspectable var rightImage: UIImage? = nil
    @IBInspectable var gapPadding: CGFloat = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }

    func setup() {

        if(rightImage != nil) {
            let imageView = UIImageView(image: rightImage)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit

            addSubview(imageView)

            let length = CGFloat(16)
            titleEdgeInsets.left += length

            NSLayoutConstraint.activate([
                imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -gapPadding),
                imageView.centerYAnchor.constraint(equalTo: self.titleLabel!.centerYAnchor, constant: 0),
                imageView.widthAnchor.constraint(equalToConstant: length),
                imageView.heightAnchor.constraint(equalToConstant: length)
            ])
        }
    }
}
//MARK:- TextField Border & Corner radius

@IBDesignable
class RoundTextField : UITextField {
    @IBInspectable var corner_Radius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            let corner_Radius  = (newValue * layer.frame.height)/100
            self.layer.cornerRadius = corner_Radius
            //self.layer.masksToBounds = true
        }
    }
    
    @IBInspectable var border_Width: Double {
        get {
            return Double(self.layer.borderWidth)
        }
        set {
            self.layer.borderWidth = CGFloat(newValue)
        }
    }
    @IBInspectable var border_Color: UIColor? {
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }
     @IBInspectable var placeHolderColor : UIColor? {
           get {
               return attributedPlaceholder?.attribute(.foregroundColor, at: 0, effectiveRange: nil) as? UIColor ?? .clear
           }
           set {
               guard let attributedPlaceholder = attributedPlaceholder else { return }
            let attributes: [NSAttributedString.Key: UIColor] = [.foregroundColor: newValue ?? UIColor.lightGray]
               self.attributedPlaceholder = NSAttributedString(string: attributedPlaceholder.string, attributes: attributes)
           }
       }
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    @IBInspectable var rightImage: UIImage? {
        didSet {
            updateView()
        }
    }
    var padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 15)
    
    func updateView() {
        if let image = leftImage {
            leftViewMode    = UITextField.ViewMode.always
            let outerView   = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 20))
            let imageView   = UIImageView(frame: CGRect(x: 5, y: 0, width: 20, height: 20))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            //outerView.backgroundColor = UIColor.red
            outerView.addSubview(imageView)
            leftView        = outerView
            padding         = UIEdgeInsets(top: 0, left: 28, bottom: 0, right: 5)
            
        } else if let image = rightImage {
            
            rightViewMode   = UITextField.ViewMode.always
            let outerView   = UIView(frame: CGRect(x: CGFloat(self.frame.size.width - 35), y: 0, width: 35, height: 20))
            let imageView   = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            outerView.addSubview(imageView)
            rightView       = outerView
            padding         = UIEdgeInsets(top: 0, left:5, bottom: 0, right: 25)
            
        } else {
            leftViewMode = UITextField.ViewMode.never
            leftView     = nil
            padding      = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 15)
        }
        
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    //Shadow
    @IBInspectable var showShadow   : Bool = false
    @IBInspectable var shadow_Color : UIColor? {
        get {
            return UIColor(cgColor: self.layer.shadowColor!)
        }
        set {
            self.layer.shadowColor = newValue?.cgColor
        }
    }
    @IBInspectable var shadow_Radius : CGFloat {
        get {
            return self.layer.shadowRadius
        }
        set {
            self.layer.shadowRadius = newValue
        }
    }
    @IBInspectable var shadow_Opacity : Float {
        get {
            return self.layer.shadowOpacity
        }
        set {
            self.layer.shadowOpacity = newValue
        }
    }
    @IBInspectable var shadow_Height : Double = 2.0
    @IBInspectable var shadow_Width  : Double = 2.0
    
    override func layoutSubviews() {
        super.layoutSubviews()
      
        clipsToBounds      = true
        
        if showShadow
        {
            self.layer.shadowOffset   = CGSize(width: shadow_Width, height: shadow_Height)
            self.layer.masksToBounds  = false
        }
    }
}
//MARK:- UIImage Corner Radius
@IBDesignable
class RoundImage : UIImageView {
    
    @IBInspectable var cornerRadius : CGFloat = 0
    
    override func layoutSubviews() {
        super.layoutSubviews()
         //Change corner radius with percentage
        let corner_Radius  = (cornerRadius * layer.frame.height)/100
        layer.cornerRadius = corner_Radius
        clipsToBounds      = true
        
    }
    @IBInspectable var border_Color: UIColor? {
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }
    @IBInspectable var border_Width: Double {
        get {
            return Double(self.layer.borderWidth)
        }
        set {
            self.layer.borderWidth = CGFloat(newValue)
        }
    }
}
//MARK:- --- UIView ----
@IBDesignable
class DashedView : UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius  = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var dashWidth  : CGFloat = 0
    @IBInspectable var dashColor  : UIColor = .clear
    @IBInspectable var dashLength : CGFloat = 0
    @IBInspectable var betweenDashesSpace : CGFloat = 0
    
    var dashBorder: CAShapeLayer?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dashBorder?.removeFromSuperlayer()
        let dashBorder             = CAShapeLayer()
        dashBorder.lineWidth       = dashWidth
        dashBorder.strokeColor     = dashColor.cgColor
        dashBorder.lineDashPattern = [dashLength, betweenDashesSpace] as [NSNumber]
        dashBorder.frame           = bounds
        dashBorder.fillColor       = nil
        
        if cornerRadius > 0 {
            dashBorder.path = UIBezierPath(roundedRect: bounds, cornerRadius: (cornerRadius * layer.frame.height)/100).cgPath
        } else {
            dashBorder.path = UIBezierPath(rect: bounds).cgPath
        }
        layer.addSublayer(dashBorder)
        self.dashBorder = dashBorder
    }
}
//MARK:- ------- UIView -------
//MARK:-
@IBDesignable
class RoundView : UIView
{
    @IBInspectable var roundValue   : CGFloat = 0
    @IBInspectable var Both_Top     : Bool = false
    @IBInspectable var Both_Bottom  : Bool = false
    @IBInspectable var LeftBottom   : Bool = false
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        //calculate by percentage
        let makeRoundCorner = (roundValue * layer.frame.width)/100
        let maskLayer       = CAShapeLayer()
        var roundedCorners  = UIRectCorner()
        
        if Both_Top {
            roundedCorners.insert(.topLeft)
            roundedCorners.insert(.topRight)
        }
        if Both_Bottom {
            roundedCorners.insert(.bottomRight)
            roundedCorners.insert(.bottomLeft)
        }
        if LeftBottom {
            roundedCorners.insert(.bottomLeft)
        }

            maskLayer.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: roundedCorners, cornerRadii: CGSize(width: makeRoundCorner, height: makeRoundCorner)).cgPath
            layer.mask = maskLayer
    }
    
}
//MARK:- ----- UISlider ------
open class CustomSlider : UISlider {
    @IBInspectable open var trackWidth:CGFloat = 2 {
        didSet {setNeedsDisplay()}
    }

    override open func trackRect(forBounds bounds: CGRect) -> CGRect {
        let defaultBounds = super.trackRect(forBounds: bounds)
        return CGRect(
            x: defaultBounds.origin.x,
            y: defaultBounds.origin.y + defaultBounds.size.height/2 - trackWidth/2,
            width: defaultBounds.size.width,
            height: trackWidth
        )
    }
}
@IBDesignable
class PlainCircularProgressBar: UIView {
    @IBInspectable var color: UIColor? = .gray {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable var ringWidth: CGFloat = 5

    var progress: CGFloat = 0 {
        didSet { setNeedsDisplay() }
    }

    private var progressLayer = CAShapeLayer()
    private var backgroundMask = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()

    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }

    private func setupLayers() {
        backgroundMask.lineWidth = 20
        backgroundMask.fillColor = nil
        backgroundMask.strokeColor = UIColor.black.cgColor
        layer.mask = backgroundMask

        progressLayer.lineWidth = 20
        progressLayer.fillColor = nil
        layer.addSublayer(progressLayer)
        layer.transform = CATransform3DMakeRotation(CGFloat(90 * Double.pi / 180), 0, 0, -1)
    }

    override func draw(_ rect: CGRect) {
        let circlePath = UIBezierPath(ovalIn: rect.insetBy(dx: ringWidth / 2, dy: ringWidth / 2))
        backgroundMask.path = circlePath.cgPath

        progressLayer.path = circlePath.cgPath
        progressLayer.lineCap = .round
        progressLayer.strokeStart = 0
        
        progressLayer.strokeEnd = progress
        progressLayer.strokeColor = color?.cgColor
    }
}
//MARK:- TextView Border & Corner radius

@IBDesignable
class RoundTextView : IQTextView {
    @IBInspectable var corner_Radius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            let corner_Radius  = (newValue * layer.frame.height)/100
            self.layer.cornerRadius = corner_Radius
            //self.layer.masksToBounds = true
        }
    }
    
    @IBInspectable var border_Width: Double {
        get {
            return Double(self.layer.borderWidth)
        }
        set {
            self.layer.borderWidth = CGFloat(newValue)
        }
    }
    @IBInspectable var border_Color: UIColor? {
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }
}
