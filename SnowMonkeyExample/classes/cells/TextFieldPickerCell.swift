//
//  TextFieldRow.swift
//  SnowMonkeyExample
//
//  Created by Red10 on 04/03/2021.
//  Copyright © 2021 mathieu lecoupeur. All rights reserved.
//

import UIKit

class TextFieldPickerRow: Row<String, TextFieldPickerCell> {
    
    public init(text: String) {
        super.init(id: "",
                   data: text,
                   cellIdentifier: "TextFieldPickerRow",
                   cellProvider: NibCellProvider(nibName: "TextFieldPickerCell")) { (cell, data) in
            cell.textfield?.text = text
            
            let pickerView = PickerView()
            let pickerSource = PickerSource(picker: pickerView, delegate: nil)
            pickerSource.setup(rows: [PickerRow(id: "val1", text: "Valeur 1"),
                                      PickerRow(id: "val1", attributedText: NSAttributedString(string: "Valeur 2", attributes: [NSAttributedString.Key.foregroundColor : UIColor.red])),
                                      PickerRow(id: "val1", text: "Valeur 3"),
                                      PickerRow(id: "val1", text: "Valeur 4"),
                                      PickerRow(id: "val1", text: "Valeur 5")])
            cell.textfield?.inputView = pickerView
        }
    }
}

class TextFieldPickerCell: TableCell<String> {
    @IBOutlet weak var textfield: UITextField?
}
