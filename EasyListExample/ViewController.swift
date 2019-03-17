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
        
        
        
        
        /*let source = Source(tableView: tableView)
        source.setRowHeight { () -> CGFloat in
            return 120
        }
        
        let store = Store(vocation: "Express", name: "Paris", isOpened: true)
        
        source.setDidSelect { (index) in
            print("SOURCE DID SELECT \(index.row)")
        }*/
        
        // Section 1
        /*let header1 = CustomHeader()
        header1.action = { (header) in
            if let tableView = header.section?.source?.tableView {
                tableView.setEditing(!tableView.isEditing, animated: true)
                header.actionButton.setTitle(tableView.isEditing ? "Terminer" : "Editer", for: .normal)
            }
        }
        
        let footer1 = CustomFooter()
        footer1.setup(text: "Footer\nFooter\nFooter")
        
        let section1 = Section(header: header1, footer: footer1)
        section1.setRowHeight { () -> CGFloat in
            return 80
        }
        
        section1.setRowEditable(editable: { () -> Bool in
                return true
            }, editingStyle: { () -> UITableViewCell.EditingStyle in
                return .delete
            }) { () -> String? in
                    return "Supprimer"
            }
        
        section1.setDidSelect { (index) in
            print("SECTION DID SELECT \(index.row)")
        }
        
        // Rows
        // Name
        section1.addRow(Row(data: store,
                           cellIdentifier: "SingleLineCell",
                           cellPresenter: StoreNameCellPresenter()).setHeight({ () -> CGFloat in
                            return 60
                           }).setDidSelect({ (index) in
                            print("ROW DID SELECT : \(index.row)")
                           }))
        
        // Opened
        section1.addRow(Row(data: store,
                           cellIdentifier: "SingleLineCell",
                           cellPresenter: StoreOpenedCellPresenter()))
        
        // Opened Bis EN
        section1.addRow(Row<Store, SingleLineCell>(data: store,
                                                  cellIdentifier: "SingleLineCell",
                                                  configureCell: { (cell, store) in
                                                    cell.label?.text = store.isOpened ? "Open" : "Closed"
        }))
        
        source.addSection(section1)
        
        
        // Section 2
        let header2 = CustomHeader()
        header2.action = { (header) in
            let row = Row(data: store,
                          cellIdentifier: "SingleLineCell",
                          cellPresenter: StoreNameCellPresenter()).setHeight({ () -> CGFloat in
                            return 40
                          })
            source.insertRow(row, at: IndexPath(row: 1, section: 1), animation: .fade)
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
        default:
            ()
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
