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
        
        let source = TableSource(tableView: tableView)
        source.setRowSelectionStyle { (_) -> UITableViewCell.SelectionStyle in
            return .none
        }
        
        // Table
        let tableSection = TableSection(header: NativeHeader(title: "Table"), footer: nil)
        source.addSection(tableSection)
        
        // Native
        let native = NativeRow(text: "Native")
        native.setDidSelect { (_) in
            self.show(sample: .native)
        }
        tableSection.addRow(native)
        
        
        // Custom
        let custom = NativeRow(text: "Custom")
        custom.setDidSelect { (_) in
            self.show(sample: .custom)
        }
        tableSection.addRow(custom)
        
        
        // CustomData
        let customData = NativeRow(text: "Custom data")
        customData.setDidSelect { (_) in
            self.show(sample: .customData)
        }
        tableSection.addRow(customData)
        
        
        // Configuration
        let configuration = NativeRow(text: "Configuration")
        configuration.setDidSelect { (_) in
            self.show(sample: .configuration)
        }
        tableSection.addRow(configuration)
        
        
        // Editable
        let editable = NativeRow(text: "Editable")
        editable.setDidSelect { (_) in
            self.show(sample: .editable)
        }
        tableSection.addRow(editable)
        
        
        // Animated
        let animated = NativeRow(text: "Animated")
        animated.setDidSelect { (_) in
            self.show(sample: .animated)
        }
        tableSection.addRow(animated)
        
        
        // Animated
        let grouped = NativeRow(text: "Grouped")
        grouped.setDidSelect { (_) in
            self.show(sample: .grouped)
        }
        tableSection.addRow(grouped)
        
        // Collection
        let collectionSection = TableSection(header: NativeHeader(title: "Collection"), footer: nil)
        source.addSection(collectionSection)
        
        // Native
        let nativeCollection = NativeRow(text: "Native Collection")
        nativeCollection.setDidSelect { (_) in
            self.show(sample: .nativeCollection)
        }
        collectionSection.addRow(nativeCollection)
    }
    
    private func show(sample: Sample) {
        var vc: UIViewController?
        switch sample {
        case .native:
            let storyBoard = UIStoryboard(name: "NativeTable", bundle: nil)
            vc = storyBoard.instantiateViewController(withIdentifier: "NativeTableViewController")
        case .custom:
            let storyBoard = UIStoryboard(name: "CustomTable", bundle: nil)
            vc = storyBoard.instantiateViewController(withIdentifier: "CustomTableViewController")
        case .customData:
            let storyBoard = UIStoryboard(name: "CustomDataTable", bundle: nil)
            vc = storyBoard.instantiateViewController(withIdentifier: "CustomDataTableViewController")
        case .configuration:
            let storyBoard = UIStoryboard(name: "ConfigurationTable", bundle: nil)
            vc = storyBoard.instantiateViewController(withIdentifier: "ConfigurationTableViewController")
        case .editable:
            let storyBoard = UIStoryboard(name: "EditableTable", bundle: nil)
            vc = storyBoard.instantiateViewController(withIdentifier: "EditableTableViewController")
        case .animated:
            let storyBoard = UIStoryboard(name: "AnimatedTable", bundle: nil)
            vc = storyBoard.instantiateViewController(withIdentifier: "AnimatedTableViewController")
        case .grouped:
            let storyBoard = UIStoryboard(name: "GroupedTable", bundle: nil)
            vc = storyBoard.instantiateViewController(withIdentifier: "GroupedTableViewController")
        case .nativeCollection:
            let storyBoard = UIStoryboard(name: "NativeCollection", bundle: nil)
            vc = storyBoard.instantiateViewController(withIdentifier: "NativeCollectionViewController")
        }
        
        guard let viewController = vc else {
            print("Sample not found : " + sample.rawValue)
            return
        }
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension ViewController: TableSourceDelegate {
}

private enum Sample: String {
    case native = "Native"
    case custom = "Custom"
    case customData = "CustomData"
    case configuration = "Configuration"
    case editable = "Editable"
    case animated = "Animated"
    case grouped = "Grouped"
    
    case nativeCollection = "NativeCollection"
}
