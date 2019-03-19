//
//  CustomViewController.swift
//  EasyListExample
//
//  Created by mathieu lecoupeur on 17/03/2019.
//  Copyright © 2019 mathieu lecoupeur. All rights reserved.
//

import UIKit

class CustomViewController: UIViewController {
    
    @IBOutlet weak var tableView: TableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let tableView = tableView else {
            return
        }
        
        let source = Source(tableView: tableView)
        source.setRowSelectionStyle { () -> UITableViewCell.SelectionStyle in
            return .none
        }
        
        let header = CustomHeader()
        header.setup(text: "Custom Header\nThis is a custom header")
        
        let footer = CustomFooter()
        footer.setup(text: "Footer\nThis is a custom Footer")
        
        let section = Section(header: header, footer: footer)
        source.addSection(section)
        
        for i in 1...30 {
            section.addRow(CustomRow(text: "Custom Row " + NSNumber(value: i).stringValue))
        }
    }
}
