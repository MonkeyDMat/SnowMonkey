//
//  AnimatedViewController.swift
//  EasyListExample
//
//  Created by mathieu lecoupeur on 17/03/2019.
//  Copyright © 2019 mathieu lecoupeur. All rights reserved.
//

import UIKit

class AnimatedTableViewController: UIViewController {
    
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
        
        let header = CustomHeaderWithAction()
        
        let footer = CustomFooter()
        footer.setup(text: "Footer\nThis is a custom Footer")
        
        let section1 = TableSection(header: header, footer: footer)
        source.addSection(section1)
        
        header.setup(text: "Custom Header\nThis is a custom header", actionButtonTitle: "Refresh", action: {
            section1.deleteAllRows(animation: .top)
            self.source.reloadData()
            self.refreshSection(at: 0)
        })
        
        refreshSection(at: 0)
    }
    
    func refreshSection(at index: Int) {
        for i in 1...5 {
            let randomDuration = Double.random(in: Range<Double>(uncheckedBounds: (lower: 1.0, upper: 5.0)))
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(randomDuration * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
                
                let section = self.source.getSection(index: index)?.section
                section?.addRow(IndexedRow(index: i), after: { (currentRow, newRow) -> Bool in
                                    guard let currentIndexedRow = currentRow.row as? IndexedRow else {
                                        return false
                                    }
                    guard let index = (newRow.row as? IndexedRow)?.index else {
                        return true
                    }
                    return currentIndexedRow.index < index
                }, animation: .bottom)
            }
        }
    }
}
