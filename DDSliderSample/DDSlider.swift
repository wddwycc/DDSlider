//
//  DDSlider.swift
//  DDSliderSample
//
//  Created by 端 闻 on 20/4/15.
//  Copyright (c) 2015年 monk-studio. All rights reserved.
//

import UIKit
import Foundation
class DDSlider: UIControl {
    var textView:UILabel?
    var indicator:DDSliderIndicator!
    var bar_left:UIView!
    var bar_right:UIView!
    var progress:CGFloat = 0
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }


    override func didMoveToSuperview() {
        //initialize bars
        self.backgroundColor = UIColor.clearColor()
        self.bar_left = UIView()
        self.bar_left.backgroundColor = UIColor.whiteColor()
        self.bar_left.alpha = 1
        
        self.bar_right = UIView()
        self.bar_right.backgroundColor = UIColor.whiteColor()
        self.bar_right.alpha = 0.4
        
        //initialize indicator
        self.indicator = DDSliderIndicator()
        self.addSubview(bar_left)
        self.addSubview(bar_right)
        self.addSubview(indicator)
    }

    
    override func layoutSubviews() {
        //layout these indicator
        let indicatorWidth = self.bounds.height * 0.62
        let indicatorHeight = self.bounds.height * 0.71
        if(self.indicator.frame == CGRectZero){
            self.indicator.frame = CGRectMake(0, self.bounds.height * 0.21, indicatorWidth, indicatorHeight)
        }
        
        //layout bars
        let totalBarwidth = self.bounds.width - indicatorWidth
        self.bar_left.frame = CGRectMake(indicatorWidth/2, 0.14*self.bounds.height, totalBarwidth*self.progress, 0.07*self.bounds.height)
        self.bar_right.frame = CGRectMake(indicatorWidth/2 + bar_left.frame.width, 0.14*self.bounds.height, totalBarwidth*(1 - self.progress), 0.07*self.bounds.height)
    }
    
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) -> Bool {
        let point = touch.locationInView(self.indicator)
        if(CGRectContainsPoint(self.indicator.bounds, point)){
            return true
        }else{
            return false
        }
    }
    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) -> Bool {
        let indicatorWidth = self.bounds.height * 0.62
        let delta = touch.locationInView(self.indicator).x - touch.previousLocationInView(self.indicator).x
        let futureP = self.indicator.center.x + delta
        
        
        
        var doMove = true
        if(touch.locationInView(self.indicator).x > touch.previousLocationInView(self.indicator).x){
            let result = self.indicator.rotateRight()
            if result == true{
                doMove = false
            }
        }else{
            let result = self.indicator.rotateLeft()
            if result == true{
                doMove = false
            }
        }
        
        if(doMove == true){
            if(futureP.within(value1: indicatorWidth/2, value2: self.bounds.width - indicatorWidth/2)){
                self.indicator.center.x += delta
            }
            if(futureP > self.bounds.width - indicatorWidth/2){
                self.indicator.center.x = self.bounds.width - indicatorWidth/2
            }
            if(futureP < indicatorWidth/2){
                self.indicator.center.x = indicatorWidth/2
            }
            self.progress = (self.indicator.center.x - indicatorWidth/2) / (self.bounds.width - indicatorWidth)
            self.sendActionsForControlEvents(UIControlEvents.ValueChanged)
            self.layoutSubviews()
        }
        return true
    }
    override func endTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) {
        self.indicator.resetRotation()
    }
}



class DDSliderIndicator:UIView {
    var containerView:UIView!
    let circleLayer = CAShapeLayer()
    let triangleLayer = CAShapeLayer()
    
    let maxRadian = CGFloat(M_PI/8)
    let maxMove:CGFloat = 3
    var ovalInset:CGFloat{
        return self.bounds.width/10
    }
    
    var currentAngle:CGFloat{
        return atan2(self.containerView.layer.transform.m12, self.containerView.layer.transform.m11)
    }
    
    override func didMoveToSuperview() {
        self.userInteractionEnabled = false
        containerView = UIView()
        self.addSubview(containerView)
        containerView.layer.anchorPoint = CGPointMake(0.5, 0)
        
        containerView.layer.addSublayer(circleLayer)
        containerView.layer.addSublayer(triangleLayer)
        
    }
    
    
    
    
    func rotateRight() -> Bool{
        if(self.currentAngle <= -maxRadian){return false}
        self.containerView.layer.transform = CATransform3DRotate(self.containerView.layer.transform, -self.maxRadian/maxMove, 0.0, 0.00001, 1)
        return true
    }
    func rotateLeft() -> Bool{
        if(self.currentAngle >= maxRadian){return false}
        self.containerView.layer.transform = CATransform3DRotate(self.containerView.layer.transform, self.maxRadian/maxMove, 0.0, 0.00001, 1)
        return true
    }
    func resetRotation(){
        UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.containerView.layer.transform = CATransform3DIdentity
            }, completion: nil)
    }
    
    
    override func layoutSubviews(){
        self.containerView.frame = self.bounds
        self.circleLayer.frame = self.bounds
        self.triangleLayer.frame = self.bounds
        let ovalPath = CGPathCreateMutable()
        let ovalframe = CGRectMake(0,(self.bounds.height-self.bounds.width), self.bounds.width, self.bounds.width)
        CGPathAddPath(ovalPath, nil, CGPathCreateWithEllipseInRect(ovalframe, nil))
        CGPathAddPath(ovalPath, nil, CGPathCreateWithEllipseInRect(CGRectInset(ovalframe, self.ovalInset, self.ovalInset), nil))
        self.circleLayer.fillRule = kCAFillRuleEvenOdd
        self.circleLayer.path = ovalPath
        self.circleLayer.fillColor = UIColor.whiteColor().CGColor
        
        
        let trianglePath = CGPathCreateMutable()
        let triangleWidth_2:CGFloat = self.bounds.width/10
        CGPathMoveToPoint(trianglePath, nil, self.bounds.width/2, 2)
        CGPathAddLineToPoint(trianglePath, nil,self.bounds.width/2 + triangleWidth_2, self.bounds.height - self.bounds.width+2)
        CGPathAddLineToPoint(trianglePath, nil, self.bounds.width/2 - triangleWidth_2, self.bounds.height - self.bounds.width+2)
        CGPathCloseSubpath(trianglePath)
        self.triangleLayer.path = trianglePath
        self.triangleLayer.fillColor = UIColor.whiteColor().CGColor
    }
}



extension CGFloat{
    func within(#value1:CGFloat, value2:CGFloat) -> Bool{
        if(self <= value2 && self >= value1){
            return true
        }
        return false
        
    }
}






