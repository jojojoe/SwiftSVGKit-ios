import CoreGraphics
import Foundation
import UIKit

public enum StyleFilleRule:String {
    case nonzero = "nonzero"
    case evenodd = "evenodd"
}

public enum StyleLineCap: String {
    case butt = "butt"
    case square = "square"
    case round = "round"
}

public class Style {
  public var strokeColor: UIColor?
  public let strokeWidth: CGFloat
  public var fillColor: UIColor?
  public let opacity: CGFloat
  public var fillRule: String?
  public var lineCap: CAShapeLayerLineCap?
  public var lineJoin: String?
  public var miterLimit: CGFloat?
    
    public init( strokeColor:UIColor?, strokeWidth:CGFloat? = -1, fillColor:UIColor?, opacity:CGFloat = 1, fillRule:StyleFilleRule? = nil, lineCap: StyleLineCap? = nil, miterLimit: CGFloat? = nil) {
        self.strokeColor = strokeColor;
        self.strokeWidth = strokeWidth ?? -1;
        self.fillColor = fillColor;
        self.opacity = opacity;
        self.fillRule = Style.parse(fillRule: fillRule );
        if let m_lineCap = lineCap {
            self.lineCap = CAShapeLayerLineCap(rawValue: m_lineCap.rawValue);
        }else{
            self.lineCap = nil;
        }
        self.miterLimit = miterLimit;
    }

  public init(attributes: JSONDictionary) {
    var attributes = attributes
    
    if let string = attributes.string(key: "style") {
      attributes = attributes.merge(another: Style.parse(string: string))
    }
    
    self.strokeWidth = attributes.number(key: "stroke-width") ?? 1
    self.fillColor = attributes.color(key: "fill")
    self.strokeColor = attributes.color(key: "stroke")
    self.opacity = attributes.number(key: "opacity") ?? 1
    
    if let m_fillRule = attributes.string(key: "fill-rule"){
        self.fillRule = Style.parse(fillRule: StyleFilleRule.init(rawValue: m_fillRule) )
    } else{
        self.fillRule = nil
    }
    
    if let m_lineCap = attributes.string(key: "stroke-linecap"), let enumVal = StyleLineCap(rawValue: m_lineCap) {
        self.lineCap = CAShapeLayerLineCap(rawValue: enumVal.rawValue )
    } else{
        self.lineCap = nil;
    }
    
    self.lineJoin = Style.parse(lineJoin: attributes.string(key: "stroke-linejoin"))
    self.miterLimit = attributes.number(key: "stroke-miterlimit")
    
    
  }
  
  static func parse(string: String) -> JSONDictionary {
    var attributes: JSONDictionary = JSONDictionary()
    
    string.components(separatedBy: ";").map {
      return $0.replacingOccurrences(of: " ", with: "")
    }.forEach {
      let components: [String] = $0.components(separatedBy: ":")
      if components.count == 2 {
        attributes[components[0]] = components[1]
      }
    }
    
    return attributes
  }
  
  // MARK: - Helper
  
  static func parse(fillRule: StyleFilleRule?) -> String? {
    guard let fillRule = fillRule else { return nil }
    
    let mapping: [String: String] = [
      "nonzero": CAShapeLayerFillRule.nonZero.rawValue,
      "evenodd": CAShapeLayerFillRule.evenOdd.rawValue
    ]
    
    return mapping[fillRule.rawValue]
  }
    
  static func parse(lineJoin: String?) -> String? {
    guard let lineJoin = lineJoin else { return nil }

    if ["bevel", "miter", "round"].contains(lineJoin) {
      return lineJoin
    } else {
      return nil
    }
  }
}
