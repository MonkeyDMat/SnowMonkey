//
//  StoreNameCellConfigurator.swift
//  EasyListExample
//
//  Created by mathieu lecoupeur on 11/07/2018.
//  Copyright © 2018 mathieu lecoupeur. All rights reserved.
//

import Foundation
import EasyList

class StoreNameCellPresenter: BaseCellPresenter<SingleLineCell, Store> {
    override func configureCell(cell: SingleLineCell, source: Store) {
        cell.label?.text = "\(source.vocation) \(source.name)"
    }
}
