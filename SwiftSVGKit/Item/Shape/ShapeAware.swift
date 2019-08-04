import UIKit

public protocol ShapeAware {

  var id: String { get }
  var style: Style { get }
  var path: UIBezierPath { get }
}

public extension ShapeAware {

  func layer() -> CAShapeLayer {
    let layer = CAShapeLayer()
    layer.path = path.cgPath
    layer.name = id

    layer.strokeColor = style.strokeColor?.cgColor
    layer.lineWidth = style.strokeWidth
    layer.fillColor = style.fillColor?.cgColor
    layer.opacity = Float(style.opacity)

    if let fillRule = style.fillRule {
      layer.fillRule = CAShapeLayerFillRule(rawValue: fillRule)
    }

    if let lineCap = style.lineCap {
      layer.lineCap = lineCap
    }

    if let lineJoin = style.lineJoin {
      layer.lineJoin = CAShapeLayerLineJoin(rawValue: lineJoin)
    }

    if let miterLimit = style.miterLimit {
      layer.miterLimit = miterLimit
    }

    return layer
  }
}
