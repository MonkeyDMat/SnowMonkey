//
//  EditableViewController.swift
//  EasyListExample
//
//  Created by mathieu lecoupeur on 17/03/2019.
//  Copyright © 2019 mathieu lecoupeur. All rights reserved.
//

import UIKit

class EditableTableViewController: UIViewController {
    
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
        source.delegate = self
        
        let header = CustomHeaderWithAction()
        header.setup(text: "Custom Header\nThis is a custom header", actionButtonTitle: "Edit", action: {
            tableView.setEditing(!tableView.isEditing, animated: true)
            header.actionButton.setTitle(tableView.isEditing ? "Terminer" : "Editer", for: .normal)
        })
        
        let footer = CustomFooter()
        footer.setup(text: "Footer\nThis is a custom Footer")
        
        let section = TableSection(header: header, footer: footer)
        source.addSection(section)
        
        section.setEditable(editable: { (_) -> Bool in
            return true
        }, editingStyle: { (_) -> UITableViewCell.EditingStyle in
            return .delete
        }) { (_) -> String? in
            return "supprimer"
        }
        
        for i in 1...5 {
            section.addRow(CustomRow(text: "Custom Row " + NSNumber(value: i).stringValue).setRowHeight({ (_) -> CGFloat in
                return CGFloat(30 * i)
            }))
        }
    }
}

extension EditableTableViewController: TableSourceDelegate {
    
    func commitEditingStyle(editingStyle: UITableViewCell.EditingStyle, at index: IndexPath, for: UITableView) {
        source.getSection(index: index.section).section.deleteRow(at: index.row, animation: .left)
    }
}
