//
//  CustomDataViewController.swift
//  EasyListExample
//
//  Created by mathieu lecoupeur on 17/03/2019.
//  Copyright © 2019 mathieu lecoupeur. All rights reserved.
//

import UIKit

class CustomDataTableViewController: UIViewController {
    
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
        source.setRowHeight { (_) -> CGFloat in
            return 40
        }
        
        let store = Store(vocation: "Express", name: "Paris", isOpened: true)
        
        let header = CustomHeader()
        header.setup(text: "Custom Header\nThis is a custom header")
        
        let footer = CustomFooter()
        footer.setup(text: "Footer\nThis is a custom Footer")
        
        let section = TableSection(header: header, footer: footer)
        source.addSection(section)
        
        section.setRowHeight { (_) -> CGFloat in
            return 120
        }
        let nibCellProvider = NibCellProvider(nibName: "StoreCell")
        section.addRow(StoreRow(id: "storeCell1", data: store, cellIdentifier: nil, cellPresenter: StoreNameCellPresenter(), cellProvider: nibCellProvider).setRowHeight({ (_) -> CGFloat in
            return 80
        }))
        section.addRow(StoreRow(id: "storeCell2", data: store, cellIdentifier: nil, cellPresenter: StoreOpenedCellPresenter(), cellProvider: nibCellProvider))
        section.addRow(StoreRow(id: "storeCell3", data: store, cellIdentifier: nil, cellProvider: nibCellProvider, configureCell: { (cell, store) in
            cell.label?.text = store.isOpened ? "Open" : "Closed"
        }))
    }
}
