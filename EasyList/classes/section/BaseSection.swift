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

public class BaseSection: NSObject, RowLayoutProvider, RowEditionProvider, RowSelectionProvider {
    
    
    typealias ReturnType = BaseSection
    
    public weak var source: Source?
    var rows: [RowType] = []
    
    @discardableResult
    public func addRow(_ row: RowType) -> BaseSection {
        row.setSection?(section: self)
        rows.append(row)
        return self
    }
    
    @discardableResult
    public func addRow(_ row: RowType, at index: Int) -> BaseSection {
        row.setSection?(section: self)
        rows.insert(row, at: index)
        return self
    }
    
    @discardableResult
    public func deleteRow(at index: Int) -> BaseSection {
        rows.remove(at: index)
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
    var _height: (() -> CGFloat)?
    var _estimatedHeight: (() -> CGFloat)?
    var _selectionStyle: (() -> UITableViewCell.SelectionStyle)?
    
    //MARK: - RowEditionProvider
    var _editable: (() -> Bool)?
    var _editingStyle: (() -> UITableViewCell.EditingStyle)?
    var _titleForDeleteConfirmation: (() -> String?)?
    
    //MARK: - RowSelectionProvider
    var _willSelect: ((IndexPath) -> IndexPath?)?
    var _didSelect: ((_ index: IndexPath) -> Void)?
    var _willDeselect: ((IndexPath) -> IndexPath?)?
    var _didDeselect: ((_ index: IndexPath) -> Void)?
}
