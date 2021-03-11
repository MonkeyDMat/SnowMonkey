//
//  InsertionViewController.swift
//  SnowMonkeyExample
//
//  Created by Red10 on 11/03/2021.
//  Copyright © 2021 mathieu lecoupeur. All rights reserved.
//

import UIKit

class InsertionTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: TableView?
    
    var source: TableSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let tableView = tableView else {
            return
        }
        
        source = TableSource(tableView: tableView)
        source.setRowSelectionStyle { (_) -> UITableViewCell.SelectionStyle in
            return .none
        }
        
        let header1 = CustomHeaderWithAction()
        
        let section1 = TableSection(header: header1, footer: nil)
        source.addSection(section1)
            .addRow(NativeRow(id: "S1 R1", text: "S1 R1", detail: "S1 R1", style: .value1))
            .addRow(NativeRow(id: "S1 R2", text: "S1 R2", detail: "S1 R2", style: .value1))
            .addRow(NativeRow(id: "S1 R3", text: "S1 R3", detail: "S1 R3", style: .value1))
        
        header1.setup(text: "Inserts a new row before row S1 R2", actionButtonTitle: "Insert", action: {
            
            section1.addRow(NativeRow(id: "New Row", text: "New Row", detail: "New Row", style: .value1), before: { (currentRow, _) -> Bool in
                return currentRow.id == "S1 R2"
            })
        })
        
        
        let header2 = CustomHeaderWithAction()
        
        let section2 = TableSection(header: header2, footer: nil)
        source.addSection(section2)
            .addRow(NativeRow(id: "S2 R1", text: "S2 R1", detail: "S2 R1", style: .value1))
            .addRow(NativeRow(id: "S2 R2", text: "S2 R2", detail: "S2 R2", style: .value1))
            .addRow(NativeRow(id: "S2 R3", text: "S2 R3", detail: "S2 R3", style: .value1))
        
        header2.setup(text: "Inserts a new row after row S2 R2", actionButtonTitle: "Insert", action: {
            
            section2.addRow(NativeRow(id: "New Row", text: "New Row", detail: "New Row", style: .value1), after: { (currentRow, _) -> Bool in
                return currentRow.id == "S2 R2"
            })
        })
    }
}
