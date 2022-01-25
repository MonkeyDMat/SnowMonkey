//
//  CustomRow.swift
//  EasyListExample
//
//  Created by mathieu lecoupeur on 17/03/2019.
//  Copyright © 2019 mathieu lecoupeur. All rights reserved.
//

import UIKit

class CustomRow: Row<String, CustomCell> {
    
    public init(id: String, text: String) {
        super.init(id: id,
                   data: text,
                   cellIdentifier: "CustomRow",
                   cellProvider: NibCellProvider(nibName: "CustomCell")) { (cell, data) in
            cell.label?.text = text
        }
    }
}
