//
//  PickerViewController.swift
//  SnowMonkeyExample
//
//  Created by Red10 on 04/03/2021.
//  Copyright © 2021 mathieu lecoupeur. All rights reserved.
//

import UIKit

class PickerViewController: UIViewController {
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
        
        let section = TableSection<NativeHeader, NativeFooter>(header: nil,
                                                               footer: nil)
        
        let row = TextFieldPickerRow(text: "Picker")
        source.addSection(section).addRow(row)
    }
}
