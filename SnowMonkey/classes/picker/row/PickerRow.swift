//
//  PickerRow.swift
//  SnowMonkey
//
//  Created by Red10 on 04/03/2021.
//  Copyright © 2021 mathieu lecoupeur. All rights reserved.
//

import UIKit

public struct PickerComponent {
    var layout: PickerComponentLayout
    var rows: [PickerRow]
}

public class PickerRow: NSObject {
    var id: String
    var text: String?
    var attributedText: NSAttributedString?
    
    public init(id: String, text: String) {
        self.id = id
        self.text = text
    }
    
    public init(id: String, attributedText: NSAttributedString) {
        self.id = id
        self.attributedText = attributedText
    }
}


public struct PickerComponentLayout {
    var width: CGFloat
    var height: CGFloat
    
    static var `default` = PickerComponentLayout(width: UIScreen.main.bounds.width, height: CGFloat(40))
}
