//
//  NativeViewController.swift
//  EasyListExample
//
//  Created by mathieu lecoupeur on 22/07/2018.
//  Copyright © 2018 mathieu lecoupeur. All rights reserved.
//

import UIKit

class NativeViewController: UIViewController {
    
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
        
        let section = Section<NativeHeader, NativeFooter>(header: NativeHeader(title: "Native Header"),
                                                          footer: NativeFooter(title: "Native Footer"))
        
        source.addSection(section)
            .addRow(NativeRow(text: "Style subtitle", detail: "subtitle", style: .subtitle))
            .addRow(NativeRow(text: "Style value 1", detail: "value 1", style: .value1))
            .addRow(NativeRow(text: "Style value 2", detail: "value 2", style: .value2))
            
        for i in 1...30 {
            section.addRow(NativeRow(text: "Native Row " + NSNumber(value: i).stringValue))
        }
    }
}
