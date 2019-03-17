//
//  CellPresenter.swift
//  EasyList
//
//  Created by mathieu lecoupeur on 11/07/2018.
//  Copyright © 2018 mathieu lecoupeur. All rights reserved.
//

import Foundation

public protocol CellPresenter {
    associatedtype Cell
    associatedtype Source
    
    func configureCell(cell: Cell, source: Source)
}

open class BaseCellPresenter<BaseCell, BaseSource>: CellPresenter {
    public typealias Cell = BaseCell
    public typealias Source = BaseSource
    open func configureCell(cell: BaseCell, source: BaseSource) {}
    
    public init() {
    }
}
