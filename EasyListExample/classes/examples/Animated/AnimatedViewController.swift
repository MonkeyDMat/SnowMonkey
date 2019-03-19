//
//  AnimatedViewController.swift
//  EasyListExample
//
//  Created by mathieu lecoupeur on 17/03/2019.
//  Copyright © 2019 mathieu lecoupeur. All rights reserved.
//

import UIKit

class AnimatedViewController: UIViewController {
    
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
        
        for i in 1...5 {
            let randomDuration = Double.random(in: Range<Double>(uncheckedBounds: (lower: 1.0, upper: 10.0)))
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(randomDuration * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
                source.insertRow(IndexedRow(index: i),
                                 in: 0,
                                 after: { (currentRow, newRow) -> Bool in
                    guard let currentIndexedRow = currentRow as? IndexedRow else {
                        return false
                    }
                    return currentIndexedRow.index < newRow.index
                }, animation: .automatic)
            }
        }
    }
}
