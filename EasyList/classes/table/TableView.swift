//
//  TableView.swift
//  EasyList
//
//  Created by mathieu lecoupeur on 08/07/2018.
//  Copyright © 2018 mathieu lecoupeur. All rights reserved.
//

import Foundation
import UIKit

public class TableView: UITableView {
    public var source: Source? {
        didSet {
            delegate = source
            dataSource = source
        }
    }
}
