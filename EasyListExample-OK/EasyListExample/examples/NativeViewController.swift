//
//  NativeViewController.swift
//  EasyListExample
//
//  Created by mathieu lecoupeur on 22/07/2018.
//  Copyright © 2018 mathieu lecoupeur. All rights reserved.
//

import UIKit
import EasyList

class NativeViewController: UIViewController {
    
    @IBOutlet weak var tableView: TableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let tableView = tableView else {
            return
        }
        
        let source = Source(tableView: tableView)
        
        source.addSection(Section<NativeHeader, NativeFooter>(header: NativeHeader(title: "Native Header"),
                                                              footer: NativeFooter(title: "Native Footer")))
            .addRow(Row<String, Cell<String>>(data: "Native Cell",
                                              cellIdentifier: nil,
                                              configureCell: { (cell, text) in
                                                cell.textLabel?.text = text
            }))
    }
}
