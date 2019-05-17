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


public typealias IdentifiedTableRow = (id: String?, row: RowType)

open class Row<SourceType, CellType: TableCell<SourceType>>: RowType, RowLayoutProvider, RowEditionProvider, RowSelectionProvider {
    
    typealias ReturnType = Row<SourceType, CellType>
    
    var data: SourceType?
    open var cell: CellType?
    var cellIdentifier: String?
    var cellPresenter: BaseCellPresenter<CellType, SourceType>?
    
    private var section: BaseTableSection?
    
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
