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
        source.addSection(tableSection, id: "table")
        
        // Native
        let native = NativeRow(id: "native", text: "Native")
        native.setDidSelect { (_) in
            self.show(sample: .native)
        }
        
        
        // Custom
        let custom = NativeRow(id: "custom", text: "Custom")
        custom.setDidSelect { (_) in
            self.show(sample: .custom)
        }
        
        
        // CustomData
        let customData = NativeRow(id: "customData", text: "Custom data")
        customData.setDidSelect { (_) in
            self.show(sample: .customData)
        }
        
        
        // Configuration
        let configuration = NativeRow(id: "configuration", text: "Configuration")
        configuration.setDidSelect { (_) in
            self.show(sample: .configuration)
        }
        
        
        // Editable
        let editable = NativeRow(id: "editable", text: "Editable")
        editable.setDidSelect { (_) in
            self.show(sample: .editable)
        }
        
        
        // Animated
        let animated = NativeRow(id: "animated", text: "Animated")
        animated.setDidSelect { (_) in
            self.show(sample: .animated)
        }
        
        
        // Grouped
        let grouped = NativeRow(id: "grouped", text: "Grouped")
        grouped.setDidSelect { (_) in
            self.show(sample: .grouped)
        }
        
        
        // Insertion
        let insertion = NativeRow(id: "insertion", text: "Insertion")
        insertion.setDidSelect { (_) in
            self.show(sample: .insertion)
        }
        
        tableSection.addRows([native, custom, customData, configuration])
        tableSection.addRow(editable)
        tableSection.addRows([animated, grouped, insertion])
        
        // Collection
        let collectionSection = TableSection(header: NativeHeader(title: "Collection"), footer: nil)
        source.addSection(collectionSection, id: "collection")
        
        // Native
        let nativeCollection = NativeRow(id: "nativeCollection", text: "Native Collection")
        nativeCollection.setDidSelect { (_) in
            self.show(sample: .nativeCollection)
        }
        collectionSection.addRow(nativeCollection)
        
        // Picker
        let pickerSection = TableSection(header: NativeHeader(title: "Picker"), footer: nil)
        source.addSection(pickerSection, id: "picker")
        
        // Native
        let pickerRow = NativeRow(text: "Picker")
        pickerRow.setDidSelect { (_) in
            self.show(sample: .picker)
        }
        pickerSection.addRow(pickerRow)
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
        case .insertion:
            let storyBoard = UIStoryboard(name: "InsertionTable", bundle: nil)
            vc = storyBoard.instantiateViewController(withIdentifier: "InsertionTableViewController")
        case .nativeCollection:
            let storyBoard = UIStoryboard(name: "NativeCollection", bundle: nil)
            vc = storyBoard.instantiateViewController(withIdentifier: "NativeCollectionViewController")
            
        case .picker:
            let storyBoard = UIStoryboard(name: "PickerView", bundle: nil)
            vc = storyBoard.instantiateViewController(withIdentifier: "PickerViewController")
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
    case insertion = "Insertion"
    
    case nativeCollection = "NativeCollection"
    
    case picker = "Picker"
}
