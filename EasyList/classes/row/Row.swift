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
    @objc optional func setSection(section: BaseSection)
}

public class Row<SourceType, CellType: Cell<SourceType>>: RowType, RowLayoutProvider, RowEditionProvider, RowSelectionProvider {
    
    typealias ReturnType = Row<SourceType, CellType>
    
    var data: SourceType?
    var cellIdentifier: String?
    var cellPresenter: BaseCellPresenter<CellType, SourceType>?
    
    private var section: BaseSection?
    
    public init(data: SourceType? = nil, cellIdentifier: String? = nil, cellPresenter: BaseCellPresenter<CellType, SourceType>? = nil) {
        self.data = data
        self.cellIdentifier = cellIdentifier
        self.cellPresenter = cellPresenter
    }
    
    public init(data: SourceType? = nil, cellIdentifier: String? = nil, configureCell: @escaping (CellType, SourceType) -> Void) {
        self.data = data
        self.cellIdentifier = cellIdentifier
        let closurePresenter = ClosureCellPresenter<CellType, SourceType>(configureCell: configureCell)
        self.cellPresenter = closurePresenter
    }
    
    //MARK: - RowType
    public func getCell(tableView: UITableView) -> UITableViewCell {
        var cell: CellType?
        
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
    
    public func setSection(section: BaseSection) {
        self.section = section
    }
    
    //MARK: - RowLayoutProvider
    var _height: (() -> CGFloat)?
    var _estimatedHeight: (() -> CGFloat)?
    var _selectionStyle: (() -> UITableViewCell.SelectionStyle)?
    
    //MARK: - RowLayout
    public func rowHeight() -> CGFloat {
        return _height?() ??
            section?._height?() ??
            section?.source?._height?() ??
            CGFloat(40)
    }
    
    public func estimatedRowHeight() -> CGFloat {
        return _estimatedHeight?() ??
            section?._estimatedHeight?() ??
            section?.source?._estimatedHeight?() ??
            CGFloat(40)
    }
    
    public func selectionStyle() -> UITableViewCell.SelectionStyle {
        return _selectionStyle?() ??
            section?._selectionStyle?() ??
            section?.source?._selectionStyle?() ??
            UITableViewCell.SelectionStyle.default
    }
    
    //MARK: - RowEditionProvider
    var _editable: (() -> Bool)?
    var _editingStyle: (() -> UITableViewCell.EditingStyle)?
    var _titleForDeleteConfirmation: (() -> String?)?
    
    //MARK: - RowEdition
    public func isEditable() -> Bool {
        return _editable?() ??
            section?._editable?() ??
            section?.source?._editable?() ??
            false
    }
    public func getEditingStyle() -> UITableViewCell.EditingStyle {
        return _editingStyle?() ??
            section?._editingStyle?() ??
            section?.source?._editingStyle?() ??
            .none
    }
    public func getTitleForDeleteConfirmation() -> String? {
        return _titleForDeleteConfirmation?() ??
            section?._titleForDeleteConfirmation?() ??
            section?.source?._titleForDeleteConfirmation?()
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
