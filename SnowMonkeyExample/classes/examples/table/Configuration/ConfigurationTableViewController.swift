//
//  ConfigurationViewController.swift
//  EasyListExample
//
//  Created by mathieu lecoupeur on 17/03/2019.
//  Copyright © 2019 mathieu lecoupeur. All rights reserved.
//

import UIKit

class ConfigurationTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: TableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let tableView = tableView else {
            return
        }
        
        let source = TableSource(tableView: tableView)
        source.setRowSelectionStyle { (_) -> UITableViewCell.SelectionStyle in
            return .none
        }
        
        // Row height set for whole table
        source.setRowHeight { (_) -> CGFloat in
            return 120
        }
        
        // Section 1
        let header1 = CustomHeader()
        header1.setup(text: "Section 1")
        
        let section1 = TableSection(header: header1, footer: nil)
        source.addSection(section1)
        
        // Row height set for this section
        section1.setRowHeight { (_) -> CGFloat in
            return 80
        }
        
        // Row height set for this row (ie: 40)
        section1.addRow(CustomRow(id: "s1customRow1", text: "Custom Row 1").setRowHeight({ (_) -> CGFloat in
            return 40
        }))
        for i in 2...4 {
            // All these cells have their height defined by the section (ie : 80)
            section1.addRow(CustomRow(id: "s1customRow\(i)", text: "Custom Row " + NSNumber(value: i).stringValue))
        }
        
        
        // Section 2
        // All the cells of this section have their height defined by the source (ie: 120)
        let header2 = CustomHeader()
        header2.setup(text: "Section 2")
        
        let section2 = TableSection(header: header2, footer: nil)
        source.addSection(section2)
        
        for i in 1...5 {
            section2.addRow(CustomRow(id: "s2customRow\(i)", text: "Custom Row " + NSNumber(value: i).stringValue))
        }
    }
}
