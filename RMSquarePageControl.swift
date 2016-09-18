//
//  RMSquarePageControl.swift
//  SquarePageControl
//
//  Created by Rupam Mitra on 20/08/16.
//  Copyright (c) 2016 Rupam Mitra. All rights reserved.
//

import UIKit

@IBDesignable
class RMSquarePageControl: UIControl {

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
    
    fileprivate var _numberOfPages: Int = 0
    @IBInspectable var numberOfPages: Int {
        get {
            return _numberOfPages
        }
        set (numOfPages){
            _numberOfPages = max(0, numOfPages)
            let center = self.center
            self.center = center
            self.currentPage = min(max(0, self.currentPage), self.numberOfPages - 1)
            self.setNeedsDisplay()
            if hidesForSinglePage == true && numOfPages < 2 {
                self.isHidden = true
            }else {
                self.isHidden = false
            }
        }
    }
    
    fileprivate var _currentPage: Int = 0
    @IBInspectable var currentPage: Int {
        get {
            return _currentPage
        }
        set (pageNumber){
            if self.currentPage == pageNumber {
                return
            }
            
           _currentPage = min(max(0, pageNumber), self.numberOfPages - 1)
            
            if self.defersCurrentPageDisplay == false {
                setNeedsDisplay()
            }
        }
    }
    
    fileprivate var _hidesForSinglePage: Bool = false
    @IBInspectable var hidesForSinglePage: Bool {
        get {
            return _hidesForSinglePage
        }
        set (hide){
            _hidesForSinglePage = hide
            
            if self.hidesForSinglePage == true && self.numberOfPages < 2 {
                self.isHidden = true
            }
        }
    }
    
    fileprivate var _defersCurrentPageDisplay: Bool = false
    var defersCurrentPageDisplay: Bool {
        get {
            return _defersCurrentPageDisplay
        }
        set (defers){
            _defersCurrentPageDisplay = defers
        }
    }
    
    fileprivate var _currentPageColor: UIColor!
    @IBInspectable var currentPageColor: UIColor! {
        get{
            return _currentPageColor
        }
        set (onColor) {
            _currentPageColor = onColor
            setNeedsDisplay()
        }
    }
    
    fileprivate var _otherPagesColor: UIColor!
    @IBInspectable var otherPagesColor: UIColor! {
        get{
            return _otherPagesColor
        }
        set (offColor){
            _otherPagesColor = offColor
            setNeedsDisplay()
        }
    }
    
    fileprivate var _indicatorLength: CGFloat = 4.0
    @IBInspectable var indicatorLength: CGFloat {
        get{
            return _indicatorLength
        }
        set (length) {
            _indicatorLength = length
            setNeedsDisplay()
        }
    }
    
    fileprivate var _indicatorSpace: CGFloat = 12.0
    @IBInspectable var indicatorSpace: CGFloat {
        get{
            return _indicatorSpace
        }
        set (space) {
            _indicatorSpace = space
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
        
        let length = (self.indicatorLength > 0) ? self.indicatorLength : kDotLength
        let space = (self.indicatorSpace > 0) ? self.indicatorSpace : kDotSpace

        let currentBounds = self.bounds
        let dotsWidth = CGFloat(self.numberOfPages) * length + CGFloat(max(0, self.numberOfPages - 1)) * space
        
        var x: CGFloat = 0.0
        var y: CGFloat = 0.0
        
        if self.frame.height > self.frame.width {
            x = currentBounds.midX - length / 2
            y = currentBounds.midY - dotsWidth / 2
        }else {
            x = currentBounds.midX - dotsWidth / 2
            y = currentBounds.midY - length / 2
        }
        
        let drawOnColor: UIColor = (self.currentPageColor != nil) ? self.currentPageColor : UIColor(white: 1.0, alpha: 1.0)
        let drawOffColor: UIColor = (self.otherPagesColor != nil) ? self.otherPagesColor : UIColor(white: 0.7, alpha: 0.5)
        
        for i in 0 ..< self.numberOfPages {
            
            let dotRect: CGRect = CGRect(x: x, y: y, width: length, height: length)

            if i == self.currentPage {
                context.setFillColor(drawOnColor.cgColor)
                context.fill(dotRect)
            }else{
                context.setFillColor(drawOffColor.cgColor)
                context.fill(dotRect)
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
    
    fileprivate func updateCurrentPageDisplay() {
        
        if self.defersCurrentPageDisplay == false {
            return
        }
        setNeedsDisplay()
    }
    
    fileprivate func sizeForNumberOfPages(_ pageCount: NSInteger) -> CGSize {
        
        let length: CGFloat = (self.indicatorLength > 0) ? self.indicatorLength : kDotLength
        let space: CGFloat = (self.indicatorSpace > 0) ? self.indicatorSpace : kDotSpace
        return CGSize(width: max(44.0, length + 4.0), height: CGFloat(pageCount) * length + CGFloat((pageCount - 1)) * space + 44.0)
    }
}
