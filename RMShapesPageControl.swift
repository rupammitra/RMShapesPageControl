//
//  RMSquarePageControl.swift
//  SquarePageControl
//
//  Created by Rupam Mitra on 20/08/16.
//  Copyright (c) 2016 Rupam Mitra. All rights reserved.
//

import UIKit

enum Direction: Int {
    case positive = 1
    case negative = 2
}

enum IndicatorType: Int {
    case square = 1
    case circle = 2
    case trianglePositive = 3
    case triangleNegative = 4
}

@IBDesignable
class RMShapesPageControl: UIControl {

    fileprivate let kDotLength: CGFloat = 4.0
    fileprivate let kDotSpace: CGFloat = 12.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.backgroundColor = UIColor.clear
    }
    
    var indicatorType: IndicatorType = .square
    @IBInspectable var indicator: Int = 1 {
        didSet {
            indicatorType = IndicatorType(rawValue: indicator)!
        }
    }
    
    @IBInspectable var numberOfPages: Int = 0 {
        didSet {
            let center = self.center
            self.center = center
            self.currentPage = min(max(0, self.currentPage), numberOfPages - 1)
            self.setNeedsDisplay()
            if hidesForSinglePage == true && numberOfPages < 2 {
                self.isHidden = true
            }else {
                self.isHidden = false
            }
        }
    }
    
    @IBInspectable var currentPage: Int = 0 {
        willSet {
            if currentPage == newValue {
                return
            }
        }
        didSet {
            currentPage = min(max(0, currentPage), numberOfPages - 1)
            if defersCurrentPageDisplay == false {
                setNeedsDisplay()
            }
        }
    }
    
    @IBInspectable var hidesForSinglePage: Bool = false {
        didSet {
            if hidesForSinglePage == true && numberOfPages < 2 {
                isHidden = true
            }
        }
    }
    
    var defersCurrentPageDisplay: Bool = false
    
    @IBInspectable var currentPageColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var otherPagesColor: UIColor? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var indicatorLength: CGFloat = 4.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var indicatorSpace: CGFloat = 12.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    final override func draw(_ rect: CGRect) {
        super.draw(rect)
        // Drawing code
        let context: CGContext = UIGraphicsGetCurrentContext()!
        
        context.saveGState()
        context.setAllowsAntialiasing(true)
        
        let length = (indicatorLength > 0) ? indicatorLength : kDotLength
        let space = (indicatorSpace > 0) ? indicatorSpace : kDotSpace

        let currentBounds = bounds
        let dotsWidth = CGFloat(numberOfPages) * length + CGFloat(max(0, numberOfPages - 1)) * space
        
        var x: CGFloat = 0.0
        var y: CGFloat = 0.0
        
        if frame.height > frame.width {
            x = currentBounds.midX - length / 2
            y = currentBounds.midY - dotsWidth / 2
        }else {
            x = currentBounds.midX - dotsWidth / 2
            y = currentBounds.midY - length / 2
        }
        
        let drawOnColor: UIColor = (currentPageColor != nil) ? currentPageColor! : UIColor(white: 1.0, alpha: 1.0)
        let drawOffColor: UIColor = (otherPagesColor != nil) ? otherPagesColor! : UIColor(white: 0.7, alpha: 0.5)
        
        for i in 0 ..< numberOfPages {
            
            let dotRect: CGRect = CGRect(x: x, y: y, width: length, height: length)
            
            if i == self.currentPage {
                context.setFillColor(drawOnColor.cgColor)
                createShapes(inContext: context, forDotRect: dotRect)
            }else{
                context.setFillColor(drawOffColor.cgColor)
                createShapes(inContext: context, forDotRect: dotRect)
            }
            
            if self.frame.height > self.frame.width {
                y += length + space
            }else {
                x += length + space
            }
        }
        
        // restore the context
        context.restoreGState()
    }
    
    func createShapes(inContext context: CGContext, forDotRect dotRect: CGRect) {
        switch indicatorType {
        case .square:
            context.fill(dotRect)
        case .circle:
            context.fillEllipse(in: dotRect)
        case .trianglePositive:
            createTriangle(drawRect: dotRect, inDirection: .positive)
        case .triangleNegative:
            createTriangle(drawRect: dotRect, inDirection: .negative)
        }
    }
    
    func createTriangle(drawRect: CGRect, inDirection direction: Direction) {
        let trianglePath = UIBezierPath()
        if self.frame.height > self.frame.width {
            trianglePath.move(to: CGPoint(x: drawRect.midX, y:drawRect.minY))
            trianglePath.addLine(to: CGPoint(x:direction == .positive ? drawRect.maxX : drawRect.minX, y:drawRect.midY))
            trianglePath.addLine(to: CGPoint(x:drawRect.midX, y:drawRect.maxY))
        }else {
            trianglePath.move(to: CGPoint(x: drawRect.minX, y:drawRect.midY))
            trianglePath.addLine(to: CGPoint(x:drawRect.midX, y:direction == .positive ? drawRect.minY : drawRect.maxY))
            trianglePath.addLine(to: CGPoint(x:drawRect.maxX, y:drawRect.midY))
        }
        trianglePath.fill()
    }
    
    fileprivate func updateCurrentPageDisplay() {
        if defersCurrentPageDisplay == false {
            return
        }
        setNeedsDisplay()
    }
    
    fileprivate func sizeForNumberOfPages(_ pageCount: NSInteger) -> CGSize {
        
        let length: CGFloat = (indicatorLength > 0) ? indicatorLength : kDotLength
        let space: CGFloat = (indicatorSpace > 0) ? indicatorSpace : kDotSpace
        return CGSize(width: max(44.0, length + 4.0), height: CGFloat(pageCount) * length + CGFloat((pageCount - 1)) * space + 44.0)
    }
}
