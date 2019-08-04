//
//  ViewController.swift
//  SwiftSVGKitExample
//
//  Created by Majid Hatami Aghdam on 8/3/19.
//  Copyright © 2019 Majid Hatami Aghdam. All rights reserved.
//

import UIKit
import SwiftSVGKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        guard let path = Bundle.main.path(forResource: "callkit_backdelete_dialpad_icon", ofType: "svg"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
            let document = SVGDocument(data: data)
            else { return }
        
        for item:Item in document.svg.items {
            NSLog("id: %@", item.id)
            if item.id == "box" {
                let style = Style(strokeColor: nil, fillColor: UIColor.red)
                item.setStyle(style)
            }
            //item.style = Style(attributes: item1.attributes)
            //document.svg.items.first?.style = Style(attributes: item1.attributes)
        }
        
        let layers = document.svg.layers(size: CGSize(width: 200, height: 200))
        
        for layer in layers {
            self.view.layer.addSublayer(layer)
        }
        
        self.imageView.image = document.svg.image( CGSize(width: 100, height: 100))
    }


}

