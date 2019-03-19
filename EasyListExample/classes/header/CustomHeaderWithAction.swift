//
//  CustomHeaderWithAction.swift
//  EasyList
//
//  Created by mathieu lecoupeur on 19/03/2019.
//  Copyright © 2019 mathieu lecoupeur. All rights reserved.
//

import UIKit

class CustomHeaderWithAction: BaseHeader {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    var action: (() -> Void)?
    
    @discardableResult
    func setup(text: String, actionButtonTitle: String, action: (() -> Void)?) -> CustomHeaderWithAction {
        Bundle.main.loadNibNamed("CustomHeaderWithAction", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        title.text = text
        actionButton.setTitle(actionButtonTitle, for: .normal)
        self.action = action
        
        return self
    }
    
    @IBAction func onAction(sender: UIButton) {
        action?()
    }
}
