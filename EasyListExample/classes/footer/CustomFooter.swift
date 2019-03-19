//
//  CustomFooter.swift
//  EasyListExample
//
//  Created by mathieu lecoupeur on 15/07/2018.
//  Copyright © 2018 mathieu lecoupeur. All rights reserved.
//

import UIKit

class CustomFooter: BaseFooter {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var title: UILabel!
    
    @discardableResult
    func setup(text: String) -> CustomFooter {
        Bundle.main.loadNibNamed("CustomFooter", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        title.text = text
        
        return self
    }
}
