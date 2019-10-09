//
//  NativeCollectionViewController.swift
//  EasyListExample
//
//  Created by Red10 on 12/04/2019.
//  Copyright © 2019 mathieu lecoupeur. All rights reserved.
//

import UIKit

class NativeCollectionViewController: UIViewController {
    @IBOutlet var collection: CollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let collection = collection else {
            return
        }
        
        let source = CollectionSource(collection: collection)
        
        let section = CollectionSection()
        
        let store1 = Store(vocation: "Express", name: "Intermarche", isOpened: true)
        let store2 = Store(vocation: "Cash", name: "Intermarche", isOpened: true)
        
        source.addSection(section)
            .addItem(StoreCollectionItem(data: store1, itemIdentifier: "test", indexPath: IndexPath(item: 0, section: 0), configureItem: { (store, cell) in
                cell.name.text = "\(store.vocation) \(store.name)"
        }))
            .addItem(StoreCollectionItem(data: store2, itemIdentifier: "test", indexPath: IndexPath(item: 0, section: 0), configureItem: { (store, cell) in
                cell.name.text = "\(store.vocation) \(store.name)"
            }))
        
        /*source.setRowSelectionStyle { (_) -> UITableViewCell.SelectionStyle in
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
        }*/
    }
}
