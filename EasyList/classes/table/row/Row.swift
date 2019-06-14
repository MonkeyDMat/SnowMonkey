//
//  Row.swift
//  EasyList
//
//  Created by mathieu lecoupeur on 08/07/2018.
//  Copyright © 2018 mathieu lecoupeur. All rights reserved.
//

import UIKit

@objc public protocol RowType: RowLayout, RowEdition, RowSelection {
    func getCell(tableView: UITableView) -> UITableViewCell
    @objc optional func setSection(section: BaseTableSection)
}

public struct IndexedTableRow {
    var index: IndexPath?
    var identifiedRow: IdentifiedTableRow?
    
    init(index: IndexPath?, identifiedRow: IdentifiedTableRow?) {
        self.index = index
        self.identifiedRow = identifiedRow
    }
    
    init(row: RowType, index: IndexPath? = nil, id: String? = nil) {
        self = IndexedTableRow(index: index, identifiedRow: IdentifiedTableRow(id: id, row: row))
    }
}

public struct IdentifiedTableRow {
    var id: String?
    var row: RowType
}

open class Row<SourceType, CellType: TableCell<SourceType>>: RowType, RowLayoutProvider, RowEditionProvider, RowSelectionProvider {
    
    public typealias ReturnType = Row<SourceType, CellType>
    
    var data: SourceType?
    open var cell: CellType?
    var cellIdentifier: String?
    var cellPresenter: BaseCellPresenter<CellType, SourceType>?
    
    private var section: BaseTableSection?
    
    var verbose: Bool?
    private var _verbose: Bool {
        get {
            return verbose ?? section?.verbose ?? false
        }
    }
    
    public init(data: SourceType? = nil, cellIdentifier: String? = nil, cellPresenter: BaseCellPresenter<CellType, SourceType>? = nil) {
        self.data = data
        self.cellIdentifier = cellIdentifier
        self.cellPresenter = cellPresenter
    }
    
    public init(data: SourceType? = nil, cellIdentifier: String? = nil, configureCell: @escaping (CellType, SourceType) -> Void) {
        self.data = data
        self.cellIdentifier = cellIdentifier
        let closurePresenter = CellClosurePresenter<CellType, SourceType>(configureCell: configureCell)
        self.cellPresenter = closurePresenter
    }
    
    open func updateRow(data: SourceType) {
        if cell != nil {
            section?.updateRow({
                self.data = data
                cellPresenter?.configureCell(cell: cell!, source: data)
            })
        }
    }
    
    //MARK: - RowType
    public func getCell(tableView: UITableView) -> UITableViewCell {
        if let cellIdentifier = cellIdentifier {
            tableView.register(CellType.self, forCellReuseIdentifier: cellIdentifier)
            cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? CellType
        } else {
            cell = CellType(frame: CGRect.zero)
        }
        
        cell?.layoutSubviews()
        
        if let data = data, cell != nil {
            cellPresenter?.configureCell(cell: cell!, source: data)
        }
        
        return cell ?? UITableViewCell()
    }
    
    public func setSection(section: BaseTableSection) {
        self.section = section
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
    
    //MARK: - RowLayout
    public func rowHeight() -> CGFloat {
        return _height?(self) ??
            section?._height?(self) ??
            section?.source?._height?(self) ??
            UITableView.automaticDimension
    }
    
    public func estimatedRowHeight() -> CGFloat {
        return _estimatedHeight?(self) ??
            section?._estimatedHeight?(self) ??
            section?.source?._estimatedHeight?(self) ??
            UITableView.automaticDimension
    }
    
    public func selectionStyle() -> UITableViewCell.SelectionStyle {
        return _selectionStyle?(self) ??
            section?._selectionStyle?(self) ??
            section?.source?._selectionStyle?(self) ??
            cell?.selectionStyle ??
            UITableViewCell.SelectionStyle.default
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
    
    //MARK: - RowEdition
    public func isEditable() -> Bool {
        return _editable?(self) ??
            section?._editable?(self) ??
            section?.source?._editable?(self) ??
            false
    }
    public func getEditingStyle() -> UITableViewCell.EditingStyle {
        return _editingStyle?(self) ??
            section?._editingStyle?(self) ??
            section?.source?._editingStyle?(self) ??
            .none
    }
    public func getTitleForDeleteConfirmation() -> String? {
        return _titleForDeleteConfirmation?(self) ??
            section?._titleForDeleteConfirmation?(self) ??
            section?.source?._titleForDeleteConfirmation?(self)
    }
    
    //MARK: - RowSelectionProvider
    var _willSelect: ((_ index: IndexPath) -> IndexPath?)?
    var _didSelect: ((_ index: IndexPath) -> Void)?
    var _willDeselect: ((_ index: IndexPath) -> IndexPath?)?
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
    
    //MARK: - RowSelection
    public func willSelect(index: IndexPath) -> IndexPath? {
        return _willSelect?(index) ??
            section?._willSelect?(index) ??
            section?.source?._willSelect?(index) ??
            index
    }
    
    public func didSelect(index: IndexPath) {
        _didSelect?(index) ??
            section?._didSelect?(index) ??
            section?.source?._didSelect?(index)
    }
    
    public func willDeselect(index: IndexPath) -> IndexPath? {
        return _willDeselect?(index) ??
            section?._willDeselect?(index) ??
            section?.source?._willDeselect?(index) ??
            index
    }
    
    public func didDeselect(index: IndexPath) {
        _didDeselect?(index) ??
            section?._didDeselect?(index) ??
            section?.source?._didDeselect?(index)
    }
}
