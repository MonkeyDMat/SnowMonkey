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

public class BaseSection: NSObject {
    
    public weak var source: Source?
    var rows: [RowType] = []
    
    @discardableResult
    public func addRow(_ row: RowType) -> BaseSection {
        row.setSection?(section: self)
        rows.append(row)
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
    
    
    //MARK: - RowLayout
    var _height: (() -> CGFloat)?
    @discardableResult
    public func setRowHeight(_ height: (() -> CGFloat)?) -> BaseSection {
        _height = height
        return self
    }
    
    var _estimatedHeight: (() -> CGFloat)?
    @discardableResult
    public func setEstimatedRowHeight(_ estimatedHeight: (() -> CGFloat)?) -> BaseSection {
        _estimatedHeight = estimatedHeight
        return self
    }
    
    //MARK: - RowEdition
    var _editable: (() -> Bool)?
    var _editingStyle: (() -> UITableViewCell.EditingStyle)?
    var _titleForDeleteConfirmation: (() -> String?)?
    @discardableResult
    public func setRowEditable(editable: (() -> Bool)?, editingStyle: (() -> UITableViewCell.EditingStyle)? = {return .delete}, titleForDeleteConfirmation: (() -> String?)? = nil) -> BaseSection {
        _editable = editable
        _editingStyle = editingStyle
        _titleForDeleteConfirmation = titleForDeleteConfirmation
        return self
    }
    
    //MARK: - RowSelection
    var _willSelect: ((_ index: IndexPath) -> IndexPath)?
    @discardableResult
    public func setWillSelect(_ willSelect: ((_ index: IndexPath) -> IndexPath)?) -> BaseSection {
        _willSelect = willSelect
        return self
    }
    
    var _didSelect: ((_ index: IndexPath) -> Void)?
    @discardableResult
    public func setDidSelect(_ didSelect: ((_ index: IndexPath) -> Void)?) -> BaseSection {
        _didSelect = didSelect
        return self
    }
    
    var _willDeselect: ((_ index: IndexPath) -> IndexPath)?
    @discardableResult
    public func setWillDeselect(_ willDeselect: ((_ index: IndexPath) -> IndexPath)?) -> BaseSection {
        _willDeselect = willDeselect
        return self
    }
    
    var _didDeselect: ((_ index: IndexPath) -> Void)?
    @discardableResult
    public func setDidDeselect(_ didDeselect: ((_ index: IndexPath) -> Void)?) -> BaseSection {
        _didDeselect = didDeselect
        return self
    }
}
