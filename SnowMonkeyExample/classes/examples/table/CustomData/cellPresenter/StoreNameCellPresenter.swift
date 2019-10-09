//
//  StoreNameCellConfigurator.swift
//  EasyListExample
//
//  Created by mathieu lecoupeur on 11/07/2018.
//  Copyright © 2018 mathieu lecoupeur. All rights reserved.
//

import Foundation

class StoreNameCellPresenter: BaseCellPresenter<StoreCell, Store> {
    override func configureCell(cell: Cell, source: Store) {
        cell.label?.text = "\(source.vocation) \(source.name)"
    }
}
