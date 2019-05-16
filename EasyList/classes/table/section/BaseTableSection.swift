//
//  BaseSection.swift
//  EasyList
//
//  Created by mathieu lecoupeur on 11/07/2018.
//  Copyright © 2018 mathieu lecoupeur. All rights reserved.
//

import UIKit

// Section implements RowLayout, RowEdition, RowSelection so it can provides default values for the rows it contains
// Which allows for example to define the height of all rows in that section, without having to specify height for each rows individually

open class BaseTableSection: NSObject, RowLayoutProvider, RowEditionProvider, RowSelectionProvider {
    
    typealias ReturnType = BaseTableSection
    
    public weak var source: TableSource?
    var rows: [RowType] = []
    
    @discardableResult
    public func addRow(_ row: RowType, at index: Int? = nil, animation: UITableView.RowAnimation? = nil) -> BaseTableSection {
        row.setSection?(section: self)
        let rowIndex = index ?? rows.count
        rows.insert(row, at: rowIndex)
        source?.addRow(at: rowIndex, in: self, animation: animation)
        return self
    }
    
    @discardableResult
    public func addRow<RowTypeToInsert: RowType>(_ row: RowTypeToInsert,
                                                 after predicate: (RowType, RowTypeToInsert) -> Bool,
                                                 animation: UITableView.RowAnimation = .automatic) -> BaseTableSection {
        row.setSection?(section: self)
        var rowIndex = 0
        for (currentIndex, currentRow) in rows.enumerated() {
            if predicate(currentRow, row) {
                rowIndex = max(rowIndex, currentIndex + 1)
            }
        }
        rows.insert(row, at: rowIndex)
        source?.addRow(at: rowIndex, in: self, animation: animation)
        return self
    }
    
    @discardableResult
    public func deleteRow(at index: Int, animation: UITableView.RowAnimation? = nil) -> BaseTableSection {
        rows.remove(at: index)
        source?.deleteRow(at: index, in: self, animation: animation)
        return self
    }
    
    @discardableResult
    public func deleteAllRow(where predicate: (RowType) -> Bool) -> BaseTableSection {
        rows.removeAll(where: predicate)
        return self
    }
    
    @discardableResult
    public func deleteAllRows() -> BaseTableSection {
        rows.removeAll()
        return self
    }
    
    public func getHeader() -> BaseHeader? {
        return nil
    }
    
    public func getFooter() -> BaseFooter? {
        return nil
    }
    
    public func getRow(at index: Int) -> RowType {
        return rows[index]
    }
    
    //MARK: - Internal Methods
    internal func rowCount() -> Int {
        return rows.count
    }
    
    
    //MARK: - RowLayoutProvider
    var _height: ((RowType) -> CGFloat)?
    var _estimatedHeight: ((RowType) -> CGFloat)?
    var _selectionStyle: ((RowType) -> UITableViewCell.SelectionStyle)?
    
    //MARK: - RowEditionProvider
    var _editable: ((RowType) -> Bool)?
    var _editingStyle: ((RowType) -> UITableViewCell.EditingStyle)?
    var _titleForDeleteConfirmation: ((RowType) -> String?)?
    
    //MARK: - RowSelectionProvider
    var _willSelect: ((IndexPath) -> IndexPath?)?
    var _didSelect: ((_ index: IndexPath) -> Void)?
    var _willDeselect: ((IndexPath) -> IndexPath?)?
    var _didDeselect: ((_ index: IndexPath) -> Void)?
}
