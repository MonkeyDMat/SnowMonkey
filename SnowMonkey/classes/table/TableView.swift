//
//  TableView.swift
//  EasyList
//
//  Created by mathieu lecoupeur on 08/07/2018.
//  Copyright © 2018 mathieu lecoupeur. All rights reserved.
//

import Foundation
import UIKit

open class TableView: UITableView {
    var id: String?
    
    public var source: TableSource? {
        didSet {
            delegate = source
            dataSource = source
        }
    }
}
