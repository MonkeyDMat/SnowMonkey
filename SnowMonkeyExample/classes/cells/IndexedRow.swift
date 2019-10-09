//
//  IndexedRow.swift
//  EasyListExample
//
//  Created by mathieu lecoupeur on 19/03/2019.
//  Copyright © 2019 mathieu lecoupeur. All rights reserved.
//

import Foundation

public class IndexedRow: Row<Int, IndexedCell> {
    
    var index: Int
    
    public init(index: Int) {
        self.index = index
        super.init(data: index, cellIdentifier: nil) { (cell, data) in
            cell.textLabel?.text = "CELL \(index)"
        }
    }
}
