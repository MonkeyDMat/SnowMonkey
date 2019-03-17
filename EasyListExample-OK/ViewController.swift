//
//  ViewController.swift
//  EasyListExample
//
//  Created by mathieu lecoupeur on 08/07/2018.
//  Copyright © 2018 mathieu lecoupeur. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var tableView: TableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        guard let tableView = tableView else {
            return
        }
        
        let source = Source(tableView: tableView)
        
        source.addSection(Section<BaseHeader, BaseFooter>(header: nil,
                                                          footer: nil)
            .addRow(Row<String, Cell<String>>(data: "Native", cellIdentifier: nil, configureCell: { (cell, data) in
                cell.textLabel?.text = data
            }).setDidSelect({ (_) in
                print("Native")
            }))
            .addRow(Row<String, Cell<String>>(data: "Custom", cellIdentifier: nil, configureCell: { (cell, data) in
                cell.textLabel?.text = data
            }).setDidSelect({ (_) in
                print("Custom")
            }))
        )
        
        /*source.addSection(Section<NativeHeader, NativeFooter>(header: NativeHeader(title: "Native Header"),
         footer: NativeFooter(title: "Native Footer")))
         .addRow(Row<String, Cell<String>>(data: "Native Cell",
         cellIdentifier: nil,
         configureCell: { (cell, text) in
         cell.textLabel?.text = text
         }))*/
        
        /*source.addSection(Section<CustomHeader, CustomFooter>(header: CustomHeader(),
         footer: CustomFooter().setup(text: "Footer\nFooter\nFooter")).setRowHeight({ () -> CGFloat in
         return 80
         }).setRowEditable(editable: { () -> Bool in
         return true
         }, editingStyle: { () -> UITableViewCellEditingStyle in
         return .delete
         }, titleForDeleteConfirmation: { () -> String? in
         return "Delete"
         }).setDidSelect({ (index) in
         print("DID SELECT \(index.row)")
         }))
         .addRow(Row<Store, SingleLineCell>(data: store,
         cellIdentifier: "SingleLineCell",
         cellPresenter: StoreNameCellPresenter()))
         
         .addRow(Row<Store, SingleLineCell>(data: store,
         cellIdentifier: "SingleLineCell",
         cellPresenter: StoreOpenedCellPresenter()))
         
         .addRow(Row<Store, SingleLineCell>(data: store,
         cellIdentifier: "SingleLineCell",
         configureCell: { (cell, store) in
         cell.label?.text = store.isOpened ? "Open" : "Closed"
         }))*/
    }
}

extension ViewController: SourceDelegate {
    
}
