//
//  RMShapesPageControl.swift
//  RMShapesPageControl
//
//  Created by Rupam Mitra on 20/06/25.
//

import UIKit

enum IndicatorType {
    case circle
    case square
    case rectangleHorizontal
    case rectangleVertical
    case triangleUp
    case triangleDown
    case pentagon
    case hexagon
}

class RMShapesPageControl: UIControl {
    
    var numberOfPages: Int = 0 {
        didSet { setupIndicators() }
    }

    var currentPage: Int = 0 {
        didSet { updateIndicators() }
    }

    var shape: IndicatorType = .circle {
        didSet { setupIndicators() }
    }

    var indicatorSize: CGSize = CGSize(width: 12, height: 12) {
        didSet { setupIndicators() }
    }

    var indicatorSpacing: CGFloat = 8 {
        didSet { setupIndicators() }
    }

    var currentPageTintColor: UIColor = .systemBlue
    var pageIndicatorTintColor: UIColor = .lightGray

    var isVertical: Bool = false {
        didSet { setNeedsLayout() }
    }

    private var indicators: [CAShapeLayer] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        isUserInteractionEnabled = true
    }

    private func setupIndicators() {
        indicators.forEach { $0.removeFromSuperlayer() }
        indicators = []

        for i in 0..<numberOfPages {
            let layer = CAShapeLayer()
            layer.path = path(for: shape, in: CGRect(origin: .zero, size: indicatorSize)).cgPath
            layer.fillColor = (i == currentPage ? currentPageTintColor : pageIndicatorTintColor).cgColor
            self.layer.addSublayer(layer)
            indicators.append(layer)
        }
        setNeedsLayout()
    }

    private func updateIndicators() {
        for (index, layer) in indicators.enumerated() {
            layer.fillColor = (index == currentPage ? currentPageTintColor : pageIndicatorTintColor).cgColor
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let count = CGFloat(numberOfPages)
        let size = indicatorSize
        let spacing = indicatorSpacing

        for (index, layer) in indicators.enumerated() {
            let origin: CGPoint
            if isVertical {
                let totalHeight = count * size.height + (count - 1) * spacing
                let startY = (bounds.height - totalHeight) / 2
                let y = startY + CGFloat(index) * (size.height + spacing)
                origin = CGPoint(x: (bounds.width - size.width) / 2, y: y)
            } else {
                let totalWidth = count * size.width + (count - 1) * spacing
                let startX = (bounds.width - totalWidth) / 2
                let x = startX + CGFloat(index) * (size.width + spacing)
                origin = CGPoint(x: x, y: (bounds.height - size.height) / 2)
            }
            let frame = CGRect(origin: origin, size: size)
            layer.path = path(for: shape, in: frame).cgPath
            layer.frame = bounds
        }
    }

    private func path(for shape: IndicatorType, in rect: CGRect) -> UIBezierPath {
        switch shape {
        case .circle:
            return UIBezierPath(ovalIn: rect)
        case .square:
            return UIBezierPath(rect: rect)
        case .rectangleHorizontal:
            var r = rect
            r.size.width *= 1.5
            return UIBezierPath(roundedRect: r, cornerRadius: 3)
        case .rectangleVertical:
            var r = rect
            r.size.height *= 1.5
            return UIBezierPath(roundedRect: r, cornerRadius: 3)
        case .triangleUp:
            return trianglePath(upward: true, in: rect)
        case .triangleDown:
            return trianglePath(upward: false, in: rect)
        case .pentagon:
            return polygonPath(sides: 5, in: rect)
        case .hexagon:
            return polygonPath(sides: 6, in: rect)
        }
    }

    private func trianglePath(upward: Bool, in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        let midX = rect.midX
        let minX = rect.minX
        let maxX = rect.maxX
        let minY = rect.minY
        let maxY = rect.maxY

        if upward {
            path.move(to: CGPoint(x: midX, y: minY))
            path.addLine(to: CGPoint(x: maxX, y: maxY))
            path.addLine(to: CGPoint(x: minX, y: maxY))
        } else {
            path.move(to: CGPoint(x: minX, y: minY))
            path.addLine(to: CGPoint(x: maxX, y: minY))
            path.addLine(to: CGPoint(x: midX, y: maxY))
        }

        path.close()
        return path
    }

    private func polygonPath(sides: Int, in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let angleIncrement = CGFloat(2 * Double.pi) / CGFloat(sides)
        let rotationOffset = CGFloat(-Double.pi / 2)

        for i in 0..<sides {
            let angle = angleIncrement * CGFloat(i) + rotationOffset
            let point = CGPoint(
                x: center.x + radius * cos(angle),
                y: center.y + radius * sin(angle)
            )
            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        path.close()
        return path
    }

    // Optional: Touch to change page
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let location = touches.first?.location(in: self) else { return }
        for (index, _) in indicators.enumerated() {
            let size = indicatorSize
            let spacing = indicatorSpacing
            let count = CGFloat(numberOfPages)

            if isVertical {
                let totalHeight = count * size.height + (count - 1) * spacing
                let startY = (bounds.height - totalHeight) / 2
                let y = startY + CGFloat(index) * (size.height + spacing)
                let rect = CGRect(x: (bounds.width - size.width) / 2, y: y, width: size.width, height: size.height)
                if rect.contains(location) {
                    currentPage = index
                    sendActions(for: .valueChanged)
                    break
                }
            } else {
                let totalWidth = count * size.width + (count - 1) * spacing
                let startX = (bounds.width - totalWidth) / 2
                let x = startX + CGFloat(index) * (size.width + spacing)
                let rect = CGRect(x: x, y: (bounds.height - size.height) / 2, width: size.width, height: size.height)
                if rect.contains(location) {
                    currentPage = index
                    sendActions(for: .valueChanged)
                    break
                }
            }
        }
    }
}
