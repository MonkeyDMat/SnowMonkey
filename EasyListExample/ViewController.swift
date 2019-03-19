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
        source.setRowSelectionStyle { () -> UITableViewCell.SelectionStyle in
            return .none
        }
        
        let section = Section(header: NativeHeader(title: "Examples"), footer: nil)
        source.addSection(section)
        
        // Native
        let native = NativeRow(text: "Native")
        native.setDidSelect { (_) in
            self.show(sample: .native)
        }
        section.addRow(native)
        
        
        // Custom
        let custom = NativeRow(text: "Custom")
        custom.setDidSelect { (_) in
            self.show(sample: .custom)
        }
        section.addRow(custom)
        
        
        // CustomData
        let customData = NativeRow(text: "Custom data")
        customData.setDidSelect { (_) in
            self.show(sample: .customData)
        }
        section.addRow(customData)
        
        
        // Configuration
        let configuration = NativeRow(text: "Configuration")
        configuration.setDidSelect { (_) in
            self.show(sample: .configuration)
        }
        section.addRow(configuration)
        
        
        // Editable
        let editable = NativeRow(text: "Editable")
        editable.setDidSelect { (_) in
            self.show(sample: .editable)
        }
        section.addRow(editable)
        
        
        // Animated
        let animated = NativeRow(text: "Animated")
        animated.setDidSelect { (_) in
            self.show(sample: .animated)
        }
        section.addRow(animated)
        
        
        
        
        /*
        // Section 2
        let header2 = CustomHeader()
        header2.action = { (header) in
            let row = Row(data: store,
                          cellIdentifier: "SingleLineCell",
                          cellPresenter: StoreNameCellPresenter()).setHeight({ () -> CGFloat in
                            return 40
                          })
            source.addRow(row, at: IndexPath(row: 1, section: 1), animation: .fade)
        }
        let footer2 = CustomFooter()
        footer2.setup(text: "FOOTER 2")
        let section2 = Section(header: header2, footer: footer2)
        
        section2.addRow(Row(data: store,
                            cellIdentifier: "SingleLineCell",
                            cellPresenter: StoreNameCellPresenter()).setHeight({ () -> CGFloat in
                                return 40
                            }))
        
        section2.addRow(Row(data: store,
                            cellIdentifier: "SingleLineCell",
                            cellPresenter: StoreOpenedCellPresenter()))
        
        source.addSection(section2)*/
        
        
        
        /*source.addSection(Section<BaseHeader, BaseFooter>(header: nil,
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
         )*/
        
        /*source.addSection(Section<NativeHeader, NativeFooter>(header: NativeHeader(title: "Native Header"),
         footer: NativeFooter(title: "Native Footer")))
         .addRow(Row<String, Cell<String>>(data: "Native Cell",
         cellIdentifier: nil,
         configureCell: { (cell, text) in
         cell.textLabel?.text = text
         }))*/
        
        
        /*source.addSection(Section(header: CustomHeader(), footer: CustomFooter().setup(text: "Footer\nFooter\nFooter")).setRowHeight({ () -> CGFloat in
            return 80
        }).setRowEditable(editable: { () -> Bool in
            return true
        }, editingStyle: { () -> UITableViewCell.EditingStyle in
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
    
    private func show(sample: Sample) {
        var vc: UIViewController?
        switch sample {
        case .native:
            let storyBoard = UIStoryboard(name: "Native", bundle: nil)
            vc = storyBoard.instantiateViewController(withIdentifier: "NativeViewController")
        case .custom:
            let storyBoard = UIStoryboard(name: "Custom", bundle: nil)
            vc = storyBoard.instantiateViewController(withIdentifier: "CustomViewController")
        case .customData:
            let storyBoard = UIStoryboard(name: "CustomData", bundle: nil)
            vc = storyBoard.instantiateViewController(withIdentifier: "CustomDataViewController")
        case .configuration:
            let storyBoard = UIStoryboard(name: "Configuration", bundle: nil)
            vc = storyBoard.instantiateViewController(withIdentifier: "ConfigurationViewController")
        case .editable:
            let storyBoard = UIStoryboard(name: "Editable", bundle: nil)
            vc = storyBoard.instantiateViewController(withIdentifier: "EditableViewController")
        case .animated:
            let storyBoard = UIStoryboard(name: "Animated", bundle: nil)
            vc = storyBoard.instantiateViewController(withIdentifier: "AnimatedViewController")
        }
        
        guard let viewController = vc else {
            print("Sample not found : " + sample.rawValue)
            return
        }
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension ViewController: SourceDelegate {
}

private enum Sample: String {
    case native = "Native"
    case custom = "Custom"
    case customData = "CustomData"
    case configuration = "Configuration"
    case editable = "Editable"
    case animated = "Animated"
}
