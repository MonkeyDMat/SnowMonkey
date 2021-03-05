//
//  PickerSource.swift
//  SnowMonkey
//
//  Created by Red10 on 04/03/2021.
//  Copyright © 2021 mathieu lecoupeur. All rights reserved.
//

import UIKit

@objc public protocol PickerSourceDelegate {
    func didSelectRow(picker: PickerView, row: Int, inComponent component: Int)
}

open class PickerSource: NSObject {
    
    var components: [PickerComponent] = []
    
    public var delegate: PickerSourceDelegate?
    public weak var picker: PickerView?
    
    public init(picker: PickerView, delegate: PickerSourceDelegate? = nil) {
        self.picker = picker
        self.delegate = delegate
        
        super.init()
        
        self.picker?.source = self
    }
    
    public func setup(components: [PickerComponent]) {
        self.components = components
        self.picker?.reloadAllComponents()
    }
    
    public func setup(rows: [PickerRow]) {
        self.components = [PickerComponent(layout: PickerComponentLayout.default, rows: rows)]
        self.picker?.reloadAllComponents()
    }
}

public struct PickerComponent {
    var layout: PickerComponentLayout
    var rows: [PickerRow]
}

public struct PickerRow {
    var text: String?
    var attributedText: NSAttributedString?
    
    public init(text: String) {
        self.text = text
    }
    
    public init(attributedText: NSAttributedString) {
        self.attributedText = attributedText
    }
}


public struct PickerComponentLayout {
    var width: CGFloat
    var height: CGFloat
    
    static var `default` = PickerComponentLayout(width: UIScreen.main.bounds.width, height: CGFloat(40))
}
