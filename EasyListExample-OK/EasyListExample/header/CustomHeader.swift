//
//  DefaultHeader.swift
//  EasyListExample
//
//  Created by mathieu lecoupeur on 11/07/2018.
//  Copyright © 2018 mathieu lecoupeur. All rights reserved.
//

import UIKit
import EasyList

class CustomHeader: BaseHeader {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("CustomHeader", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    @IBAction func onAction() {
        if let tableView = section?.source?.tableView {
            tableView.setEditing(!tableView.isEditing, animated: true)
            actionButton.setTitle(tableView.isEditing ? "Terminer" : "Editer", for: .normal)
        }
    }
    
    //MARK: - HeaderLayout
    public func headerHeight() -> CGFloat {
        return CGFloat(40)
    }
}
