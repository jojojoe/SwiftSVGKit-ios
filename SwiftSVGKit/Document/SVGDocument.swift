import Foundation

public typealias JSONDictionary = [String: Any]

public class SVGDocument {
  
  public let svg: SVG

  public convenience init?(fileName: String) {
    guard let path = Bundle.main.path(forResource: fileName, ofType: "svg"),
      let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else { return nil }

    self.init(data: data)
  }
  
  public init?(data: Data) {
    guard let document = try? ReindeerDocument(data: data),
      document.rootElement.name == "svg" else { return nil }

    self.svg = SVG(element: document.rootElement)
  }
    
    public func layers(size: CGSize) -> [CALayer] {
        return svg.layers(size: size)
    }
    
    public func image(_ size:CGSize) -> UIImage? {
        return self.svg.image(size)
    }
    
    public func setStyle(_ style:Style, for itemId: String){
        for item in self.svg.items {
            if item.id == itemId {
                item.setStyle(style);
                break;
            }
        }
    }
}
