//
//  DefaultHeader.swift
//  EasyListExample
//
//  Created by mathieu lecoupeur on 11/07/2018.
//  Copyright © 2018 mathieu lecoupeur. All rights reserved.
//

import UIKit

class CustomHeader: BaseHeader {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var title: UILabel!
    
    @discardableResult
    func setup(text: String) -> CustomHeader {
        Bundle.main.loadNibNamed("CustomHeader", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        title.text = text
        
        return self
    }
}
