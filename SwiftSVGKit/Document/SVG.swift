import CoreGraphics
import Foundation
import UIKit

public class SVG {

  public let items: [Item]
  public let size: CGSize

  public init(element: Element) {
    self.size = CGSize(width: element.attributes.number(key: "width") ?? 0,
                       height: element.attributes.number(key: "height") ?? 0)

    self.items = Group(element: element).items
  }
}

public extension SVG {

  func view(size: CGSize) -> UIView {
    let view = UIView()
    view.frame.size = size

    for layer in layers(size: size) {
      view.layer.addSublayer(layer)
    }

    return view
  }

  func layers(size: CGSize) -> [CALayer] {
    let layers: [CALayer] =  items.compactMap({ item in
      if let item = item as? ShapeAware {
        return item.layer()
      } else if let item = item as? Text {
        return item.layer()
      } else if let item = item as? Image {
        return item.layer()
      } else {
        return nil
      }
    })

    let originalSize = Utils.bounds(layers: layers).size
    let ratio = Utils.ratio(from: originalSize, to: size)
    let scale = CGAffineTransform(scaleX: ratio, y: ratio)
    Utils.transform(layers: layers, transform: scale)

    let scaledBounds = Utils.bounds(layers: layers)
    let translate = CGAffineTransform(translationX: -scaledBounds.origin.x, y: -scaledBounds.origin.y)
    Utils.transform(layers: layers, transform: translate)

    return layers
  }
    
    func image(_ size:CGSize) -> UIImage? {
        let mLayer = CALayer();
        mLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        for item in self.layers(size: size) {
            mLayer.addSublayer(item);
        }
        let rect = CGRect(origin: CGPoint.zero,
                          size: CGSize(width: size.width, height: size.height))
        
        let renderer = UIGraphicsImageRenderer(size: rect.size)
        let image = renderer.image {
            context in
            return mLayer.render(in: context.cgContext)
        }
        return image;
    }
}
