//
//  CellClosurePresenter.swift
//  EasyList
//
//  Created by mathieu lecoupeur on 14/07/2018.
//  Copyright © 2018 mathieu lecoupeur. All rights reserved.
//

import Foundation

open class ClosureCellPresenter<BaseCell, BaseSource>: BaseCellPresenter<BaseCell, BaseSource> {
    public typealias Cell = BaseCell
    public typealias Source = BaseSource
    
    private var configureCell: (BaseCell, BaseSource) -> Void
    
    init(configureCell: @escaping (BaseCell, BaseSource) -> Void) {
        self.configureCell = configureCell
    }
    
    open override func configureCell(cell: BaseCell, source: BaseSource) {
        configureCell(cell, source)
    }
}

