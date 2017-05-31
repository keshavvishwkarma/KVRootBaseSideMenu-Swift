//
//  KVAnimationExtention.swift
//  https://github.com/keshavvishwkarma/KVRootBaseSideMenu-Swift.git
//
//  Distributed under the MIT License.
//
//  Created by Keshav on 7/26/16.
//  Copyright © 2016 Keshav. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
//  of the Software, and to permit persons to whom the Software is furnished to do
//  so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit

private var xoAssociationKey: UInt8 = 0

extension CALayer
{
    var associatedObject: CALayer? {
        get {
            return objc_getAssociatedObject(self, &xoAssociationKey) as? CALayer
        }
        set(newValue) {
            objc_setAssociatedObject(self, &xoAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
}

extension CALayer {
    
    public func startAnimation(tintColor: UIColor? = UIColor.orange)
    {
        if (associatedObject == nil)
        {
            let _circleLayer: CALayer = CALayer()
            associatedObject = _circleLayer
            addSublayer(_circleLayer)
            _circleLayer.name = "KVAnimationExtention"
            
            let size : CGFloat = max(self.bounds.height, self.bounds.width);
            let dx : CGFloat   = (self.bounds.size.width - size) / 2.0
            let dy : CGFloat   = (self.bounds.size.height - size) / 2.0
            
            _circleLayer.opacity = 0.0
            
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            CATransaction.setCompletionBlock {
                self.stopAnimation()
            }
            
            _circleLayer.frame = CGRect(x: dx, y: dy, width: size, height: size)
            _circleLayer.cornerRadius = size / 2.0
            _circleLayer.backgroundColor = tintColor?.cgColor;
            
            let circleLayerAnimation : CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
            circleLayerAnimation.fromValue = NSNumber(value: 0.2 as Double)
            circleLayerAnimation.toValue   = NSNumber(value: 1.1 as Double)
            circleLayerAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            
            let opacityAnimation : CABasicAnimation = CABasicAnimation(keyPath: "opacity")
            opacityAnimation.fromValue = NSNumber(value: 0.75 as Double)
            opacityAnimation.toValue   = NSNumber(value: 0.0 as Double)
            opacityAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            
            let groupAnim : CAAnimationGroup = CAAnimationGroup()
            groupAnim.duration = 0.75
            groupAnim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            groupAnim.isRemovedOnCompletion = true
            // groupAnim.fillMode = kCAFillModeForwards
            groupAnim.fillMode = kCAFillModeBoth
            groupAnim.animations = [circleLayerAnimation, opacityAnimation]
            _circleLayer.add(groupAnim, forKey: "animation")
            
            CATransaction.commit()
        }
        
    }
    
    fileprivate func stopAnimation() {
        associatedObject?.removeFromSuperlayer()
        associatedObject = nil
    }
    
}
