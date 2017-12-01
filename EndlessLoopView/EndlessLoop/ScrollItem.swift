//
//  ScrollItem.swift
//  ScrollViewDemo
//
//  Created by sunhua_com on 16/3/10.
//  Copyright © 2016年 sunhua_com. All rights reserved.
//

import UIKit

class ScrollItem: NSObject {
    
    var itemUrl : URL?
    var itemLocalName : String?
    var placeholderImage : UIImage?
    
    init(_ url: String? = nil, localName: String? = nil,holderImage: UIImage? = nil) {
        itemUrl = URL(string: url ?? "")
        itemLocalName = localName
        placeholderImage = holderImage
    }
}
