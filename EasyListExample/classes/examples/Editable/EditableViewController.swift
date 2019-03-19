//
//  EditableViewController.swift
//  EasyListExample
//
//  Created by mathieu lecoupeur on 17/03/2019.
//  Copyright © 2019 mathieu lecoupeur. All rights reserved.
//

import UIKit

class EditableViewController: UIViewController {
    
    @IBOutlet weak var tableView: TableView?
    
    var source: Source!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let tableView = tableView else {
            return
        }
        
        source = Source(tableView: tableView)
        source.setRowSelectionStyle { () -> UITableViewCell.SelectionStyle in
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
        
        let section = Section(header: header, footer: footer)
        source.addSection(section)
        
        section.setEditable(editable: { () -> Bool in
            return true
        }, editingStyle: { () -> UITableViewCell.EditingStyle in
            return .delete
        }) { () -> String? in
            return "supprimer"
        }
        
        for i in 1...5 {
            section.addRow(CustomRow(text: "Custom Row " + NSNumber(value: i).stringValue).setRowHeight({ () -> CGFloat in
                return CGFloat(30 * i)
            }))
        }
    }
}

extension EditableViewController: SourceDelegate {
    
    func commitEditingStyle(editingStyle: UITableViewCell.EditingStyle, at index: IndexPath, for: UITableView) {
        source.deleteRow(at: index)
    }
}
