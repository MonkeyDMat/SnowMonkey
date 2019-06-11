//
//  BaseSection.swift
//  EasyList
//
//  Created by mathieu lecoupeur on 11/07/2018.
//  Copyright © 2018 mathieu lecoupeur. All rights reserved.
//

import UIKit

public typealias IdentifiedTableSection = (id: String?, section: BaseTableSection)

// Section implements RowLayout, RowEdition, RowSelection so it can provides default values for the rows it contains
// Which allows for example to define the height of all rows in that section, without having to specify height for each rows individually

open class BaseTableSection: NSObject, RowLayoutProvider, RowEditionProvider, RowSelectionProvider {
    
    public typealias ReturnType = BaseTableSection
    
    public weak var source: TableSource?
    var rows: [IdentifiedTableRow] = []
    
    var verbose: Bool?
    private var _verbose: Bool {
        get {
            return verbose ?? source?.verbose ?? false
        }
    }
    
    // MARK: - ADD ROW
    @discardableResult
    public func addRow(_ row: RowType, at index: Int? = nil, id: String? = nil, animation: UITableView.RowAnimation? = nil) -> BaseTableSection {
        row.setSection?(section: self)
        let rowIndex = index
        
        if _verbose {
            print("[EasyList] AddRow \(row) id \(id ?? "") at \(rowIndex)")
        }
        
        source?.addRow(row, id: id, at: rowIndex, after: nil, in: self, animation: animation)
        return self
    }
    
    @discardableResult
    public func addRow<RowTypeToInsert: RowType>(_ row: RowTypeToInsert,
                                                 after predicate: @escaping (IdentifiedTableRow, RowType) -> Bool,
                                                 id: String? = nil,
                                                 animation: UITableView.RowAnimation = .automatic) -> BaseTableSection {
        row.setSection?(section: self)
        
        if _verbose {
            print("[EasyList] AddRow \(row) id \(id ?? ""))")
        }
        
        source?.addRow(row, id: id, at: nil, after: predicate, in: self, animation: animation)
        return self
    }
    
    func insert(id: String?, row: RowType, index: Int) {
        rows.insert((id, row), at: index)
    }
    
    func insert(row: IdentifiedTableRow, index: Int) {
        rows.insert(row, at: index)
    }
    
    // MARK: - UPDATE ROW
    func updateRow(_ updateBlock: () -> Void) {
        source?.updateRow(updateBlock)
    }
    
    // MARK: - DELETE ROW
    @discardableResult
    public func deleteRow(at index: Int, animation: UITableView.RowAnimation? = nil) -> BaseTableSection {
        
        if _verbose {
            print("[EasyList] DeleteRow at \(index)")
        }
        
        source?.deleteRow(at: index, in: self, animation: animation)
        return self
    }
    
    @discardableResult
    public func deleteRow(with id: String, animation: UITableView.RowAnimation? = nil) -> BaseTableSection {
        guard let identifiedRow = getRow(by: id),
            let index = getRowIndex(of: identifiedRow.row)else {
            return self
        }
        
        if _verbose {
            print("[EasyList] DeleteRow \(identifiedRow.id ?? "") at \(index)")
        }
        
        source?.deleteRow(at: index, in: self, animation: animation)
        return self
    }
    
    func removeRow(index: Int) {
        rows.remove(at: index)
    }
    
    // MARK: - HEADER
    public func getHeader() -> BaseHeader? {
        return nil
    }
    
    // MARK: - FOOTER
    public func getFooter() -> BaseFooter? {
        return nil
    }
    
    // MARK: - ROWS
    public func getRow(at index: Int) -> IdentifiedTableRow {
        return rows[index]
    }
    
    public func getRow(by id: String) -> IdentifiedTableRow? {
        var row: IdentifiedTableRow?
        
        row = rows.first { (row) -> Bool in
            return row.id == id
        }
        
        row = row ?? source?.getQueuedRow(id, in: self)
        
        return row
    }
    
    func getRowIndex(of row: RowType) -> Int? {
        return rows.firstIndex(where: { (_, currentRow) -> Bool in
            return currentRow === row
        })
    }
    
    //MARK: - Internal Methods
    internal func rowCount() -> Int {
        return rows.count
    }
    
    
    //MARK: - RowLayoutProvider
    var _height: ((RowType) -> CGFloat)?
    var _estimatedHeight: ((RowType) -> CGFloat)?
    var _selectionStyle: ((RowType) -> UITableViewCell.SelectionStyle)?
    
    @discardableResult
    open func setRowHeight(_ height: ((RowType) -> CGFloat)?) -> ReturnType {
        _height = height
        return self
    }
    
    @discardableResult
    open func setRowEstimatedHeight(_ estimatedHeight: ((RowType) -> CGFloat)?) -> ReturnType {
        _estimatedHeight = estimatedHeight
        return self
    }
    
    @discardableResult
    open func setRowSelectionStyle(_ selectionStyle: ((RowType) -> UITableViewCell.SelectionStyle)?) -> ReturnType {
        _selectionStyle = selectionStyle
        return self
    }
    
    //MARK: - RowEditionProvider
    var _editable: ((RowType) -> Bool)?
    var _editingStyle: ((RowType) -> UITableViewCell.EditingStyle)?
    var _titleForDeleteConfirmation: ((RowType) -> String?)?
    
    @discardableResult
    // ToDo add row as callback parameter
    open func setEditable(editable: ((RowType) -> Bool)?, editingStyle: ((RowType) -> UITableViewCell.EditingStyle)? = { row in return .delete}, titleForDeleteConfirmation: ((RowType) -> String?)? = nil) -> ReturnType {
        _editable = editable
        _editingStyle = editingStyle
        _titleForDeleteConfirmation = titleForDeleteConfirmation
        return self
    }
    
    //MARK: - RowSelectionProvider
    var _willSelect: ((IndexPath) -> IndexPath?)?
    var _didSelect: ((_ index: IndexPath) -> Void)?
    var _willDeselect: ((IndexPath) -> IndexPath?)?
    var _didDeselect: ((_ index: IndexPath) -> Void)?
    
    @discardableResult
    open func setWillSelect(_ willSelect: ((_ index: IndexPath) -> IndexPath?)?) -> ReturnType {
        _willSelect = willSelect
        return self
    }
    
    
    @discardableResult
    open func setDidSelect(_ didSelect: ((_ index: IndexPath) -> Void)?) -> ReturnType {
        _didSelect = didSelect
        return self
    }
    
    @discardableResult
    open func setWillDeselect(_ willDeselect: ((_ index: IndexPath) -> IndexPath?)?) -> ReturnType {
        _willDeselect = willDeselect
        return self
    }
    
    @discardableResult
    open func setDidDeselect(_ didDeselect: ((_ index: IndexPath) -> Void)?) -> ReturnType {
        _didDeselect = didDeselect
        return self
    }
}
