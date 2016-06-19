//
//  CircleGraphView.swift
//  ArcViewSample
//
//  Created by LandCruiser on 2/18/16.
//  Copyright © 2016 LandCruiser. All rights reserved.
//

import UIKit

class CircleGraphView: UIView {
    
    var endArc:CGFloat = 0.0{   // in range of 0.0 to 1.0
        didSet{
            setNeedsDisplay()
        }
    }
    var arcColor:UIColor = UIColor.yellowColor(){
        didSet{
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var startArc: CGFloat = 0
    var arcWidth:CGFloat = 10.0
    var arcBackgroundColor = UIColor.blackColor()
    
    override func drawRect(rect: CGRect) {
        
        //Important constants for circle
        let fullCircle = 2.0 * CGFloat(M_PI)
        let start:CGFloat = (startArc-0.25) * fullCircle
        let end:CGFloat = (endArc-0.25) * fullCircle
//        let end:CGFloat = endArc * fullCircle + start
        
        //find the centerpoint of the rect
        let centerPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect))
        
        //define the radius by the smallest side of the view
        var radius:CGFloat = 0.0
        if CGRectGetWidth(rect) > CGRectGetHeight(rect){
            radius = (CGRectGetWidth(rect) - arcWidth) / 2.0
        }else{
            radius = (CGRectGetHeight(rect) - arcWidth) / 2.0
        }
        //starting point for all drawing code is getting the context.
        let context = UIGraphicsGetCurrentContext()
        //set colorspace
//        let colorspace = CGColorSpaceCreateDeviceRGB()
        //set line attributes
        CGContextSetLineWidth(context, arcWidth)
        CGContextSetLineCap(context, CGLineCap.Round)
        //make the circle background
        
        CGContextSetStrokeColorWithColor(context, arcBackgroundColor.CGColor)
        CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, 0, fullCircle, 0)
        CGContextStrokePath(context)
        
        //draw the arc
        CGContextSetStrokeColorWithColor(context, arcColor.CGColor)
        CGContextSetLineWidth(context, arcWidth * 0.8 )
        //CGContextSetLineWidth(context, arcWidth)
        CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, start, end, 0)
        CGContextStrokePath(context)
        
    }
    
}