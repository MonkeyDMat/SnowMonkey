//
//  TextFieldRow.swift
//  SnowMonkeyExample
//
//  Created by Red10 on 04/03/2021.
//  Copyright © 2021 mathieu lecoupeur. All rights reserved.
//

import UIKit

class TextFieldPickerRow: NibRow<String, TextFieldPickerCell> {
    
    public init(text: String) {
        super.init(data: text, cellIdentifier: "TextFieldPickerRow", nibName: "TextFieldPickerCell") { (cell, data) in
            cell.textfield?.text = text
            
            let pickerView = PickerView()
            let pickerSource = PickerSource(picker: pickerView, delegate: nil)
            pickerSource.setup(rows: [PickerRow(text: "Valeur 1"),
                                      PickerRow(attributedText: NSAttributedString(string: "Valeur 2", attributes: [NSAttributedString.Key.foregroundColor : UIColor.red])),
                                      PickerRow(text: "Valeur 3"),
                                      PickerRow(text: "Valeur 4"),
                                      PickerRow(text: "Valeur 5")])
            cell.textfield?.inputView = pickerView
        }
    }
}

class TextFieldPickerCell: TableCell<String> {
    @IBOutlet weak var textfield: UITextField?
}
