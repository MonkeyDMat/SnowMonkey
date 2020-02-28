//
//  GroupedViewController.swift
//  EasyListExample
//
//  Created by Red10 on 20/03/2019.
//  Copyright © 2019 mathieu lecoupeur. All rights reserved.
//

import UIKit

class GroupedTableViewController: UIViewController {
    
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
        source.verbose = true
        
        // Section 1
        let section1 = TableSection<NativeHeader, NativeFooter>(header: NativeHeader(title: "Native Header"),
                                                           footer: NativeFooter(title: "", height: CGFloat.leastNonzeroMagnitude))
        
        for i in 1...5 {
            section1.addRow(NativeRow(id: "s1row\(i)", text: "Section 1 - Row " + NSNumber(value: i).stringValue))
        }
        
        source.addSection(section1)
        
        
        // Section 2
        let section2 = TableSection<NativeHeader, NativeFooter>(header: NativeHeader(title: "", height: CGFloat.leastNonzeroMagnitude),
                                                           footer: NativeFooter(title: "Native Footer"))
        
        for i in 1...5 {
            section2.addRow(NativeRow(id: "s2row\(i)", text: "Section 2 - Row " + NSNumber(value: i).stringValue))
        }
        
        source.addSection(section2)
    }
}
